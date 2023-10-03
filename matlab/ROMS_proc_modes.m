function roms=ROMS_proc_modes(fdx,roms,nm,reprocit)
%% 
his_file            = roms.files.his_files{fdx};slashes = findstr(his_file,'/');
lon0 =roms.lon0;
lon1 =roms.lon1;
lat0 =roms.lat0;
lat1 =roms.lat1;

roms.files.psi_file = [roms.path2,'psi_',his_file(slashes(end)+1:end),'_',num2str(lon0),'_',num2str(lon1),'_',num2str(lat0),'_',num2str(lat1),'.mat']
lon=roms.grd.lon_rho(2:end-1,2:end-1);
lat=roms.grd.lat_rho(2:end-1,2:end-1);

idx = find(lon(1,:)>=roms.lon0&lon(1,:)<=roms.lon1);
jdx = find(lat(:,1)>=roms.lat0&lat(:,1)<=roms.lat1);
roms.idx=idx;roms.jdx=jdx;
z = flipdim(roms.grd.z_r,1);z=z(:,2:end-1,2:end-1);
lon=lon(jdx,idx);lat=lat(jdx,idx);z=z(:,jdx,idx);[nz,ny,nx]=size(z)

%if reprocit
T = flipdim(nc_varget(his_file,'temp'),1);T=T(:,2:end-1,2:end-1);done('temp')
if strmatch(roms.type,'tideonly')
  S = 34+0*T;
else
  S = flipdim(nc_varget(his_file,'temp'),1);S=S(:,2:end-1,2:end-1);done('salt')
end

%%
P=nan*ones(nz,ny,nx);N20=nan*ones(nz-1,ny,nx);p_ave=nan*ones(nz-1,ny,nx);
T = T(:,jdx,idx);
S = S(:,jdx,idx);
%%
N20 = nan*ones(size(P));
for ii = 1:nx
 for jj = 1:ny
  P(:,jj,ii) = sw_pres(-z(:,jj,ii),-43);
  tmpS = S(:,jj,ii);
imagesc  if max(tmpS)>0;
   [tmpN2,~,p_ave] = sw_bfrq(tmpS,T(:,jj,ii),P(:,jj,ii));
   N20(:,jj,ii) = interp1(p_ave,tmpN2,P(:,jj,ii),'pchip');
 end % jj
end % ii
%end;done('N2')
%%
%keyboard
%%
[nz,ny,nx]=size(z);%nm=5;omega = 2*pi/(12.42*3600);f = sw_f(-42);
pmodes=nan*ones(nz,nm,ny,nx);
rmodes=nan*ones(nz,nm,ny,nx);
dmodes=nan*ones(nz,nm,ny,nx);
ce    =nan*ones(nm,ny,nx);
tic
for ii = 1:nx;disp([ii nx])
for jj = 1:ny
 if find(N20(:,jj,ii)>0) 
  [ tmpwmodes,tmppmodes,tmpce,Pout]=dynmodes(N20(:,jj,ii),P(:,jj,ii)); 
  for kk = 1:nm; 
      tmprmodes = tmpwmodes(2:end,kk).*N20(:,jj,ii);
      kdx=find(abs(tmprmodes)==max(abs(tmprmodes)));rmodes(:,kk,jj,ii)=tmprmodes/tmprmodes(kdx);

      pmodes(:,kk,jj,ii)=tmppmodes(2:end,kk)/tmppmodes(2,kk);
      
      tmp = tmpwmodes(2:end,kk);
      kdx=find(abs(tmp)==max(abs(tmp)));dmodes(:,kk,jj,ii)=tmp/tmp(kdx);
  end % kk 
  ce(:,jj,ii)=tmpce(1:nm);
 end % N2
end % jj
end % ii
toc

%%
disp(['save ',roms.files.psi_file,' pmodes rmodes dmodes ce nm N20 P idx jdx'])
eval(['save ',roms.files.psi_file,' pmodes rmodes dmodes ce nm N20 P idx jdx'])
return
%%

   
