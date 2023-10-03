sourceFile="../GLOBAL_PHY_bathy/GLO-MFC_001_024_mask_bathy.nc"


gridName=`pwd | rev | cut -d '/' -f1 | rev | cut -d '_' -f1`
#echo $gridName
outFile=$gridName"_bathy.nc"

#echo $outFile


lonmin=`grep lonmin latlon.txt | cut -d '=' -f2`
lonmax=`grep lonmax latlon.txt | cut -d '=' -f2`
latmin=`grep latmin latlon.txt | cut -d '=' -f2`
latmax=`grep latmax latlon.txt | cut -d '=' -f2`
echo "Longitude $lonmin  $lonmax"
echo "Latitude $latmin  $latmax"


iLat0=`echo " 12 * ( 80 + $latmin) " | bc `
iLat1=`echo " 12 * ( 80 + $latmax) " | bc `
iLon0=`echo " 12 * ( 180 + $lonmin) " | bc `
iLon1=`echo " 12 * ( 180 + $lonmax) " | bc `




echo "latitude indices" $iLat0 $iLat1
echo "longitude indices" $iLon0 $iLon1



iLat0=`printf "%.0f\n" $iLat0`
iLat1=`printf "%.0f\n" $iLat1`
iLon0=`printf "%.0f\n" $iLon0`
iLon1=`printf "%.0f\n" $iLon1`

echo "latitude indices" $iLat0 $iLat1
echo "longitude indices" $iLon0 $iLon1


ncks -d latitude,$iLat0,$iLat1 -d longitude,$iLon0,$iLon1 $sourceFile $outFile
