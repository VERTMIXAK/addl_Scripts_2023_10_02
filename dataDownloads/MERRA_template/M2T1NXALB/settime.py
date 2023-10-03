import numpy as np
import netCDF4
import sys

ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

seconds = sys.argv[2]
minutes = int(seconds)/60

print(minutes)
print( int(minutes) )

albedo = nc.variables['ALBEDO'][:,:,:]

myShape = albedo.shape
print('myShape ',myShape)

for jj in range(myShape[1]):
	for ii in range(myShape[2]):
		albedo[0,jj,ii] = np.nanmean(albedo[:,jj,ii])
nc.variables['ALBEDO'][:,:,:] = albedo

# convert time to minutes because the file has time defined as an integer
time = nc.variables['time'][:]
print('time ', time)
print('minutes', int(minutes))
time[0] = int(minutes) + 720  

print('new time ', time) 

nc.variables['time'][:] = time

nc.close()
