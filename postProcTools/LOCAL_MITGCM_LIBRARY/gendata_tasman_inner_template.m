%% This is a matlab script that generates input for the MITgcm model

% philosophy: push all generic operations like writing of outfput files
% into helper subroutines. This code should contain only experiment
% specific modifications

clear;warning off
addpath LOCAL_MITGCM_LIBRARY % make sure we have the consistent version of the MITGCM library, superceding the ~/matlab/MITGCM version
%----------------------------------------------------------------------
% some basic parameters that can allow for easy configuration
%----------------------------------------------------------------------
model_version = ''; % a flag you can set if you want

ifcartesian  = 1; % ifcartesian = 0 is spherical (lon,lat) grid 
BT=0;nconsts = 1; ifplottpxo=0;  rotateit=0;MODEL.toposmoo = 2;use_sam_kelly_structure=0;OB.smoo=9;OB.flux_mag=10;

if ifcartesian 
	MODEL.dX0 = 8000;MODEL.dY0 = 8000; fac = 8000/MODEL.dX0 % model resolutions
	MODEL.rotate_angle=-32; MODEL.lon0=143+1.5;MODEL.lat0=-44.4;   % angle that cartesian grid is rotated,  geographic origin of cartesian grid
else
	MODEL.dX0 = 0.125;MODEL.dY0 = 0.125;MODEL.lon0=-216+360-2;MODEL.lat0=-49; fac = .125/MODEL.dX0;  % resolution and origin of model grid
end	

MODEL.Nx=round(fac*120);MODEL.Ny=round(fac*85);                    % number of gridpoints

%vstretch = 1;	MODEL.Nz=100;MODEL.delZ0=10;MODEL.delZ1=90; % linear stretching
vstretch = 0;	MODEL.Res_Z=50;

% adjust delXfine & delYfine to fine tune number of gridpoints in stretch
% grid
%-------------------------------------------------------------------------------
MODEL.hstretch = 0    ;STRETCH.delXfine  =   8e3;STRETCH.delYfine  =   8e3;STRETCH.delXcoarse =   8e3 ;STRETCH.xsigwidth  = 2;
STRETCH.LfineX = 200e3;STRETCH.Lcoarse1X = 75e3;STRETCH.Lcoarse1Y  = 225e3 ;%MODEL.offshoresmoo = 0;

               
% set offshoresmoo to 1 to smooth topography at edges and offshore. Only
% for cartesian grid at this time
%------------------------------------------------------
MODEL.offshoresmoo=0; 
MODEL.offshoresmoo=1; MODEL.smoofac=round(3*fac+1);MODEL.eastsmoo=600e3;MODEL.northsmoo=600e3;MODEL.southsmoo=100e3;

MODEL.H_max = 5000;
MODEL.H_min =   50;

% extract the regional topography that will be regridded for the model
%------------------------------------------------
MODEL.toposrcfile = '~/PROJ/TTide/MFILES/HLS_TASMAN_OZ_4.mat';    
MITGCM_extract_topo(-225+360,-180+360,-60,-30,2,'/home/hsimmons/DATA/TOPO/topo30.grd',MODEL.toposrcfile);done('extract topo')

%------------------------------------------------
% specify the Cartesian grid
%------------------------------------------------
if ifcartesian
	MODEL=MITGCM_regrid_topo_cartesian(MODEL,STRETCH)       ;done('regrid topo');%return
else
	MODEL=MITGCM_regrid_topo_spherical(MODEL)
end	
%-----------------------------------------
%% z-grid
%-----------------------------------------

if ~vstretch
	MODEL.Nz   =ceil(MODEL.H_max/MODEL.Res_Z);
	MODEL.delZ =ones(MODEL.Nz,1)*MODEL.Res_Z;
	MODEL.Z    =cumsum(MODEL.delZ)-MODEL.delZ/2;
else
	MODEL.delZ=linspace(MODEL.delZ0,MODEL.delZ1,MODEL.Nz)';MODEL.Z=cumsum(MODEL.delZ)-MODEL.delZ(1)/2;%[min(z) round(max(z))]
end
%-----------------------------------------
% stratification
%-----------------------------------------
MODEL.lon_strat = -208+360;MODEL.lat_strat = -44;MODEL.minN2=1e-6;
MODEL.alphaT=2e-4;
MODEL=MITGCM_get_EWG_stratification_linear_EOS_T_only(MODEL);done('getting stratification')

MODEL.Tinit=permute(repmat(MODEL.Tref,[1 MODEL.Nx MODEL.Ny]),[2 3 1]);

MODEL.H(MODEL.H>=MODEL.H_max)=MODEL.H_max;
MODEL.H(MODEL.H<=MODEL.H_min)=          0; % might want to use a mask and make this H_min instead of 0

fname = ['/home/hsimmons/PROJ/TTide/DATA/MITGCM_test_wave_',num2str(MODEL.dX0/1e3),'_',num2str(MODEL.dY0/1e3),'_',model_version,'.mat'];
eval(['save ',fname,' MODEL']);

%% Forcing - straight from the Oregon coast problem, except
%   that the forcing is here on the Eastern edge instead of the Western

