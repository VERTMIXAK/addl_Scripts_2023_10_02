import re
import numpy as np
import netCDF4
import sys
import pdb
from scipy.interpolate import interp1d
import pycnal

outfile = sys.argv[1]

grd = pycnal.grid.get_ROMS_grid('NG_100m')
lat_rho = grd.hgrid.lat_rho

# time array, 12 day numbers over the course of a year
time2 = [0, 46, 76, 107, 137, 167, 198, 228, 259, 289, 320, 365]

# river temperature, one for each element in the time array
#t2 = [0.0, 0.0, 0.0, 0.0, 2.0, 10.0, 15.0, 13.0, 5.0, 2.0, 0.0, 0.0]
#t2 = [28.0, 28.0, 28.0, 28.0, 28.0, 28.0, 28.0, 28.0, 28.0, 28.0, 28.0, 28.0]

# jgp NOTE: I made up the last 3 temperature in the following line
t2 = [2.7, 3.3, 7.3, 9.4, 16.2, 22.0, 24.6, 24.2, 18.6, 13.0, 5.0, 2.7]

# river salinity, one for each element in the time array   
s2 = [0.0, 0.0, 0.0, 0.0, 0.0,  0.0,  0.0,  0.0, 0.0, 0.0, 0.0, 0.0]

# river dye, 
d2 = [1.0, 1.0, 1.0, 1.0, 1.0,  1.0,  1.0,  1.0, 1.0, 1.0, 1.0, 1.0]

# create file with all the objects
out = netCDF4.Dataset(outfile, 'a', format='NETCDF3_64BIT')
xi = out.variables['river_Xposition'][:]
eta = out.variables['river_Eposition'][:]
Nr = xi.shape[0]

Nz = Nr - Nr + 50

temp_tr = np.zeros((len(time2), Nz, Nr))
salt_tr = np.zeros((len(time2), Nz, Nr))
dye_tr = np.zeros((len(time2), Nz, Nr))

for rr in range(Nr):
    for kk in range(Nz):
        temp_tr[:,kk,rr] = t2
        salt_tr[:,kk,rr] = s2
        dye_tr[:,kk,rr]  = d2

# create a time dimension for salt and temp
out.createDimension('river_tracer_time', len(time2))


# make space in the netcdf file for the new fields

times = out.createVariable('river_tracer_time', 'f8', ('river_tracer_time'))
times.units = 'day'
times.cycle_length = 365.25
times.long_name = 'river tracer time'

temp = out.createVariable('river_temp', 'f8', ('river_tracer_time', 's_rho', 'river'))
temp.long_name = 'river runoff potential temperature'
temp.units = 'Celsius'
temp.time = 'river_tracer_time'

salt = out.createVariable('river_salt', 'f8', ('river_tracer_time', 's_rho', 'river'))
salt.long_name = 'river runoff salinity'
salt.time = 'river_tracer_time'

#dye = out.createVariable('river_dye_01', 'f8', ('river_tracer_time', 's_rho', 'river'))
#dye.long_name = 'river dye'
#dye.time = 'river_tracer_time'

#age = out.createVariable('river_dye_02', 'f8', ('river_tracer_time', 's_rho', 'river'))
#age.long_name = 'river dye age'
#age.time = 'river_tracer_time'


##dye = out.createVariable('river_dye_03', 'f8', ('river_tracer_time', 's_rho', 'river'))
##dye.long_name = 'river dye'
##dye.time = 'river_tracer_time'
#
##age = out.createVariable('river_dye_04', 'f8', ('river_tracer_time', 's_rho', 'river'))
##age.long_name = 'river dye age'
##age.time = 'river_tracer_time'



print('temp_tr ',temp_tr)


# write data to the new fields in the netcdf file

out.variables['river_tracer_time'][:] = time2 
out.variables['river_temp'][:,:,:] = temp_tr 
out.variables['river_salt'][:,:,:] = salt_tr
#out.variables['river_dye_01'][:] = dye_tr
#out.variables['river_dye_02'][:] = 0*dye_tr
##out.variables['river_dye_03'][:] = 100*dye_tr
##out.variables['river_dye_04'][:] = 0*dye_tr



out.close()

