clear

% ref:   mexcdf.sourceforge.net/tutorial/ch09.html

% Select input/output files and choose a regular x,y,z grid
%   This grid is going to much smaller in area than the full grid.

nameTemp=dir('../netcdf_All/*_his_*');
fileList={ nameTemp.name};subGrid.fileList=fileList;

tmp = strcat('../netcdf_All/',fileList(1));
sampleHISfile = tmp{1};subGrid.sampleHISfile=sampleHISfile;
[~,gridFile]=unix('ls .. |grep ".nc"');gridFile=strcat('../',gridFile);subGrid.gridFile=gridFile;

ROMSout=roms_get_grid(gridFile,sampleHISfile,0,1);

cd ../netcdf_All;
% [~,Nmin]=unix('ls *_his_* | head -1 | cut -d "_" -f5 | cut -d "." -f1');Nmin=str2num(Nmin)
% [~,Nmax]=unix('ls *_his_* | tail -1 | cut -d "_" -f5 | cut -d "." -f1');Nmax=str2num(Nmax)
unix('ls *_his_* | head -1 > min.txt');
unix('ls *_his_* | tail -1 > max.txt');
[~,Nmin]=unix('more min.txt | cut -d "." -f1 | rev | cut -d "_" -f1 | rev');Nmin=str2num(Nmin);subGrid.Nmin=Nmin;
[~,Nmax]=unix('more max.txt | cut -d "." -f1 | rev | cut -d "_" -f1 | rev');Nmax=str2num(Nmax);subGrid.Nmax=Nmax;

cd ..; [~,year]=unix('pwd | rev | cut -d "/" -f1 |rev |cut -d "_" -f3');cd regridTools;

% Get the indices for the reduced ROI footprint

%lonMin = 86; lonMax = 95;
%latMin = 14; latMax = 22.8;
lonMin = 150; lonMax = 165;	! This is for the Tasman Sea
latMin = -55; latMax = -40;
% lonMin = 80; lonMax = 89;
% latMin = 14; latMax = 18;

sign(ROMSout.lon_u(1,:)   - lonMin);subGrid.lon_u_min   = find(ans==-1,1,'last');
sign(ROMSout.lon_v(1,:)   - lonMin);subGrid.lon_v_min   = find(ans==-1,1,'last');
sign(ROMSout.lon_rho(1,:) - lonMin);subGrid.lon_rho_min = find(ans==-1,1,'last');
subGrid.lon_min = min( [subGrid.lon_u_min subGrid.lon_v_min subGrid.lon_rho_min ])

sign(ROMSout.lon_u(1,:)   - lonMax);subGrid.lon_u_max   = find(ans==1,1,'first');
sign(ROMSout.lon_v(1,:)   - lonMax);subGrid.lon_v_max   = find(ans==1,1,'first');
sign(ROMSout.lon_rho(1,:) - lonMax);subGrid.lon_rho_max = find(ans==1,1,'first');
subGrid.lon_max = max( [subGrid.lon_u_max subGrid.lon_v_max subGrid.lon_rho_max ])

sign(ROMSout.lat_u(:,1)   - latMin);subGrid.lat_u_min   = find(ans==-1,1,'last');
sign(ROMSout.lat_v(:,1)   - latMin);subGrid.lat_v_min   = find(ans==-1,1,'last');
sign(ROMSout.lat_rho(:,1) - latMin);subGrid.lat_rho_min = find(ans==-1,1,'last');
subGrid.lat_min = min( [subGrid.lat_u_min subGrid.lat_v_min subGrid.lat_rho_min ])

sign(ROMSout.lat_u(:,1)   - latMax);subGrid.lat_u_max   = find(ans==1,1,'first');
sign(ROMSout.lat_v(:,1)   - latMax);subGrid.lat_v_max   = find(ans==1,1,'first');
sign(ROMSout.lat_rho(:,1) - latMax);subGrid.lat_rho_max = find(ans==1,1,'first');
subGrid.lat_max = max( [subGrid.lat_u_max subGrid.lat_v_max subGrid.lat_rho_max ])


%!!!!!!!!!! Update for each variable (u,v,etc)
% subGrid.lonUgrid = ROMSout.lon_u(1,subGrid.lon_u_min:subGrid.lon_u_max);
% subGrid.latUgrid = ROMSout.lat_u(subGrid.lat_u_min:subGrid.lat_u_max,1);
% subGrid.lonVgrid = ROMSout.lon_v(1,subGrid.lon_v_min:subGrid.lon_v_max);
% subGrid.latVgrid = ROMSout.lat_v(subGrid.lat_v_min:subGrid.lat_v_max,1);
% subGrid.lonRHOgrid = ROMSout.lon_rho(1,subGrid.lon_rho_min:subGrid.lon_rho_max);
% subGrid.latRHOgrid = ROMSout.lat_rho(subGrid.lat_rho_min:subGrid.lat_rho_max,1);
subGrid.lonUgrid = ROMSout.lon_u(1,subGrid.lon_min:subGrid.lon_max);
subGrid.latUgrid = ROMSout.lat_u(subGrid.lat_min:subGrid.lat_max,1);
subGrid.lonVgrid = ROMSout.lon_v(1,subGrid.lon_min:subGrid.lon_max);
subGrid.latVgrid = ROMSout.lat_v(subGrid.lat_min:subGrid.lat_max,1);
subGrid.lonRHOgrid = ROMSout.lon_rho(1,subGrid.lon_min:subGrid.lon_max);
subGrid.latRHOgrid = ROMSout.lat_rho(subGrid.lat_min:subGrid.lat_max,1);
subGrid.zGrid   = [2 7 12 18 23 29 35 42 49 56 64 72 81 90 101 112 124 137 152 168 186 205] ;

