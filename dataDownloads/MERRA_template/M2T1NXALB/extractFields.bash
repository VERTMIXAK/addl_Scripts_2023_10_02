#!/bin/bash

source ~/.runROMSintel

# albedo
outFile='MERRA_albedo.nc'
\rm $outFile

ncrcat data/MERRA* $outFile

ncrename -h -O -d time,albedo_time -v ALBEDO,albedo $outFile
ncatted -O -a coordinates,albedo,a,c,"lon lat" $outFile

