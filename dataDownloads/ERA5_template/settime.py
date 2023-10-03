import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')


time = nc.variables['time'][:]
print('time ', time)
time = time / 24.

print('new time ', time) 

nc.variables['time'][:] = time

nc.close()
