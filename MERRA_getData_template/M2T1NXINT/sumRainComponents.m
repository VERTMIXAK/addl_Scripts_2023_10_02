rainFile   = 'MERRA_rain_3hours_YYYY.nc'

preccu = nc_varget('MERRA_PRECCU_YYYY.nc','PRECCU');
precls = nc_varget('MERRA_PRECLS_YYYY.nc','PRECLS');
precsn = nc_varget('MERRA_PRECSN_YYYY.nc','PRECSN');

rain = preccu + precls + precsn;
nc_varput(rainFile,'rain',rain);

