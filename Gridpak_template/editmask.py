chinook> ipython -pylab

 
import pycnal
import pycnal_toolbox
from mpl_toolkits.basemap import Basemap, shiftgrid
import netCDF4

grd = pycnal.grid.get_ROMS_grid('NISKINEthilo_4km')

m = Basemap(projection='lcc',lat_1=50, lat_2=68, lon_0=-20, lat_0=59, width=5000000, height=5000000, resolution='h')

coast = pycnal.utility.get_coast_from_map(m)
pycnal.grid.edit_mask_mesh_ij(grd.hgrid, coast=coast)

#pycnal.grid.edit_mask_mesh(grd.hgrid, proj=m)
# this one was uncommented.  It's for writing the edited land mask to file
#pycnal.grid.write_ROMS_grid(grd, filename='temp.nc')
# This command is typed on the command line 
# ncks -v mask_rho,mask_u,mask_v,mask_psi grid_py.nc NI*.nc
# or simply copy temp.nc to PALAU_800m.nc
