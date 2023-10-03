
roms.files.cfile   = [roms.analysis_path,'roms_c_m_',roms.latlonRange,'.mat'];

if ~exist(roms.files.cfile)
nt = length(nc_varget(roms.files.hprhofile,'ocean_time'));
cu=nan*ones(nt,nm,ny,nx);
cv=nan*ones(nt,nm,ny,nx);
cr=nan*ones(nt,nm,ny,nx);cnt=1;

% I removed the BT signal first but unsurprisingly  found that it made little difference to the fit.
%%
for tdx = 1:nt;disp(['fitting u,v,rho to eigenfunctions, file ',num2str(tdx),' of ',num2str(nt)])
rhohp       = flipdim(nc_varget(roms.files.hprhofile,'rho_hp'   ,[tdx-1,0,0,0],[1,-1,-1,-1]),1);

tmpu       = nc_varget(roms.files.his_hourly_files{tdx},'u'   ,[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,length(jdxs)  ,length(idxs)+1]);
tmpv       = nc_varget(roms.files.his_hourly_files{tdx},'v'   ,[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,length(jdxs)+1,length(idxs)  ]);

uatr = flipdim((tmpu(:,:      ,1:end-1)+tmpu(:,:    ,2:end))/2,1);
vatr = flipdim((tmpv(:,1:end-1,:      )+tmpv(:,2:end,:    ))/2,1);

ctime(cnt) = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.his_hourly_files{tdx} ,'ocean_time')/86400;
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
    if  ~isnan(psi.rmodes(1,1,jj,ii))
     tmppsi = psi.rmodes(:,1:nm,jj,ii);
     datr   = (rhohp(:,jj,ii));
     cr(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datr);
    end

end; % jj
end; % ii
cnt=cnt+1;
end
eval(['save -v7.3 ',roms.files.cfile, ' cu cv cr ctime'])
else
 eval(['load       ',roms.files.cfile, ' cu cv cr ctime'])
end
