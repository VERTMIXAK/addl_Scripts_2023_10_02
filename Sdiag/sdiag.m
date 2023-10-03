clear;
hisFile  = 'netcdfOutput/palau_his_00001.nc';
his2File = 'netcdfOutput/palau_his2_00001.nc';
gridFile = 'PALAU_800m.nc';

grd = roms_get_grid(gridFile,hisFile,0,1);

% get surface velocities

u = nc_varget(his2File,'u');
v = nc_varget(his2File,'v');

S_psi = ROMS_calc_strain(sq(u(1,:,:)),sq(v(1,:,:)),grd);

fig(5);clf;
pcolor(S_psi);shading flat;colorbar;caxis([0 10^-4])

aaa=5;

