%function roms=ROMS_calc_psi(fdx,roms,nm,reprocit)
%% 
his_hourly_file     = roms.files.his_hourly_files{1};slashes = findstr(his_hourly_file,'/');

his_file               = roms.files.his_hourly_files{1};slashes = findstr(his_file,'/');
roms.files.psi_file    = [roms.analysis_path,'psi_',num2str(lon0),'_',num2str(lon1),'_',num2str(lat0),'_',num2str(lat1),'.mat']

if ~exist(roms.files.psi_file)

%N20file = [roms.path2,'N20.mat'];
% N20file = sprintf([roms.analysis_path,'N20_%d_%d_%d_%d.mat'],roms.lon0,roms.lon1,roms.lat0,roms.lat1);
N20file = [roms.analysis_path,'N20_',roms.latlonRange,'.mat'];


if ~exist(N20file)
T = flipdim(nc_varget(his_hourly_file,'temp'),1);T=T(:,2:end-1,2:end-1);done('loading temp for psi')
if strmatch(roms.type,'tideonly')
  S = 34.7+0*T;done('simple EOS, salt = 34.7 for psi')
else
  S = flipdim(nc_varget(his_hourly_file,'salt'),1);S=S(:,2:end-1,2:end-1);done('loading salt for psi')
end

%%
P=nan*ones(nz,ny,nx);N20=nan*ones(nz-1,ny,nx);p_ave=nan*ones(nz-1,ny,nx);
T = T(:,jdxs,idxs);
S = S(:,jdxs,idxs);
H=roms.grd.h(jdxs,idxs);
%%
%keyboard
%%
N20 = nan*ones(size(P));
for ii = 1:nx;disp(['calculating N20 in psi, ',num2str(ii),' of ',num2str(nx)])
 for jj = 1:ny
  P(:,jj,ii) = sw_pres(abs(z(:,jj,ii)),-43);
  tmpS = S(:,jj,ii);
  if max(tmpS)>0;
   [tmpN2,~,p_ave] = sw_bfrq(tmpS,T(:,jj,ii),P(:,jj,ii));tmpN2(tmpN2<1e-8)=1e-8; % roms actually uses potential tenperature but I am assuming it is in-situ
                                                                                 % clipping to a very tiny value of tmpN2 needs to be done anyway.
   tmpN2 = interp1(p_ave,tmpN2,P(:,jj,ii),'pchip');tmpN2(tmpN2<1e-8)=1e-8;
   N20(:,jj,ii) = tmpN2;
 end % good test
end % jj
end % ii
eval(['save -v7.3 ',N20file,' N20 P'])
else
eval(['load       ',N20file,' N20 P'])
end
done('N2')
%%
pmodes=nan*ones(nz,nm,ny,nx);
rmodes=nan*ones(nz,nm,ny,nx);
dmodes=nan*ones(nz,nm,ny,nx);
ce    =nan*ones(nm,ny,nx);
%%
%keyboard
%%
%ii=94;jj=52 % bad
for ii = 1:nx;disp(['calculating psi ',num2str(ii),' of ',num2str(nx)])
for jj = 1:ny
 if find(min(N20(:,jj,ii)>0)&max(P(:,jj,ii))>50)
  [ tmpwmodes,tmppmodes,tmpce,Pout]=ROMS_dynmodes(N20(:,jj,ii),P(:,jj,ii)); 
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
%%
 disp(['save -v7.3 ',roms.files.psi_file,' pmodes rmodes dmodes ce nm N20 P'])
 eval(['save -v7.3 ',roms.files.psi_file,' pmodes rmodes dmodes ce nm N20 P'])
 psi.pmodes=pmodes;
 psi.rmodes=rmodes;
else
 psi=load(roms.files.psi_file,'pmodes','rmodes');
end % exist psifile
%%

   
