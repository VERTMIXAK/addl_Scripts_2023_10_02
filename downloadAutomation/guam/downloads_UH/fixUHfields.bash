myFile="UH.nc"

date=`ncdump -h UH.nc |grep 'time:units' | cut -d ' ' -f5`

dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"

ncrename -O -h -d time,ocean_time                                       UH.nc
ncrename -O -h -v time,ocean_time                                       UH.nc
ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00"     UH.nc

ncatted -O -a _FillValue,salt,d,,                                       UH.nc
ncatted -O -a _FillValue,temp,d,,                                       UH.nc
ncatted -O -a _FillValue,ubar,d,,                                       UH.nc
ncatted -O -a _FillValue,vbar,d,,                                       UH.nc
ncatted -O -a _FillValue,zeta,d,,                                       UH.nc
ncatted -O -a _FillValue,u,d,,                                       	UH.nc
ncatted -O -a _FillValue,v,d,,                                       	UH.nc



#ncatted -O -a _FillValue,salt,o,c,"1.e+37f"     						UH.nc
#ncatted -O -a _FillValue,temp,o,c,"1.e+37f"                             UH.nc
#ncatted -O -a _FillValue,u,o,c,"1.e+37f"                             	UH.nc
#ncatted -O -a _FillValue,u,o,c,"1.e+37f"                          		UH.nc
#ncatted -O -a _FillValue,ubar,o,c,"1.e+37f"                             UH.nc
#ncatted -O -a _FillValue,vbar,o,c,"1.e+37f"                             UH.nc
#ncatted -O -a _FillValue,zeta,o,c,"1.e+37f"                             UH.nc




#nxGrid=`ncdump -h $myFile |grep "X =" |cut -d "=" -f2 | cut -d " " -f2 `
#nyGrid=`ncdump -h $myFile |grep "Y =" |cut -d "=" -f2 | cut -d " " -f2 `
#
#echo "nx, ny =  " $nxGrid  $nyGrid

source ~/.runPycnal
python settime.py $myFile $dayNumber

