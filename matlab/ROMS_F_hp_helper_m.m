function ROMS_F_hp_helper_m(roms)
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
H   = roms.grd.h  ;H   =   H(  2:end-1,2:end-1);  H = sq(  H(  jdxs,idxs));
z   =-flipdim(roms.grd.z_r,1);z   =   z(:,2:end-1,2:end-1);  z = sq(  z(:,jdxs,idxs));
dzr = flipdim(roms.grd.dzr,1);dzr = dzr(:,2:end-1,2:end-1);dzr = sq(dzr(:,jdxs,idxs));
%dzu = roms.grd.dzu;dzu = dzu(:,2:end-1,2:end-1);dzu = sq(dzu(:,jdxs,idxs)); 
%dzv = roms.grd.dzv;dzv = dzv(:,2:end-1,2:end-1);dzv = sq(dzv(:,jdxs,idxs)); 
lon = lon(jdxs,idxs);
lat = lat(jdxs,idxs);
roms.lon = lon;
roms.lat = lat;
nz=length(z(:,1,1));nx=length(idxs);ny=length(jdxs);nm=roms.nm;

roms.files.Ffile = [roms.analysis_path,'roms_F_m_',roms.latlonRange,'.mat'];
disp(roms.files.Ffile)
if ~exist(roms.files.Ffile)
%%
ROMS_concatenate_T_S;done('concatenate_T_S')
ROMS_hp_rho         ;done('concatenate_hp_rho')
ROMS_calc_psi       ;done('concatenate_calc_psi')
ROMS_mode_fit_uvr   ;done('concatenate_mode_fit_uvr')
ROMS_hp_modes       ;done('concatenate_hp_modes')
%%
Fu_m=nan*ones(nt,nm,ny,nx);Fv_m=Fu_m;
for mdx =1:nm;disp(['reconstructing flux, mode = ',num2str(mdx)])
    for jj=1:ny
    for ii=1:nx
    tmpdz = repmat(dzr(:,jj,ii),1,nt);
    rhopr = sq(psi.rmodes(:,mdx,jj,ii))*sq(cr(:,mdx,jj,ii))'; % I hope there is no way to accidently use the un-highpassed version of cu...
    upr   = sq(psi.pmodes(:,mdx,jj,ii))*sq(cu(:,mdx,jj,ii))';
    vpr   = sq(psi.pmodes(:,mdx,jj,ii))*sq(cv(:,mdx,jj,ii))';

    Ppr  = 9.8*cumsum(rhopr.*tmpdz);
    PprBAR = sq(sum(Ppr.*tmpdz)./sum(tmpdz));
    PPRBAR = repmat(PprBAR,[nz,1]);pr = Ppr-PPRBAR;
 
    Fu_m(:,mdx,jj,ii) = sq(sum(upr.*pr.*tmpdz));
    Fv_m(:,mdx,jj,ii) = sq(sum(vpr.*pr.*tmpdz));

    end
    end
end
ta_Fu_m=sq(mean(Fu_m));
ta_Fv_m=sq(mean(Fv_m));
%%
 eval(['save -v7.3 ',roms.files.Ffile,' Fu_m Fv_m ta_Fu_m ta_Fv_m ctime H lon lat']);
else % does not exist
 %eval(['load       ',roms.files.Ffile,' Fu_m Fv_m ta_Fu_m ta_Fv_m ctime H lon lat']);
end
