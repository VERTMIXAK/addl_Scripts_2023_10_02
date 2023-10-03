rainFile   = 'MERRA_rain.nc'

preccu = nc_varget('MERRA_PRECCU.nc','PRECCU');
precls = nc_varget('MERRA_PRECLS.nc','PRECLS');
precsn = nc_varget('MERRA_PRECSN.nc','PRECSN');

rain = preccu + precls + precsn;
nc_varput(rainFile,'rain',rain);

