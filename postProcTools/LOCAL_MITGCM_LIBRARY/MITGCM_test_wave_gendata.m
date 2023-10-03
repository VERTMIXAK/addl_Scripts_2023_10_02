
%% get a smaller subset out of topo_30 for ease of use
clear
srcfile = '/home/hsimmons/DATA/TOPO/topo30.grd';destfile = 'HLS_TASMAN_TOPO30.mat';
lon0 = -225;lon1 = -180;lat0=-60;lat1=-30;skip = 2;
MITGCM_extract_topo(lon0,lon1,lat0,lat1,skip,srcfile,destfile)
%%

clear
MODEL.H_deep=5000;MODEL.Res_Z=50;
MODEL.toposrcfile = 'HLS_TASMAN_TOPO30.mat'                  % the source topo comes from the extraction created above
MODEL.Nx=300;MODEL.Ny=180;MODEL.dX0 = 4000;MODEL.dY0 = 4000; % cartesian grid resolution and number of gridpoints
MODEL.rotate_angle=-32; MODEL.lon0=143-360;MODEL.lat0=-44;   % angle that cartesian grid is rotated,  geographic origin of MODELesian grid
MODEL.reflat = 45;                                           % latitude for lon2km conversion for cartesian grid 
%%
MODEL=MITGCM_regrid_topo(MODEL);done
MODEL.smoofac=16;MODEL.eastsmoo=350e3;MODEL.northsmoo=600e3;MODEL.southsmoo=50e3;
%%
%------------------------------------------------
% Make a weighting function to smooth offshore and along North and South
%------------------------------------------------
Hsmoo=lowpass2d(MODEL.H,MODEL.smoofac,MODEL.smoofac);
facx=(1/2+atan(.125*(MODEL.X/1e3-MODEL.eastsmoo)/pi)/pi);facx=facx-facx(1);facx=facx/facx(end);FACX=(repmat(facx,MODEL.Ny,1));
facy=(1/2+atan(.125*(MODEL.Y/1e3-MODEL.northsmoo)/pi)/pi)-(1/2+atan(.125*(MODEL.Y/1e3-MODEL.southsmoo)/pi)/pi);facy=1-facy/min(facy);facy=facy/facy(end);FACY=(repmat(facy',1,MODEL.Nx));
H2 = MODEL.H.*(1-FACX) + FACX.*Hsmoo;
H2 = H2.*(1-FACY) + FACY.*Hsmoo;
MODEL.Hsmoo=H2;
%------------------------------------------------

%------------------------------------------------
load TASMAN_J ;
tmpJu=interp2(J.lon',J.lat',J.IJPRu,MODEL.Lon,MODEL.Lat);
tmpJv=interp2(J.lon',J.lat',J.IJPRv,MODEL.Lon,MODEL.Lat);

% since Ju and Jv are vectors we also have to rotate them as well
theta = atan2(tmpJu,tmpJv) + deg2rad(-MODEL.rotate_angle);

MODEL.Ju = tmpJu.*cos(theta) + tmpJv.*sin(theta);
MODEL.Jv = tmpJv.*cos(theta) - tmpJu.*sin(theta);
%------------------------------------------------

%%
MODEL=MITGCM_test_wave_gendata_vgrid_and_OBCs(MODEL,1,1)
%%
save MITGCM_test_wave_V3.mat MODEL
%%

clear
MODEL.H_deep=5000;MODEL.Res_Z=100;
MODEL.toposrcfile = 'HLS_TASMAN_TOPO30.mat'                  % the source topo comes from the extraction created above
MODEL.Nx=120;MODEL.Ny=90;MODEL.dX0 = 8000;MODEL.dY0 = 8000; % cartesian grid resolution and number of gridpoints
MODEL.rotate_angle=-32; MODEL.lon0=143-360;MODEL.lat0=-44;   % angle that cartesian grid is rotated,  geographic origin of MODELesian grid
MODEL.reflat = 45;                                           % latitude for lon2km conversion for cartesian grid 
MODEL.flux_mag = -8;MODEL.eastsmoo=700;MODEL.northsmoo=650;MODEL.southsmoo=50;
%%
MODEL=MITGCM_test_wave_gendata_regrid_topo(MODEL,1,1)
%%
MODEL=MITGCM_test_wave_gendata_vgrid_and_OBCs(MODEL,1,1)
%%
save MITGCM_test_wave_lor_res.mat MODEL
%%
clear
MODEL.H_deep=5000;MODEL.Res_Z=100;
MODEL.toposrcfile = 'HLS_TASMAN_TOPO30.mat'                  % the source topo comes from the extraction created above
MODEL.Nx=600;MODEL.Ny=360;MODEL.dX0 = 2000;MODEL.dY0 = 2000; % cartesian grid resolution and number of gridpoints
MODEL.rotate_angle=-32; MODEL.lon0=143-360;MODEL.lat0=-44;   % angle that cartesian grid is rotated,  geographic origin of MODELesian grid
MODEL.reflat = 45;                                           % latitude for lon2km conversion for cartesian grid 
MODEL.flux_mag = -8;MODEL.eastsmoo=700;MODEL.northsmoo=650;MODEL.southsmoo=50;
%%
MODEL=MITGCM_test_wave_gendata_regrid_topo(MODEL,1,1)
%%
MODEL=MITGCM_test_wave_gendata_vgrid_and_OBCs(MODEL,1,1)
%%
save MITGCM_test_wave_hi_res.mat MODEL
