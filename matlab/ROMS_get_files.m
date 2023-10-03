function roms = ROMS_get_files(roms)

%keyboard
%%
roms
roms.avg_name         = [roms.exp,'_avg_' ,num2str(roms.year)];
roms.his_hourly_name  = [roms.exp,'_his_' ,num2str(roms.year),'_hourly'];
roms.his_name         = [roms.exp,'_his_' ,num2str(roms.year)];
roms.his_daily_name   = [roms.exp,'_his_' ,num2str(roms.year),'_daily'];
roms.his2_name        = [roms.exp,'_his2_',num2str(roms.year)];
roms.gname            = [roms.expbase,'.nc'];
%roms.base1     = '/import/c/w/jpender/roms-kate_svn/';

patha = [roms.base1,'/',roms.expbase,'/Experiments/',roms.exp1,'/netcdfOutput/'];
pathb = [roms.base1,'/',roms.expbase,'/Experiments/',roms.exp1,'/netcdf_All/'];
disp('considering ...')
disp(patha)
disp(pathb)
if exist(patha);roms.path1     = patha;end
if exist(pathb);roms.path1     = pathb;end
%%
%keyboard
%%
if ~exist(roms.path1);error(['bad path: ',roms.path1]);end

roms.base2     = '/import/c/w/hsimmons/roms-kate_svn/';
roms.path2     = [roms.base2,'/',roms.expbase,'/Experiments/',roms.exp1,'/netcdfOutput/'];

roms.files.gfile  = [roms.path1,'/../',roms.gname];

tmpfiles = [roms.path1,roms.his_daily_name,'*.nc']; 
tmp=dir(tmpfiles) ;
for idx=1:length(tmp);roms.files.his_daily_files{idx}=[roms.path1,tmp(idx).name];end

tmpfiles = [roms.path1,roms.his_hourly_name,'*.nc']; 
tmp=dir(tmpfiles) ;
for idx=1:length(tmp);
    roms.files.his_hourly_files{idx}=[roms.path1,tmp(idx).name];disp(roms.files.his_hourly_files{idx})
end

%%
if ~isfield(roms.files,'his_hourly_files')
 tmpfiles = [roms.path1,roms.his_name,'*.nc']; 
tmp=dir(tmpfiles) ;
for idx=1:length(tmp);
    roms.files.his_hourly_files{idx}=[roms.path1,tmp(idx).name];disp(roms.files.his_hourly_files{idx})
end
end   

%%
%keyboard
%%
tmp=dir([roms.path1,roms.avg_name,'*.nc']) ;
for idx=1:length(tmp);roms.files.avg_files{idx}=[roms.path1,tmp(idx).name];end

tmp=dir([roms.path1,roms.his2_name,'*.nc']);
for idx=1:length(tmp);roms.files.his2_files{idx}=[roms.path1,tmp(idx).name];end
%%
%keyboard
%%
if isfield(roms.files,'his_daily_files');hfile = roms.files.his_daily_files{1};else;hfile = roms.files.his_hourly_files{1};end
    roms.grd       = roms_get_grid(roms.files.gfile,hfile,0,1);done('roms_get_grid')
    [~,~,roms.grd.dzu] = roms_zint(nc_varget(hfile,'u'   ),roms.grd);
    [~,~,roms.grd.dzv] = roms_zint(nc_varget(hfile,'v'   ),roms.grd);
    [~,~,roms.grd.dzr] = roms_zint(nc_varget(hfile,'temp'),roms.grd);
%%



if 0 
 roms.files.ubar   = [roms.path2,'ubar_',roms.his2_name,'.nc']
 roms.files.vbar   = [roms.path2,'vbar_',roms.his2_name,'.nc']
 roms.files.zeta   = [roms.path2,'zeta_',roms.his2_name,'.nc']

 roms.files.ssu   = [roms.path2,'u_',roms.his2_name,'.nc']
 roms.files.ssv   = [roms.path2,'v_',roms.his2_name,'.nc']
 roms.files.sst   = [roms.path2,'temp_',roms.his2_name,'.nc']
 roms.files.sss   = [roms.path2,'salt_',roms.his2_name,'.nc']
 disp(['reading ',roms.files.ssu]);
roms.ssstime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.ssu,'ocean_time')/86400;
disp(['reading ',roms.files.sst]);
roms.ssttime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.sst,'ocean_time')/86400;
disp(['reading ',roms.files.ssu]);
roms.ssutime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.ssu,'ocean_time')/86400;
disp(['reading ',roms.files.ssv]);
roms.ssvtime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.ssv,'ocean_time')/86400;
end
%%
