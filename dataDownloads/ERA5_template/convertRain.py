import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

# divide by 3.6 to get kg/m /s

rain = nc.variables['rain'][:,:,:]
rain = rain / 3.6

nc.variables['rain'][:,:,:] = rain

nc.close()