OB.Nt=48;                         % Nt points to cover 1 full forcing period
OB.period=12.42*3600;             % this is the period of Sam's forcing in seconds
OB.omegaS=2*pi/OB.period;         % omega in rad/sec
OB.omegaD=OB.omegaS*86400;        % omega in rad/day
OB.day0 = datenum(2012,1,1);
OB.nperiods = 1;
OB.timeD=linspace(OB.day0,(OB.day0+OB.nperiods*OB.period/86400),OB.Nt);
OB.dt=86400*diff(OB.timeD(1:2));
OB.timeS=86400*OB.timeD;

%----------------------------------
if BT     
%----------------------------------
%%
MITGCM_get_tpxo_OBCs;done('gettting tpxo BCs')
%keyboard
%%
% [x,y,amp,phase]=tmd_get_coeff('/home/hsimmons/DATA/OTIS_DATA/Model_tpxo7.2','z','m2');
% [long,latg,H]=tmd_get_bathy('/home/hsimmons/DATA/OTIS_DATA/Model_tpxo7.2');
% idx = find(x>140&x<180);
% jdx = find(y>-60&y<-40); 
% f1;clf
% imagesc(long,latg,H);hold on
% [c,h]=contour(x(idx),y(jdx),phase(jdx,idx),[0:10:360]);axis xy equal;clabel(c,h)
% hlim(140,180,-60,-40)
%[TS,ConList]=tmd_tide_pred(,,lat,lon,ptype,Cid);
%%
%----------------------------------
else % not BT
%----------------------------------

OB.ewindow = 1*repmat(tukeywin(MODEL.Ny,.2),[1 MODEL.Nz OB.Nt]);
OB.wwindow = 1;
OB.nwindow = 1;
OB.swindow = 1;

if use_sam_kelly_structure
 [~,OB.u,OB.v,~,~,OB.rho,~]=VERT_STRUCTURE(MODEL.Z',MODEL.N2',sw_f(MODEL.reflat),1,-OB.flux_mag*1e3,OB.omegaS,0);%10e3
 MODEL.rho0=1030; OB.TdiffProf=OB.rho/(MODEL.rho0*-MODEL.alphaT);
else
 [~,tmpp,ce]=dynmodes(lowpass(MODEL.N2,OB.smoo),sw_pres(MODEL.Z,MODEL.reflat),0);
 tmpp=tmpp(1:MODEL.Nz,1);tmpp=tmpp/tmpp(1);tmpp=tmpp-sum(tmpp.*MODEL.delZ)/sum(MODEL.delZ);
 OB.u=.01*OB.flux_mag*(tmpp + 0     *sqrt(-1));% I am too lazy to figure out currents associated with flux from nonuniform stratification and  
 OB.v=.01*OB.flux_mag*(0    +   tmpp*sqrt(-1));% besides the sponge screws it up anyway, so might as well just set it up empirically
 
 MODEL.rho0=1030; OB.TdiffProf=0*MODEL.Z; % do not implement density perturbation into OBC, Just use BC velocity
end

OB.NT=repmat(MODEL.Tref',[MODEL.Nx 1 OB.Nt]);
OB.NU = 0*OB.NT;
OB.NV = 0*OB.NT;

OB.ST=repmat(MODEL.Tref',[MODEL.Nx 1 OB.Nt]);
OB.SU = 0*OB.ST;
OB.SV = 0*OB.ST;

OB.ET = OB.ewindow.*permute(repmat(real(OB.TdiffProf)*cos(OB.omegaS*OB.timeS) + imag(OB.TdiffProf)*sin(OB.omegaS*OB.timeS),[1 1 MODEL.Ny]),[3 1 2]);
OB.ET = OB.ET + permute(repmat(MODEL.Tref,[1 MODEL.Ny OB.Nt]),[2 1 3]);
OB.EU = OB.ewindow.*permute(repmat(real(OB.u)        *cos(OB.omegaS*OB.timeS) + imag(OB.u)        *sin(OB.omegaS*OB.timeS),[1 1 MODEL.Ny]),[3 1 2]);
OB.EV = OB.ewindow.*permute(repmat(real(OB.v)        *cos(OB.omegaS*OB.timeS) + imag(OB.v)        *sin(OB.omegaS*OB.timeS),[1 1 MODEL.Ny]),[3 1 2]);

OB.WT=repmat(MODEL.Tref',[MODEL.Ny 1 OB.Nt]);
OB.WU = 0*OB.WT;
OB.WV = 0*OB.WT;
done('BC OBs')
%----------------------------------
end % if BT
%----------------------------------
%%
MITGCM_write_io; done('writing i/o')
%%
%          NT: [100x100x48 double]
%           ST: [100x100x48 double]
%           WT: [85x100x48 double]
%           ET: [85x100x48 double]
%           NU: [100x100x48 double]
%           NV: [100x100x48 double]
%           SU: [100x100x48 double]
%           SV: [100x100x48 double]
%           WU: [85x100x48 double]
%           WV: [85x100x48 double]
%           EU: [85x100x48 double]
%           EV: [85x100x48 double]
