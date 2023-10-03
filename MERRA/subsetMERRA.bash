sourceDir='/import/VERTMIXFS/jgpender/roms-kate_svn/GlobalDataFiles'

# SEAK limits

region='SEAK'

latMin=50
latMax=62
lonMin=205
lonMax=230

#xmin=`echo "$lonMin * 3 / 2" | bc`
#xmax=`echo "$lonMax * 3 / 2" | bc`
xmin=`echo "$lonMin / .625" | bc`
xmax=`echo "$lonMax / .625" | bc`
ymin=`echo "( $latMin + 90 ) * 2" | bc`
ymax=`echo "( $latMax + 90 ) * 2" | bc`

echo $xmin
echo $xmax
echo $ymin
echo $ymax



myDir="MERRA_$region"
mkdir $myDir

for file in `ls $sourceDir/MERRA*2015.nc`
do
	echo $file

	shortName=`echo $file | rev | cut -d '/' -f1 | rev`
	echo $file  $shortName

	part1=`echo $shortName | cut -d '.' -f1`
	newName=`echo $part1"_"$region".nc"`

	echo "$myDir/$newName"

	ncks -d lon,$xmin,$xmax -d lat,$ymin,$ymax $file "$myDir/$newName"
done