subGrid.range = strcat('_',int2str(latMin),'to',int2str(latMax),'_',int2str(lonMin),'to',int2str(lonMax),'_',int2str(min(subGrid.zGrid)),'to',int2str(max(subGrid.zGrid)), ...
            '_',year,'_',int2str(Nmin),'to',int2str(Nmax));
subGrid.lonMin=lonMin;subGrid.lonMax=lonMax;subGrid.latMin=latMin;subGrid.latMax=latMax;
% subGrid.lon_min=lon_min;subGrid.lon_max=lon_max;subGrid.lat_min=lat_min;subGrid.lat_max=lat_max;
        
save ROMSout ROMSout
save subGrid subGrid
        
 %% Calculate and warehouse stuff for roms_zslice_var routine

depth = -abs(subGrid.zGrid);

% U
Uxieta = squeeze( nc_varget(sampleHISfile,'u',   [0 0 0 0],[1 -1 -1 -1]) );
[N L M] = size(Uxieta);
zsliceStuff.Nu = N;
zsliceStuff.Lu = L;
zsliceStuff.Mu = M;

for zz=[1:length(depth)]
    zz
    z_r = ROMSout.z_r; 

    zM = size(z_r,2);
    zMm = zM-1;
    zL = size(z_r,3);
    zLm = zL-1;
    z = 0.5*(z_r(:,:,1:zLm)+z_r(:,:,2:zL));

    z = reshape(z,[size(z,1) size(z,2)*size(z,3)]);

    z = [-Inf*ones([1 L*M]); z; zeros([1 L*M])];
    z = flipud(z);

    zg_ind = find(diff(z<depth(zz))~=0);
    zg_ind = zg_ind + [0:1:length(zg_ind)-1]';

    zl_ind = find(diff(z>depth(zz))~=0);
    zl_ind = zl_ind + [1:1:length(zg_ind)]';

    depth_greater_z = z(zg_ind);
    depth_lesser_z = z(zl_ind);

    alpha = (depth(zz)-depth_greater_z)./(depth_lesser_z-depth_greater_z);

    zsliceStuff.alphaU(:,zz)  = alpha;
    zsliceStuff.zg_indU(:,zz) = zg_ind;
    zsliceStuff.zl_indU(:,zz) = zl_ind;
end


% V
Vxieta = squeeze( nc_varget(sampleHISfile,'v',   [0 0 0 0],[1 -1 -1 -1]) );
[N L M] = size(Vxieta);
zsliceStuff.Nv = N;
zsliceStuff.Lv = L;
zsliceStuff.Mv = M;

for zz=[1:length(depth)]
    zz
    z_r = ROMSout.z_r; 

    zM = size(z_r,2);
    zMm = zM-1;
    zL = size(z_r,3);
    zLm = zL-1;
    z = 0.5*(z_r(:,1:zMm,:)+z_r(:,2:zM,:)); 

    z = reshape(z,[size(z,1) size(z,2)*size(z,3)]);

    z = [-Inf*ones([1 L*M]); z; zeros([1 L*M])];
    z = flipud(z);

    zg_ind = find(diff(z<depth(zz))~=0);
    zg_ind = zg_ind + [0:1:length(zg_ind)-1]';

    zl_ind = find(diff(z>depth(zz))~=0);
    zl_ind = zl_ind + [1:1:length(zg_ind)]';

    depth_greater_z = z(zg_ind);
    depth_lesser_z = z(zl_ind);

    alpha = (depth(zz)-depth_greater_z)./(depth_lesser_z-depth_greater_z);

    zsliceStuff.alphaV(:,zz)  = alpha;
    zsliceStuff.zg_indV(:,zz) = zg_ind;
    zsliceStuff.zl_indV(:,zz) = zl_ind;
end


% TS
Txieta = squeeze( nc_varget(sampleHISfile,'temp',   [0 0 0 0],[1 -1 -1 -1]) );
[N L M] = size(Txieta);
zsliceStuff.Nts = N;
zsliceStuff.Lts = L;
zsliceStuff.Mts = M;

for zz=[1:length(depth)]
    zz
    z_r = ROMSout.z_r; 

    z = z_r;

    z = reshape(z,[size(z,1) size(z,2)*size(z,3)]);

    z = [-Inf*ones([1 L*M]); z; zeros([1 L*M])];
    z = flipud(z);

    zg_ind = find(diff(z<depth(zz))~=0);
    zg_ind = zg_ind + [0:1:length(zg_ind)-1]';

    zl_ind = find(diff(z>depth(zz))~=0);
    zl_ind = zl_ind + [1:1:length(zg_ind)]';

    depth_greater_z = z(zg_ind);
    depth_lesser_z = z(zl_ind);

    alpha = (depth(zz)-depth_greater_z)./(depth_lesser_z-depth_greater_z);

    zsliceStuff.alphaTS(:,zz)  = alpha;
    zsliceStuff.zg_indTS(:,zz) = zg_ind;
    zsliceStuff.zl_indTS(:,zz) = zl_ind;
end

save zsliceStuff zsliceStuff

done('job')
        
        
        
        
