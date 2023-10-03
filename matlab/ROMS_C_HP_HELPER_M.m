function ROMS_C_hp_helper_m(roms)
%%
lon0 =roms.lon0;
lon1 =roms.lon1;
lat0 =roms.lat0;
lat1 =roms.lat1;

lon=roms.grd.lon_rho(2:end-1,2:end-1);
lat=roms.grd.lat_rho(2:end-1,2:end-1);
idxs = find(lon(1,:)>=lon0&lon(1,:)<=lon1);
jdxs = find(lat(:,1)>=lat0&lat(:,1)<=lat1);
roms.idxs=idxs;
roms.jdxs=jdxs;
H   = roms.grd.h  ;           H   =   H(  2:end-1,2:end-1);  H = sq(  H(  jdxs,idxs));
z   =-flipdim(roms.grd.z_r,1);z   =   z(:,2:end-1,2:end-1);  z = sq(  z(:,jdxs,idxs));
dzr = flipdim(roms.grd.dzr,1);dzr = dzr(:,2:end-1,2:end-1);dzr = sq(dzr(:,jdxs,idxs));
lon = lon(jdxs,idxs);
lat = lat(jdxs,idxs);
roms.lon = lon;
roms.lat = lat;
%nt = length(tdxs);
nz=length(z(:,1,1));nx=length(idxs);ny=length(jdxs);nm=roms.nm;
%%
roms.files.cfile       = sprintf([roms.analysis_path,'roms_c_m_%i_%i_%i_%i_roms.mat']   ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);
roms.files.C_hp_file   = sprintf([roms.analysis_path,'roms_C_hp_m_%i_%i_%i_%i_roms.mat'],roms.lon0,roms.lon1,roms.lat0,roms.lat1);
roms.files.hpcfile     = sprintf([roms.analysis_path,'roms_hp_c_m_%i_%i_%i_%i_roms.mat'],roms.lon0,roms.lon1,roms.lat0,roms.lat1);
roms.files.hpubtfile   = sprintf([roms.analysis_path,'hp_ubt_%d_%d_%d_%d.nc']           ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);
roms.files.hpvbtfile   = sprintf([roms.analysis_path,'hp_vbt_%d_%d_%d_%d.nc']           ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);
his_file               = roms.files.his_hourly_files{1};slashes = findstr(his_file,'/');
roms.files.psi_file    = [roms.analysis_path,'psi_',his_file(slashes(end)+1:end),'_',num2str(lon0),'_',num2str(lon1),'_',num2str(lat0),'_',num2str(lat1),'.mat']
%%
%keyboard 
%%
xu       = nc_varget(roms.files.gfile,'x_u'   ,[jdxs(1)-1,idxs(1)-1],[length(jdxs)  ,length(idxs)+1]);
yv       = nc_varget(roms.files.gfile,'y_v'   ,[jdxs(1)-1,idxs(1)-1],[length(jdxs)+1,length(idxs)  ]);
dxr = diff(xu,1,2);
dyr = diff(yv,1,1);
[dDdx,dDdy]=gradient(H);dDdx=dDdx./dxr;dDdy=dDdy./dyr;

%%
% these scripts operate on his2 derived [u,v]bt data  which are always hourly whereas rho-derived data
% may not exist over the same time range
ROMS_concatenate_ubt_vbt
ROMS_hp_ubt
%%
if ~exist(roms.files.C_hp_file)
psi=load(roms.files.psi_file,'rmodes');
load(roms.files.cfile, 'cr')
%%
load(roms.files.cfile, 'ctime');ocean_time_rho = ctime(:);nt_rho=length(ocean_time_rho);
ocean_time_bt = roms_get_date(roms.files.ubtoutfile);nt_bt = length(ocean_time_bt);
%%
if nt_rho > nt_bt 
     ocean_time_rho=ocean_time_rho(2:end);                                               %  % now fix it. 
 disp([num2str(length(ocean_time_bt-ocean_time_rho)),' records used in reconstructing C_lin, had to drop first rho time index']); % fail if the modified time matches arent exact
end

tdxs = find(ocean_time_bt==ocean_time_rho(1)):find(ocean_time_bt==ocean_time_rho(end)); % this will fail if the time matches arent exact
%%
ubt       = nc_varget(roms.files.hpubtfile,'ubt_hp',[tdxs(1)-1,0,0],[nt_rho,-1,-1]);done('reading ubt_hp')
vbt       = nc_varget(roms.files.hpvbtfile,'vbt_hp',[tdxs(1)-1,0,0],[nt_rho,-1,-1]);done('reading vbt_hp')
%%
nm=1; % only compute conversion for mode 1;
C_lin  =nan*ones(nt_rho,ny,nx);
wbt    =nan*ones(nt_rho,ny,nx);
Ppr_bot=nan*ones(nt_rho,ny,nx);
for mdx =1:nm;disp(['reconstructing Conversion, mode = ',num2str(mdx)])
    for jj=1:ny;disp([jj ny])
    for ii=1:nx
%%
%ii=50;jj=60
tmpdz = repmat(dzr(:,jj,ii),1,nt_rho);
    rhopr = sq(psi.rmodes(:,mdx,jj,ii))*sq(cr(:,mdx,jj,ii))'; % I hope there is no way to accidently use the un-highpassed version of cu...
    Ppr  = 9.8*cumsum(rhopr.*tmpdz);
    PprBAR = sq(sum(Ppr.*tmpdz)./sum(tmpdz));
    PPRBAR = repmat(PprBAR,[nz,1]);pr = Ppr-PPRBAR;
 
    Ppr_bot(:,jj,ii) = pr(end,:);
    wbt    (:,jj,ii) = ubt(:,jj,ii).*dDdx(jj,ii)+vbt(:,jj,ii).*dDdy(jj,ii);
    C_lin  (:,jj,ii) = wbt(:,jj,ii).*Ppr_bot(:,jj,ii);
    end
    end
end
%%
ta_C_lin=sq(mean(C_lin));
string = ['save -v7.3 ',roms.files.C_hp_file,' C_lin ta_C_lin wbt Ppr_bot ctime H lon lat'];
disp(string)
eval(string);done('saving')
else % 
disp(['file ',roms.files.C_hp_file]);
end
%%

