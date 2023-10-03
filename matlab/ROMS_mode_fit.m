function roms=ROMS_mode_fit(roms,nm)
psi=load(roms.files.psi_file);done('loading psi')
%%

[nz,ny,nx]=size(psi.P);nt = length(roms.files.his_files);
tdx=601:720;nt=length(tdx);
cu=nan*ones(nt,nm,ny,nx);cnt=1;
cv=nan*ones(nt,nm,ny,nx);cnt=1;
for fdx = tdx;disp(fdx)
u         = nc_varget(roms.files.his_files{fdx},'u');u=u(:,2:end-1,      :);uatr = (u(:,:      ,1:end-1)+u(:,:    ,2:end))/2;uatr=uatr(:,roms.jdx,roms.idx);
v         = nc_varget(roms.files.his_files{fdx},'v');v=v(:,:      ,2:end-1);vatr = (v(:,1:end-1,:      )+v(:,2:end,:    ))/2;vatr=vatr(:,roms.jdx,roms.idx);
time(cnt) = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.his_files{fdx} ,'ocean_time')/86400;
for ii = 1:nx;
for jj = 1:ny;
    if  ~isnan(psi.pmodes(1,1,jj,ii))
     tmppsi = psi.pmodes(:,:,jj,ii);
     datu = (uatr(:,jj,ii));
     datv = (vatr(:,jj,ii));
     cu(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datu);
     cv(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datv);
    end
end;
end;cnt=cnt+1;
end
roms.cu    = cu;
roms.cv    = cv;
roms.ctime = time;
