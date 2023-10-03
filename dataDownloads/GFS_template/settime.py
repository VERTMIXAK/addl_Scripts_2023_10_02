import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
timeName = sys.argv[2]
timeShift = int(sys.argv[3])

print('timeName  ',timeName)
print('timeShift ',timeShift)

nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

time = nc.variables[timeName][:]
print('time ', time)
time = time / 24 + timeShift

# convert to minutes
#time = time * 24 

print('new time ', time) 

nc.variables[timeName][:] = time

nc.close()
