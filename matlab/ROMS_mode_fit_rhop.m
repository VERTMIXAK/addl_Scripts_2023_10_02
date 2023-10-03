function roms=ROMS_mode_fit_rhop(roms,nm)
%%
%keyboard
%%
psi=load(roms.files.psi_file,'rmodes','P');done('loading psir')
%%
[nz,ny,nx]=size(psi.P);nt = length(roms.files.his_hourly_files);
tdxs = roms.tdxs;nt=length(tdxs);
jdxs = roms.jdxs;
idxs = roms.idxs;
cr   = nan*ones(nt,nm,ny,nx);cnt=1;
count = [1,-1,ny  ,nx+1];
%%
for tdx = 1:nt;disp(['fitting rhop to psir, file ',num2str(tdxs(tdx)),' of ',num2str(tdxs(nt))])
%start = [tdxs(tdx)-1,0,jdxs(1)-1,idxs(1)-1]; now rhohp has been
%pre-extracted at tdxs,jdxs,idxs when it was highpasses
%rhohp       = flipdim(nc_varget(roms.files.hprhofile,'rho_hp'   ,start,count),1);
%%
%keyboard
%%
rhohp       = flipdim(nc_varget(roms.files.hprhofile,'rho_hp'   ,[tdx-1,0,0,0],[1,-1,-1,-1]),1);

for ii = 1:nx;
for jj = 1:ny;
    if  ~isnan(psi.rmodes(1,1,jj,ii))
     tmppsi = psi.rmodes(:,1:nm,jj,ii);
     datr   = (rhohp(:,jj,ii));
     cr(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datr);
    end
end; % jj
end; % ii
cnt=cnt+1;
end  % 
roms.cr    = cr;
