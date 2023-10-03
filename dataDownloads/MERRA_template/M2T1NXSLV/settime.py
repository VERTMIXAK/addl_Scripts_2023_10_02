import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

minutes = sys.argv[2]
print(minutes)
print( int(minutes) )

time = nc.variables['time'][:]
print('time ', time)
time = time + 30 + int(minutes)

print('new time ', time) 

nc.variables['time'][:] = time

nc.close()
