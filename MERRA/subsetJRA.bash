sourceDir='/import/c1/AKWATERS/kate/JRA55-do'

# BARROW limits

region='BARROW'

latMin=65
latMax=80
lonMin=190
lonMax=225

# The JRA files do pretty much the whole planet

# lat goes from -89.57 to 89.57 in .562568 deg increments 

# lat goes from 0 to 359.4375 in 

# lon is 

xmin=`echo "$lonMin / .5625 + 1" | bc`
xmax=`echo "$lonMax / .5625 + 1" | bc`
ymin=`echo "( $latMin + 89.57 ) / .561568 + 1" | bc`
ymax=`echo "( $latMax + 89.57 ) / .561568 + 1" | bc`

echo $xmin
echo $xmax
echo $ymin
echo $ymax


myDir="JRA_$region"
mkdir $myDir

year="2018"

for file in `ls $sourceDir/JRA*$year.nc`
do

	echo $file

	shortName=`echo $file | rev | cut -d '/' -f1 | rev `
	echo $file  $shortName

	part1=`echo $shortName | cut -d '.' -f1-2`
	newName=`echo $part1"_"$region".nc"`

	echo $newName

	ncks -d lon,$xmin,$xmax -d lat,$ymin,$ymax $file "$myDir/$newName"
done
