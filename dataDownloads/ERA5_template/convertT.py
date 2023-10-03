import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')


# convert temp from K to C

Tair = nc.variables['Tair'][:,:,:]
#print('time ', time)
Tair = Tair -273.15

#print('new time ', time) 

nc.variables['Tair'][:,:,:] = Tair

nc.close()
