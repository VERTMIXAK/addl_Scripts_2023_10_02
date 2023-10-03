import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
fieldName = sys.argv[2]

print('fieldName  ',fieldName)

nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

field = nc.variables[fieldName][:,:] 
field = field / 100.



nc.variables[fieldName][:,:] = field

nc.close()
