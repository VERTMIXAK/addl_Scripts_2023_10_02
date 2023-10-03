epath = '/import/c1/VERTMIX/jgpender/roms-kate_svn/BoB_4km/Experiments/'
expn = 'BoB_4km_2013_305_NoTides_365days_mesoNoTides_nthTimesTheCharm';
gfile = [epath,expn,'/BoB_4km.nc'];exist(gfile)
grd=roms_get_grid(gfile);lonr=grd.lon_rho(1,:);latr=grd.lat_rho(:,1);grd
ffile = [epath,expn,'/netcdfOutput/bob_flt.nc'];
lon = nc_varget(ffile,'lon');
lat = nc_varget(ffile,'lat');
time = roms_get_date(ffile);
%%
f1;clf
subplot(2,1,1);
 pcolor(grd.lon_rho,grd.lat_rho,grd.h);shading flat;hold on
 tdx = find(time<time(1)+1);
 tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
 plot(tmplon,tmplat,'k.' )
 plot(tmplon(1),tmplat(1),'ro')
subplot(2,1,2);
 pcolor(grd.lon_rho,grd.lat_rho,grd.h);shading flat;hold on
 tdx = find(time<time(1)+30);
 tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
 plot(tmplon,tmplat,'k.')
 plot(tmplon(1),tmplat(1),'ro')
