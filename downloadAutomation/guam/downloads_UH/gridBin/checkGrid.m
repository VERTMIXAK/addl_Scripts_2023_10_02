file = 'gridBrian.nc_ORIG';

lon_rho = nc_varget(file,'lon_rho');
lat_rho = nc_varget(file,'lat_rho');

lon_psi = nc_varget(file,'lon_psi');
lat_psi = nc_varget(file,'lat_psi');

lon_u = nc_varget(file,'lon_u');
lat_u = nc_varget(file,'lat_u');

lon_v = nc_varget(file,'lon_v');
lat_v = nc_varget(file,'lat_v');

%% rho vs psi

fig(1);clf;
plot(lon_psi,lat_psi,'.')
hold on
plot(lon_rho,lat_rho,'*')

fig(2);clf;
plot(lon_rho,lat_rho,'*')
hold on
plot(lon_psi,lat_psi,'.')

%% rho vs u

fig(1);clf;
plot(lon_u,lat_u,'.')
hold on
plot(lon_rho,lat_rho,'*')

fig(2);clf;
plot(lon_rho,lat_rho,'*')
hold on
plot(lon_u,lat_u,'.')

%% rho vs v

fig(1);clf;
plot(lon_v,lat_v,'.')
hold on
plot(lon_rho,lat_rho,'*')

fig(2);clf;
plot(lon_rho,lat_rho,'*')
hold on
plot(lon_v,lat_v,'.')