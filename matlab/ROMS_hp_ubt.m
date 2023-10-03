%function ROMS_hp_ubt
% note that his2 variables are always saved hourly so that nrecs might be
% larger than the concatenated data from his files that may have an hourly data
% archiving period that starts mid-run after a restart
%%
infile               = roms.files.ubtoutfile;
disp(['opening ',infile])
if ~exist(infile);error(['not found: ',infile]);end
%%
len=0;
if exist(roms.files.hpubtfile); 
     len = nc_varsize(roms.files.hpubtfile,'ocean_time');
 end
nt=length(nc_varget(infile,'ocean_time'));
if len==0;  
sz = [nt ny nx];
 disp(['creating: ',roms.files.hpubtfile])
 setup_cdf_file_time_plus_2d(roms.files.hpubtfile,'ubt_hp','ocean_time','jdx','idx',sz(2:end));
 nc_varput(roms.files.hpubtfile,'jdx',jdxs);
 nc_varput(roms.files.hpubtfile,'idx',idxs);
 ocean_time=nc_varget(infile,'ocean_time');

 setup_cdf_file_time_plus_2d(roms.files.hpvbtfile,'vbt_hp','ocean_time','jdx','idx',sz(2:end));
 nc_varput(roms.files.hpvbtfile,'jdx',jdxs);
 nc_varput(roms.files.hpvbtfile,'idx',idxs);
 ocean_time=nc_varget(infile,'ocean_time');
 count = sz;

 disp(['highpassing ubt'])
 %%
 ubt     = nc_varget(infile,'ubar',[0,jdxs(1)-1,idxs(1)-1],[nt,length(jdxs)  ,length(idxs)+1]);
 vbt     = nc_varget(infile,'vbar',[0,jdxs(1)-1,idxs(1)-1],[nt,length(jdxs)+1,length(idxs)  ]);
 ubt     = (ubt(:,:      ,1:end-1)+ubt(:,:    ,2:end))/2;
 vbt     = (vbt(:,1:end-1,:      )+vbt(:,2:end,:    ))/2;
%%
% put ubt and vbt on rho points
for jj = 1:ny
    ubt(:,jj,:)=highpass(sq(ubt(:,jj,:)),1/36,1,6); % recycle variable to save memory
    vbt(:,jj,:)=highpass(sq(vbt(:,jj,:)),1/36,1,6); % recycle variable to save memory
end
%%
%keyboard
%%
start = [0,0,0];
nc_varput(roms.files.hpubtfile,'ubt_hp'    ,ubt,start,count);
nc_varput(roms.files.hpvbtfile,'vbt_hp'    ,vbt,start,count);
nc_varput(roms.files.hpubtfile,'ocean_time',ocean_time,[0],sz(1))
nc_varput(roms.files.hpvbtfile,'ocean_time',ocean_time,[0],sz(1))
end % existence test
done('highpass_ubt')
