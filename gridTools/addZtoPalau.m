clear

% Get the grid.


gridFile = './PALAU_0.0083.nc'
hisFile = './fleat_inner_avg_05423.nc'

ROMSgrid=roms_get_grid(gridFile,hisFile,0,1);