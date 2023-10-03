#!/bin/bash

source ~/.runPycnal

year=2020

#python regrid_runoff.py NG_100m -z --regional_domain -f ./riverSource.nc NG_runoff_${year}.nc >log


python add_rivers.py USGS_NG_rivers_${year}.nc
python make_river_clim.py NG_runoff_${year}.nc USGS_NG_rivers_${year}.nc
## Squeezing JRA is dangerous - different number of rivers when you change years.
##python squeeze_rivers.py JRA-1.4_Barrow_rivers_${year}.nc squeeze.nc
##mv squeeze.nc JRA-1.4_Barrow_rivers_${year}.nc


python add_temp_3D.py USGS_NG_rivers_${year}.nc


python set_vshape.py USGS_NG_rivers_${year}.nc

