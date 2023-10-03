import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

west = nc.variables['temp_west'][0,:,:]
east = nc.variables['temp_east'][0,:,:]
north = nc.variables['temp_north'][0,:,:]
south = nc.variables['temp_south'][0,:,:]
#spval = south._FillValue
spval = 1.e30



nc.createDimension('dye_time', 1)
nc.createVariable('dye_time', 'f8', ('dye_time'))
nc.variables['dye_time'].units = 'days'
nc.variables['dye_time'][:] = 0.0


# west

west = 1.0
east = 0.0
north = 0.0
south = 0.0


nc.createVariable('dye_east_01', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_01'].long_name = 'Eastern boundary condition for dye_01.'
nc.variables['dye_east_01'].units = 'N/A'
nc.variables['dye_east_01'].time = 'dye_time'
nc.variables['dye_east_01'][:] = east

nc.createVariable('dye_west_01', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_01'].long_name = 'Western boundary condition for dye_01.'
nc.variables['dye_west_01'].units = 'N/A'
nc.variables['dye_west_01'].time = 'dye_time'
nc.variables['dye_west_01'][:] = west

nc.createVariable('dye_south_01', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_01'].long_name = 'Southern boundary condition for dye_01.'
nc.variables['dye_south_01'].units = 'N/A'
nc.variables['dye_south_01'].time = 'dye_time'
nc.variables['dye_south_01'][:] = south

nc.createVariable('dye_north_01', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_01'].long_name = 'Northern boundary condition for dye_01.'
nc.variables['dye_north_01'].units = 'N/A'
nc.variables['dye_north_01'].time = 'dye_time'
nc.variables['dye_north_01'][:] = north


























# south

west = 0.0
east = 0.0
north = 0.0
south = 1.0


nc.createVariable('dye_east_03', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_03'].long_name = 'Eastern boundary condition for dye_03.'
nc.variables['dye_east_03'].units = 'N/A'
nc.variables['dye_east_03'].time = 'dye_time'
nc.variables['dye_east_03'][:] = east

nc.createVariable('dye_west_03', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_03'].long_name = 'Western boundary condition for dye_03.'
nc.variables['dye_west_03'].units = 'N/A'
nc.variables['dye_west_03'].time = 'dye_time'
nc.variables['dye_west_03'][:] = west

nc.createVariable('dye_south_03', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_03'].long_name = 'Southern boundary condition for dye_03.'
nc.variables['dye_south_03'].units = 'N/A'
nc.variables['dye_south_03'].time = 'dye_time'
nc.variables['dye_south_03'][:] = south

nc.createVariable('dye_north_03', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_03'].long_name = 'Northern boundary condition for dye_03.'
nc.variables['dye_north_03'].units = 'N/A'
nc.variables['dye_north_03'].time = 'dye_time'
nc.variables['dye_north_03'][:] = north


























# east

west = 0.0
east = 1.0
north = 0.0
south = 0.0


nc.createVariable('dye_east_05', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_05'].long_name = 'Eastern boundary condition for dye_05.'
nc.variables['dye_east_05'].units = 'N/A'
nc.variables['dye_east_05'].time = 'dye_time'
nc.variables['dye_east_05'][:] = east

nc.createVariable('dye_west_05', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_05'].long_name = 'Western boundary condition for dye_05.'
nc.variables['dye_west_05'].units = 'N/A'
nc.variables['dye_west_05'].time = 'dye_time'
nc.variables['dye_west_05'][:] = west

nc.createVariable('dye_south_05', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_05'].long_name = 'Southern boundary condition for dye_05.'
nc.variables['dye_south_05'].units = 'N/A'
nc.variables['dye_south_05'].time = 'dye_time'
nc.variables['dye_south_05'][:] = south

nc.createVariable('dye_north_05', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_05'].long_name = 'Northern boundary condition for dye_05.'
nc.variables['dye_north_05'].units = 'N/A'
nc.variables['dye_north_05'].time = 'dye_time'
nc.variables['dye_north_05'][:] = north


























# north

west = 0.0
east = 0.0
north = 1.0
south = 0.0


nc.createVariable('dye_east_07', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_07'].long_name = 'Eastern boundary condition for dye_07.'
nc.variables['dye_east_07'].units = 'N/A'
nc.variables['dye_east_07'].time = 'dye_time'
nc.variables['dye_east_07'][:] = east

nc.createVariable('dye_west_07', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_07'].long_name = 'Western boundary condition for dye_07.'
nc.variables['dye_west_07'].units = 'N/A'
nc.variables['dye_west_07'].time = 'dye_time'
nc.variables['dye_west_07'][:] = west

nc.createVariable('dye_south_07', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_07'].long_name = 'Southern boundary condition for dye_07.'
nc.variables['dye_south_07'].units = 'N/A'
nc.variables['dye_south_07'].time = 'dye_time'
nc.variables['dye_south_07'][:] = south

nc.createVariable('dye_north_07', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_07'].long_name = 'Northern boundary condition for dye_07.'
nc.variables['dye_north_07'].units = 'N/A'
nc.variables['dye_north_07'].time = 'dye_time'
nc.variables['dye_north_07'][:] = north


nc.close()




