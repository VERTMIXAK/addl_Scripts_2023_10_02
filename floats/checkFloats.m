clear;

myDir='BoB_4km_2013_305_NoTides_365days_mesoNoTides_DyesFloats';

gfile = [myDir '/BoB_4km.nc'];exist(gfile)
grd=roms_get_grid(gfile);lonr=grd.lon_rho(1,:);latr=grd.lat_rho(:,1);grd
% ffile = [myDir '/set2_indices_RHSproblem/bob_flt.nc'];
% ffile = [myDir '/set1_LonLat/bob_flt.nc'];
% ffile = [myDir '/set3_indices_RHSinOne/bob_flt.nc'];
ffile = [myDir '/netcdfOutput/bob_flt.nc'];
lon = nc_varget(ffile,'lon');
lat = nc_varget(ffile,'lat');
time = roms_get_date(ffile);
%%
fig(1);clf
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

%%

% fig(2);clf;
% for tt=1:length(time)
%     plot(lon(2:end,tt),lat(2:end,tt),'.');hold on
% end


%%

x = nc_varget(ffile,'Xgrid');
y = nc_varget(ffile,'Ygrid');


%%
fig(20);clf;
imax=50;jmax=50;
 pcolor(grd.lon_rho(1:jmax,1:imax),grd.lat_rho(1:jmax,1:imax),grd.h(1:jmax,1:imax));shading flat;hold on
 tdx = find(time<time(1)+1);
 tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
 plot(tmplon,tmplat,'k.' )
 plot(tmplon(1),tmplat(1),'ro')
 
 fig(21);clf;
imax=50;jmax=50;
 pcolor(grd.lon_rho(1:jmax,end-imax:end),grd.lat_rho(1:jmax,end-imax:end),grd.h(1:jmax,end-imax:end));shading flat;hold on
 tdx = find(time<time(1)+1);
 tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
 plot(tmplon,tmplat,'k.' )
 plot(tmplon(1),tmplat(1),'ro')