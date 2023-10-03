import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
myVar  = sys.argv[2]

nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

dum = nc.variables[myVar][:,:,:]
dum = dum * 100.  

nc.variables[myVar][:,:,:] = dum 

print('done rescaling ',myVar)

nc.close()

