%% This whole first section is just setup, mostly to get the stratification

clear;warning off
addpath LOCAL_MITGCM_LIBRARY % make sure we have the consistent version of the MITGCM library, superceding the ~/matlab/MITGCM version

% Get the bathymetry from the ROMS grid file.

[~,gridFile]=unix('ls .. |grep ".nc"');gridFile=strcat('../',gridFile);subGrid.gridFile=gridFile;

depthMin=nc_varget(gridFile,'depthmin');
bathy   =nc_varget(gridFile,'h');
lat_rho =nc_varget(gridFile,'lat_rho');
lon_rho =nc_varget(gridFile,'lon_rho');
% pcolor(bathy);shading flat


%% z-grid. What this actually is is the set of ocean depths I'll use for the spectral transform vectors.

MODEL.H_min =  min(bathy(:));
MODEL.H_max = ceil( max(bathy(:))/1000) *1000;

% Choose relative spacing

% % % % Method 1: choose a and figure out what n needs to be (usually some weird number)
% % % a=1.01;                          
% % % 
% % % MODEL.nH = ceil(log(1-(MODEL.H_max/MODEL.H_min) *(1-a))/log(a) );
% % % 
% % % delH=[MODEL.H_min];
% % % for ii=1:MODEL.nH-1
% % %     delH=[delH delH(end)*a];
% % % end
% % % sum(delH);
% % % MODEL.H=cumsum(delH)';


% Method 2: choose some nice, even n and figure out what a has to be to sum to H_max

% here is n=100
% % MODEL.nH=100;
% % a=1.0193711101915352;
% % MODEL.H_min * (1-a^MODEL.nH)/(1-a);
% % delH=[MODEL.H_min];
% % for ii=1:MODEL.nH-1
% %     delH=[delH delH(end)*a];
% % end
% % sum(delH);
% % MODEL.H=cumsum(delH)';

% here is n=200
MODEL.nH=200;
a=1.003837800286324;
MODEL.H_min * (1-a^MODEL.nH)/(1-a);
delH=[MODEL.H_min];
for ii=1:MODEL.nH-1
    delH=[delH delH(end)*a];
end
sum(delH)
MODEL.H=cumsum(delH)';



%% stratification

MODEL.rho0=1030;
MODEL.g=9.8;

% This is a reference point in the Tasman Sea ROI
MODEL.lon_strat = -208+360;MODEL.lat_strat = -44;
MODEL.reflat= ( max(lat_rho(:)) + min(lat_rho(:)) )/2;

% Make a fine vertical grid for N2 and rho0
MODEL.Z = [0:10:MODEL.H_max]';

MODEL.N2_min=10^-6.5;
MODEL.alphaT=2e-4;

MODEL=MITGCM_get_EWG_stratification_linear_EOS_T_only(MODEL);done('getting stratification')



%% JGP   This section calculates the w-modes and the p-modes for all allowed basin depths
%  Really, I'm not trying to archive anything here. I just want to see how
%  the transform coefficients change as a function of depth. The
%  substantial changes will be in MITGCM_calc_modes.m

MODEL.omegaCoriolis=sw_f(MODEL.reflat);
MODEL.flux_mag = 10;

nModes=10;  % currently MITgcm accepts a maximum of 10 normal modes.
            % If you want more modes then ../code/diags_rho.f, etc, needs
            % modification
            
MODEL=MITGCM_calc_modes(MODEL,nModes);
save MODEL MODEL





done('calc_modes,time to start writes')


