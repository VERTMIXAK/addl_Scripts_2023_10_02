import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]

nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

Tair = nc.variables['Tair'][:,:,:]
Tair = Tair - 273.16

nc.variables['Tair'][:,:,:] = Tair

print('done converting Kelvin to Celsius')

nc.close()

