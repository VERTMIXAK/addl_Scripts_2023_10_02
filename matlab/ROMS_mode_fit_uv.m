function roms=ROMS_mode_fit_uv(roms,nm)
psi=load(roms.files.psi_file,'pmodes','P');done('loading psi')
%%
%keyboard
%%
[nz,ny,nx]=size(psi.P);nt = length(roms.files.his_hourly_files);
tdxs=roms.tdxs;nt=length(tdxs);
jdxs=roms.jdxs;
idxs=roms.idxs;
cu=nan*ones(nt,nm,ny,nx);cnt=1;
cv=nan*ones(nt,nm,ny,nx);cnt=1;

%ubtoutfile = [roms.path2,'/ubt_vbt_his2.nc']
%ubt=nc_varget(ubtoutfile,'ubar',[tdxs(1)-1,jdxs(1)-1,idxs(1)-1],[nt,ny,nx+1]);done('loading ubt')
%vbt=nc_varget(ubtoutfile,'vbar',[tdxs(1)-1,jdxs(1)-1,idxs(1)-1],[nt,ny+1,nx]);done('loading vbt')
%%
%%
for tdx = 1:nt;disp(['fitting u and v to psi, file ',num2str(tdxs(tdx)),' of ',num2str(tdxs(nt))])

his_hourly_file =roms.files.his_hourly_files{tdxs(tdx)};

tmpu       = nc_varget(his_hourly_file,'u'   ,[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,length(jdxs)  ,length(idxs)+1]);
tmpv       = nc_varget(his_hourly_file,'v'   ,[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,length(jdxs)+1,length(idxs)  ]);

% I removed the BT signal first but unsurprisingly  found that it made little difference to the fit.
%tmpubt     = sq(ubt(tdx,:,:));tmpUBT = permute(repmat(tmpubt,[1 1 nz]),[3,1,2]);tmpu = tmpu-tmpUBT;
%tmpvbt     = sq(vbt(tdx,:,:));tmpVBT = permute(repmat(tmpvbt,[1 1 nz]),[3,1,2]);tmpv = tmpv-tmpVBT; 

uatr = flipdim((tmpu(:,:      ,1:end-1)+tmpu(:,:    ,2:end))/2,1);
vatr = flipdim((tmpv(:,1:end-1,:      )+tmpv(:,2:end,:    ))/2,1);

time(cnt) = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.his_hourly_files{tdx} ,'ocean_time')/86400;
%%
%keyboard
%%
for ii = 1:nx;
for jj = 1:ny;
    if  ~isnan(psi.pmodes(1,1,jj,ii))
     tmppsi = psi.pmodes(:,1:nm,jj,ii);
     datu = (uatr(:,jj,ii));
     datv = (vatr(:,jj,ii));
     %if ~isfinite(datu(1))&~isfinite(datv(1))
         cu(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datu);
         cv(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datv);
     %end
    end
end; % jj
end; % ii
cnt=cnt+1;
end  % 
roms.cu    = cu;
roms.cv    = cv;
roms.ctime = time;
