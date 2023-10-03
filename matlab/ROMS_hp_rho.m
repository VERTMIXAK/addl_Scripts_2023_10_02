
roms.files.hprhofile = [roms.analysis_path,'hp_rho_',roms.latlonRange,'.nc'];
%%
%keyboard
%%
len=0;
if exist(roms.files.hprhofile); 
    len = nc_varsize(roms.files.hprhofile,'ocean_time');
end
%%
if len==0;  
%if ~exist(roms.files.hprhofile); 
kk=1; 
 if strmatch(roms.type,'tideonly')
   infile  = [roms.analysis_path,num2str(kk),'_T_his.nc']
 else
   infile  = [roms.analysis_path,num2str(kk),'_T_S_his.nc']
 end
 nt = nc_varsize(infile,'ocean_time');
 %%
 sz = [nt nz ny nx];
 s_rho=nc_varget(infile,'s_rho');
%%
%keyboard
%%
 setup_cdf_file_time_plus_3d(roms.files.hprhofile,'rho_hp','ocean_time','s_rho','jdx','idx',sz(2:end));
 nc_varput(roms.files.hprhofile,'jdx',jdxs);
 nc_varput(roms.files.hprhofile,'idx',idxs);
 ocean_time=nc_varget(infile,'ocean_time');
 count = [sz(1),1,sz(3),sz(4)];
%% calculate Plocal here because we are working with local vertical indexing, k=0 is the bottom, k = 49 is the surface. elsewhere we use flipdim
Plocal   = nan*   ones(sz(2:end)); 
for jj = 1:sz(3); for ii = 1:sz(4)
  Plocal(:,jj,ii) = sw_pres(-roms.grd.z_r(:,jdxs(jj),idxs(ii)),lat0);
end;end;done('P')

%%
%keyboard
%%
 % Now loop through and calculate density and bandpass it in range
 % [lon0,lon1] [lat0,lat1]
 b=0;
for kk=1:50;a=tic;
 if strmatch(roms.type,'tideonly')
   infile  = [roms.analysis_path,num2str(kk),'_T_his.nc'];
 else
   infile  = [roms.analysis_path,num2str(kk),'_T_S_his.nc'];
 end
 disp(['highpassing rho level ',num2str(kk),' time = ',num2str(b)])

if strmatch(roms.type,'tideonly')
    temp = nc_varget(infile,'temp',[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,ny,nx]);
    salt = 34.7+0*temp;
else
    salt = nc_varget(infile,'salt',[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,ny,nx]);
    temp = nc_varget(infile,'temp',[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,ny,nx]);
end
tmpP = sq(Plocal(kk,:,:));
rho=nan*ones(sz(1),sz(3),sz(4));
for tdx=1:sz(1)
rho(tdx,:,:) = sw_dens(sq(salt(tdx,:,:)),sq(temp(tdx,:,:)),tmpP);
end
%rho_hp=nan*rho;
for jj = 1:sz(3)
%rho_hp(:,jj,:)=highpass(sq(rho(:,jj,:)),1/36,1,6);
rho(:,jj,:)=highpass(sq(rho(:,jj,:)),1/36,1,6); % recycle variable to save memory
end
start = [0,kk-1,0,0];
nc_varput(roms.files.hprhofile,'rho_hp',rho,start,count);b=toc;
end % kk
nc_varput(roms.files.hprhofile,'ocean_time',ocean_time,[0],sz(1))
end; % if exists and has data
done('highpass_rho')
