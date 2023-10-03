import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
timeVar = sys.argv[2]

nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')


time = nc.variables[timeVar][:]
print('time ', time)


# this converts seconds since 1/1/1970 to days since 1/1/1900
timeShift = 2208988800 
time = time + timeShift
time = time / 86400

print('new time ', time)


nc.variables[timeVar][:] = time

nc.close()
