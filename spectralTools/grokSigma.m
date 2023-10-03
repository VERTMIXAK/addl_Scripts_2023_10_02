clear

% Get the grid.

nameTemp=dir('../netcdf_All/*_his_*');
fileList={ nameTemp.name};subGrid.fileList=fileList;

tmp = strcat('../netcdf_All/',fileList(1));
sampleHISfile = tmp{1};subGrid.sampleHISfile=sampleHISfile;
[~,gridFile]=unix('ls .. |grep ".nc"');gridFile=strcat('../',gridFile);subGrid.gridFile=gridFile;

ROMSgrid=roms_get_grid(gridFile,sampleHISfile,0,1);

%% reproduce the stretching function C(sigma)

% The sigma coordinate goes from 0 (the surface) to -1 (the ocean floor)
%   and is dimensionless. C takes as input 2 parameters
%       theta_s = 7     modified stretching near the surface
%       theta_b = 2     modified stretching near the bottom

C1=(cosh(ROMSgrid.s_w*ROMSgrid.theta_s)-1)/(1-cosh(-ROMSgrid.theta_s));
C2=(exp(C1*ROMSgrid.theta_b)-1)/(1-exp(-ROMSgrid.theta_b));
C2-ROMSgrid.Cs_w        % all zeros, so this worked.

%% S depends on sigma, C2, tcline, and the local ocean depth
%   NOTE: h and zeta are on the same grid, as is z (I think)


%pick a point
ii=10;jj=90;
depth = ROMSgrid.h(jj,ii);
sigma = ROMSgrid.s_w;       % These sigma are on the cell faces

S = (ROMSgrid.Tcline*sigma + depth*C2)/(ROMSgrid.Tcline + depth);
 fig(3);clf;plot(ROMSgrid.s_w,S,'r');hold on;plot(ROMSgrid.s_w,C2,'b')
 
newS = (ROMSgrid.Tcline*sigma + depth*C2)/(ROMSgrid.Tcline + depth);

% all the sea surface heights (zeta) are zero so this is the grid for the
% ocean at rest. I will put in my own zeta to see how much difference it
% makes

zeta = 1;
zeta = 0;   % use this one to verify that my calculated z is the same a z_R

zCalc = depth*S;
zWaves= zeta + (zeta+depth)*S;

zCalc - squeeze(ROMSgrid.z_w(:,jj,ii))'
fig(4);clf;plot(zCalc)

zCalc-zWaves