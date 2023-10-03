#!/bin/bash
source ~/.runROMSintel

export INTEL_LICENSE_FILE=28518@license.rcs.alaska.edu


read -r -p "Interactive? [y/n] " interactive

printenv | grep -i license
echo " "
echo " "

# netcdf defs are in coaswt.bash now
#printenv |grep NETCDF
#export NETCDF=/usr/local/pkg/netcdf/netcdf-4.3.0.intel-2016
#export NETCDF_INCDIR=/usr/local/pkg/netcdf/netcdf-4.3.0.intel-2016/include

export PATH=$PATH\:~/bin:.
export LD_LIBRARY_PATH=$HOME/PyCNAL_fromKate/site-packages:$LD_LIBRARY_PATH
export PYCNAL_GRIDID_FILE=$HOME/Python/gridid.txt
export PYCNAL_GRID_FILE=$HOME/Python/gridid.txt
export PYCNAL_PATH=$HOME/Python
export XCOASTDATA=/import/c/w/jpender/ROMS/BathyData/world_int.cst
export ETOPO2=/import/c/w/jpender/ROMS/BathyData/etopo2.Gridpak.nc
export TOPO30=/import/c/w/jpender/ROMS/BathyData/topo30.Gridpak_TS.nc
export TOPO30TS=/import/c/w/jpender/ROMS/BathyData/topo30.Gridpak_TS.nc
export INDIANO2=/import/c/w/jpender/ROMS/BathyData/indiano2.Gridpak.nc
export PALAU_HIRES=/import/c/w/jpender/ROMS/BathyData/Palau_hires.nc 

umask 0027




clear

echo ""
echo ""
echo ""


ROMSdir=`pwd`
#echo $ROMSdir

#ROI="PALAU"
#ROI="GUAM"
#ROI="SCS"
#ROI="NISKINEthilo"
#ROI="TS"
#ROI="BoB"
#ROI="BoB4"
#ROI="SO"
#ROI="GUAMB"
#ROI="SCSA"
#ROI="NISKINEthilo"
#ROI="NISKINE1D"
#ROI="BARROWCtelescope"
#ROI="BARROWB"
#ROI="FLEAT"
#ROI="SEAKp"
#ROI="NG"
#ROI="MCKR"
#ROI="GUAMBinner"
#ROI="HC"
ROI="NORSEd"

#gridRes="0.015625"
#gridRes="0.03125"
gridRes="1km"
#gridRes="2km"
#gridRes="4km"
#gridRes="8km"
#gridRes="UH"
#gridRes="HYCOM"
#gridRes="HYCOMMERRA"
#gridRes="15_120"
#gridRes="120B"
#gridRes="120C_UHMERRA"
#gridRes="120C_Inner"
#gridRes="120C_UH_Direct"
#gridRes="120C_HYCOMMERRA"
#gridRes="120"
#gridRes="120HYCOMMERRA"
#gridRes="120HYCOM"
#gridRes="0.125"
#gridRes="0.25"
#gridRes="150m"
#gridRes="500m"
#gridRes="8000m"
#gridRes="Kate"
#gridRes="KateNoIce"


# pick one and only one option from this set
#exptMode="noForcing"
#exptMode="tidesOnly"
#exptMode="meso"
#exptMode="mesoTides_LMD"
exptMode="mesoNoTides"
#exptMode="mesoNoTides_LMD"
#exptMode="meso_Eig"
#exptMode="tidesOnly_Eig"
#exptMode="meso_UHdirect"
#exptMode="mesoNotides_GLS_CHARNOK_CRAIG"
#exptMode="mesoNoTides_LMD_ROMSonly"

exptname=`echo $ROI"_"$gridRes | tr "[A-Z]" "[a-z]"`
echo $exptname
gridName=$ROI"_"$gridRes

Appsdir="Apps/"$gridName"/"
compileInputFile=$Appsdir$exptname".h"
runInputFile=$Appsdir"ocean_"$exptname".in"
runRestartFile=$runInputFile"_restart"
varinfoFile="./Apps/varinfo_LOCAL.dat"

#echo $compileInputFile"_"$exptMode

printf "cp $compileInputFile"_"$exptMode \t\t$compileInputFile\n"
cp $compileInputFile"_"$exptMode $compileInputFile

printf "cp $runInputFile"_"$exptMode  \t$runInputFile\n"
cp $runInputFile"_"$exptMode     $runInputFile

#printf "cp $varinfoFile"_*"  \t$varinfoFile\n"
#cp $varinfoFile"_"$exptMode     $varinfoFile


#!!!!!!!!!!!!!!!!!!!!!!!
# Optional note to append to the experiment name
nameAppend=""
#nameAppend="_fixFloats"
#nameAppend="_wetdry"
#nameAppend="_addRivers"
#nameAppend="_LMD"
#nameAppend="_addPvort"
#nameAppend="_SurfFOff"
#nameAppend="_mesoStart_LBCoff_SURFoff"
#nameAppend="_nud1_tryDIAGS"
#nameAppend="_IceFloats_modifyFloats"
#nameAppend="_IceOnly"
#nameAppend="_IceDye"
#nameAppend="_IceandDyeandFloats"
#nameAppend="_recheckSpeedWithoutFloats"
#nameAppend="_noFloats"
#nameAppend="_GLS_riverdye_CHARNOK_CRAIG"
#nameAppend="_GLS_rivers_noDye_Hill"
#nameAppend="_LMD_addRivers"
#nameAppend="_wetDryOn"
#nameAppend="_newDyeLBC"
#nameAppend="_GLS_CRAIG_CHARNOK"
#nameAppend="_SourceDataAlreadyHasTides"
#nameAppend="_proto"
nameAppend="_MERRA_GLS"
echo "optional note on file name is " $nameAppend


echo ""

echo "experiment mode:    " $exptMode
echo "grid name:          " $gridName
echo "compile input file: " $compileInputFile
echo "run input file:     " $runInputFile
echo "restart input file: " $runRestartFile
echo "varinfo file:       " $varinfoFile
echo "name append:        " $nameAppend
echo ""


### Start extracting information from relevant files as an internal consistency check.

#gridFile=`grep GRDNAME $runInputFile | grep -v '!' | cut -d '.' -f2-10`

gridFile=`grep GRDNAME $runInputFile | grep -v '!' `
gridFileShort=`echo $gridFile | rev | cut -d '/' -f1 | rev `
echo "gridFile = $gridFile"
echo "gridFileShort = $gridFileShort"
echo "The grid file for this experiment is $gridFile"
echo ""



echo $runInputFile
# get the desired tiling from the run input file
tileX=`grep "NtileI ==" $runInputFile  | cut -d "=" -f3 | head -c 7`
tileY=`grep "NtileJ ==" $runInputFile  | cut -d "=" -f3 | head -c 7`
echo "tileX is "$tileX
echo "tileY is "$tileY
echo ""


echo "experiment mode is $exptMode"
echo " "





# check for analytic start

if [ `grep -c ANA_INITIAL $runInputFile` == 1 ];then
	echo "analytic start, so no real start date"
else
   echo "start from ini file"
    ini_name=`grep ININAME $runInputFile | grep -v '!' | cut -d '=' -f3  `
    echo "IC file name is  "$ini_name
 
    dstart=`grep DSTART $runInputFile | grep -v '! !' | head -1 | cut -d "." -f1 | tail -c 6`
    echo "dstart from ocean.in file is " $dstart

#   echo "./"$gridName`echo $ini_name | cut -d "." -f5-10`
    if [ ! -e "./"$gridName`echo $ini_name | cut -d "." -f5-10` ]; then
        echo "IC file doesn't exist"
####        exit 1
        fi


    temp=`echo $ini_name | rev | cut -d "/" -f1-4 | rev`
    ini_name2=$gridName"/"$temp
#    echo "temp " $temp "  ini_name2 " $ini_name2
 
    dstart=`ncdump -v ocean_time  $ini_name2 | grep "ocean_time =" | grep -v "UN" | cut -c 15-19`
    echo "day number from IC file is " $dstart  



#    date=`echo $ini_name2 | rev | cut -d "/" -f1 | rev | cut -d "_" -f2-3 `
##   date=`echo $ini_name2 | rev | cut -d "/" -f1 | cut -d "_" -f5-6 | rev`
#    echo "start date stamp is: " $date	

	myYear=`grep ','$dstart',' ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d '-' -f1`
	myDay=`grep ','$dstart',' ~/arch/addl_Scripts/dayConverterCommas.txt | tr -s ' ' | tr ' ' ',' | cut -d ',' -f4`

	date=$myYear'_'$myDay
    echo "start date stamp is: " $date

	echo " "
fi


# spot check
case $interactive in
    [yY][eE][sS]|[yY])
 
  read -r -p "Everything OK? [Y/n] " input
 
  case $input in
     [nN][oO]|[nN])
  exit 1
       ;;
  esac

  ;;
esac


# check tidal forcing

useTides=`grep TIDENAME $runInputFile | grep -vc '^!'`
echo "useTides: " $useTides

if [ $useTides == '1' ]; then
	echo "use tidal forcing"
	tideCode=`grep TIDENAME $runInputFile | grep -v '^!' | rev | cut -d '/' -f1 | rev | cut -d '_' -f2 | cut -d '.' -f1`
	tideCode="_$tideCode"
else
	tideCode=""
fi
	echo "tide code is " $tideCode

#exit


# find length of run
echo ""
ntimes=`grep NTIMES $runInputFile | grep -v "!" | cut -d "=" -f3`
dt=`grep "DT ==" $runInputFile | grep -v "!" | cut -d "=" -f3 | cut -d "." -f1`

echo 'ntimes=' $ntimes
echo 'dt=' $dt

runDays=` echo " $ntimes * $dt / 86400 " | bc`
echo "run time is " $runDays " days"
echo ""


# check elevations for Tair, Qair, and wind
# To date, we can use MERRA, JRA5 or ERA5

echo "runInputFile" $runInputFile

forceTair=`grep Tair $runInputFile | grep -v '^!' | grep Global | head -1 | rev |cut -d '/' -f1| rev | cut -d '_' -f1`
#echo "forceTair " $forceTair

forceQair=`grep Qair $runInputFile | grep -v '^!' | grep Global | head -1 | rev |cut -d '/' -f1| rev | cut -d '_' -f1`
#echo "forceQair " $forceQair

forceWind=`grep Uwind $runInputFile | grep -v '^!' | grep Global | head -1 | rev |cut -d '/' -f1| rev | cut -d '_' -f1`
#echo "forceWind " $forceWind

blkZQ=`grep BLK_ZQ $runInputFile | grep -v '^!' | cut -d '=' -f3 | cut -d ' ' -f2`
blkZT=`grep BLK_ZT $runInputFile | grep -v '^!' | cut -d '=' -f3 | cut -d ' ' -f2`
blkZW=`grep BLK_ZW $runInputFile | grep -v '^!' | cut -d '=' -f3 | cut -d ' ' -f2`

if [ $forceTair == "JRA55DO" ]; then
	echo "using JRA55DO forcing for Tair. Should have BLK_ZT = 2 m, currently $blkZT" 
elif [ $forceTair == "MERRA" ]; then
    echo "using MERRA forcing for Tair. Should have BLK_ZT = 2 m, currently $blkZT"
elif [ $forceTair == "ERA5" ]; then
    echo "using ERA5 forcing for Tair. Should have BLK_ZT = 2 m, currently $blkZT"
elif [ $forceTair == "GFS" ]; then
    echo "using GFS forcing for Tair. Should have BLK_ZT = 2 m, currently $blkZT"
fi


if [ $forceQair == "JRA55DO" ]; then
    echo "using JRA55DO forcing for Qair. Should have BLK_ZQ = 2 m, currently $blkZQ"
elif [ $forceTair == "MERRA" ]; then
    echo "using MERRA forcing for Qair. Should have BLK_ZQ = 2 m, currently $blkZQ"
elif [ $forceTair == "ERA5" ]; then
    echo "using ERA5 forcing for Qair. Should have BLK_ZQ = 2 m, currently $blkZQ"
elif [ $forceTair == "GFS" ]; then
    echo "using GFS forcing for Qair. Should have BLK_ZQ = 2 m, currently $blkZQ"
fi



if [ $forceWind == "JRA55DO" ]; then
    echo "using JRA55DO forcing for Wind. Should have BLK_ZW = 10 m, currently $blkZW"
elif [ $forceTair == "MERRA" ]; then
    echo "using MERRA forcing for Wind. Should have BLK_ZW = 2 m, currently $blkZW"
elif [ $forceTair == "ERA5" ]; then
    echo "using ERA5 forcing for Wind. Should have BLK_ZW = 10 m, currently $blkZW"
elif [ $forceTair == "GFS" ]; then
    echo "using GFS forcing for Wind. Should have BLK_ZW = 10 m, currently $blkZW"
fi



# construct experiment name and create a directory to hold it (unless the directory already exist,
# in which case exit

#echo "exptMode  $exptMode"
exptName=$gridName"/Experiments/"$gridName"_"$date"_"$exptMode$nameAppend

echo " "
echo "experiment name is" 
echo $exptName

if [ -e $exptName ]; then
        echo "you already have an experiment with this name"
        exit 1
fi




# Check the file write intervals

echo " "
dt=`grep "DT ==" $runInputFile | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
echo "dt=" $dt

nhis=`grep "NHIS ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`
nqck=`grep "NQCK ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`
ndefhis=`grep "NDEFHIS ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`
ndefqck=`grep "NDEFQCK ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`

echo "nhis="$nhis  "nqck="$nqck
echo "ndefhis="$ndefhis  "ndefqck="$ndefqck

hisSnapShot=` echo "scale=2; $dt * $nhis / 3600" | bc -l`
hisNewFile=` echo "scale=2; $dt * $ndefhis / 3600" | bc -l`
echo "hisSnapShot  = "$hisSnapShot  "hours    hisNewFile = "$hisNewFile" hours"

qckSnapShot=` echo "scale=2; $dt * $nqck / 3600" | bc -l`
qckNewFile=` echo "scale=2; $dt * $ndefqck / 3600" | bc -l`
echo "qckSnapShot = "$qckSnapShot  "hours    qckNewFile = "$qckNewFile" hours"
echo " "
echo " "



navg=`grep "NAVG ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
ndefavg=`grep "NDEFAVG ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
echo "navg="$navg  "ndefavg="$ndefavg

avgSnapShot=` echo "scale=2; $dt * $navg / 3600" | bc -l`
avgNewFile=` echo "scale=2; $dt * $ndefavg / 3600" | bc -l`
echo "avgSnapShot  = "$avgSnapShot  "hours    avgNewFile = "$avgNewFile" hours"
echo " "
echo " "



# check floats
useFloats=`grep FLOATS $compileInputFile | grep -v OFFLINE | grep -v ifdef | cut -d " " -f1`
echo "useFloats: " $useFloats
if [ $useFloats == '#define' ]; then
#        echo "use floats"
	nflt=`grep "NFLT ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
	fltSnapShot=` echo "scale=2; $dt * $nflt / 3600" | bc -l`
#	echo "nflt = $nflt"
	echo "fltSnapShot  = $fltSnapShot  hours" 

	fltName=`echo "./"$gridName"/"``grep 'FPOSNAM =' Apps/BARROW_2km/ocean_barrow.in | rev |cut -d ' ' -f1 | rev | cut -d '/' -f3-10`
	#echo $fltName
	nFloats=`grep NFLOATS $fltName | rev | cut -d ' ' -f1 |rev`
	dum=`tail -1 $fltName | tr -s ' ' | tr ' ' ','`
	#nReleases=`grep NFLOATS $fltName | rev | cut -d ' ' -f1 |rev`
	nTot=`echo $dum | cut -d ',' -f4`
	nInterval=`echo $dum | cut -d ',' -f9`
	#echo "nTot = $nTot"
	#echo "nReleases = $nReleases"
	#echo "nInterval = $nInterval"
	fltCheck=` echo "scale=2; $nTot / $nInterval" | bc -l`
	echo "There's enough floats for $fltCheck days."
fi
echo " "
echo " "



# check stations
useStations=`grep STATIONS $compileInputFile | grep -v ifdef | cut -d " " -f1`
#echo "useStations: " $useStations
if [ $useStations == '#define' ]; then
        echo "use stations"
        nsta=`grep "NSTA ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
        staSnapShot=` echo "scale=2; $dt * $nsta / 3600" | bc -l`
#	echo "nsta = $nsta"
        echo "staSnapShot  = $staSnapShot  hours"
fi



# spot check
case $interactive in
    [yY][eE][sS]|[yY])

  read -r -p "Everything OK? [Y/n] " input

  case $input in
     [nN][oO]|[nN])
  exit 1
       ;;
  esac

  ;;
esac


# create a reasonable run input file for a restart
#echo " "
#echo "restart section"
#echo " "
#
#cp $runInputFile $runRestartFile
#dum1="NRREC == 0"
#dum2="NRREC == -1"
#sed -i "s/$dum1/$dum2/" $runRestartFile
#
#dum1=`grep "FPOSNAM =" $runInputFile | grep -v '!' | rev | cut -d '/' -f1 | rev`
#dum2=`echo $dum1"_restart"`
#sed -i "s/$dum1/$dum2/" $runRestartFile
#
#dum1=`grep HISNAME $runInputFile | grep -v '!' | rev | cut -d '/' -f1 | rev | cut -d '_' -f1`
#dum2="    ININAME == ./netcdfOutput_daysXXXX/"$dum1"_rst.nc"
#
#dumN=`grep -n "ININAME =" $runInputFile | cut -d ':' -f1`
#
#echo "dum1 $dum1   dumN $dumN  dum2 $dum2"
#sed -i "$dumNs/.*/$dum2/" $runRestartFile
##sed -i "$dumNs/.*/$dum2/" $runRestartFile
#exit


## spot check
#case $interactive in
#    [yY][eE][sS]|[yY])
#
#  read -r -p "Everything OK? [Y/n] " input
#
#  case $input in
#     [nN][oO]|[nN])
#  exit 1
#       ;;
#  esac
#
#  ;;
#esac









echo " "
echo " "
echo "************************"
echo "Additional sanity checks"
echo " "




#origGridName=`echo "$gridName/InputFiles/Gridpak/$gridFileShort"`
dum=`echo $gridFile | cut -d '/' -f3-5`
origGridName=`echo "$gridName/$dum"`
echo "original Grid Name is $origGridName"

ncwa -O $origGridName gridAve.nc
pm=`ncdump gridAve.nc |grep "pm =" | cut -d " " -f4`
pn=`ncdump gridAve.nc |grep "pn =" | cut -d " " -f4`

#echo "pm = $pm    pn = $pn"

pm=`echo $pm | sed -e 's/[eE]-/ * 10^-/'`
pn=`echo $pn | sed -e 's/[eE]-/ * 10^-/'`

#echo "pm = $pm    pn = $pn"

pm=`echo " 1 * $pm " |bc -l`
pn=`echo " 1 * $pn " |bc -l`

#echo "pm = $pm    pn = $pn"

# jgp note: the above line uses "bc -l" to do floating point 
# if you leave off the -l then you get integer arithmetic


\rm gridAve.nc
deltaXi=` echo " 1 / $pm " |bc `
deltaEta=`echo " 1 / $pn " |bc `

echo "This grid has average deltaXi = $deltaXi m  and  average deltaEta = $deltaEta m"

dum=`echo " .5 * $deltaXi + .5 * $deltaEta " |bc `
#echo "ave should be $dum"

rounded=`echo " scale=1; ( $dum + .5 ) / 1000 " |bc`
echo "so I am going to call this a $rounded km grid"
echo " "
echo " "


DT=`grep "DT =="      $runInputFile | grep -v '!' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
NDTFAST=`grep "NDTFAST ==" $runInputFile | grep -v '!' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`

TNU2=`grep "TNU2 =="    $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
TNU4=`grep "TNU4 =="    $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `

VISC2=`grep "VISC2 =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2`
VISC4=`grep "VISC4 =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `

ZNUDG=`grep "ZNUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
TNUDG=`grep "TNUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
M2NUDG=`grep "M2NUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
M3NUDG=`grep "M3NUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`

#echo "TNU2 $TNU2"
#echo "TNU4 $TNU4"
#echo "VISC2 $VISC2"
#echo "VISC4 $VISC4"
#echo "ZNUDG $ZNUDG"
#echo "TNUDG $TNUDG"
#echo "M2NUDG $M2NUDG"
#echo "M3NUDG $M3NUDG"

# Calculate 'first guess' viscosity

viscCalc=`echo " ( $deltaXi + $deltaEta ) / 200 " | bc`
#echo "viscCalc $viscCalc"

echo " "
if [[ $VISC2 == $TNU2 ]];then
	echo "visc2 and tnu2 are equal, at $VISC2.  The default value should be about $viscCalc."
else
	echo "visc2 and tnu2 NOT equal, $VISC2 vs $TNU2.  The default value should be about $viscCalc."
#	exit
fi
echo " "


echo "Double check the following parameters for this grid interval in the table below:"
echo " "

echo " , , , , , , , , , " >dum.txt
echo "$rounded,$DT,$NDTFAST,$TNU2,$TNU4,$VISC2,$VISC4,$ZNUDG,$TNUDG,$M2NUDG,$M3NUDG,$gridName" >> dum.txt

cat DB.csv dum.txt | column -s, -t
\rm dum.txt





echo " ";echo " "
echo "print out the LBC"
echo " "

lbcStart=`grep -n '!   Shc        Shchepetkin (2D momentum)            i=1         i=Lm' $runInputFile | cut -d ":" -f1`
lbcStart=`echo " 2 + $lbcStart " |bc`
lbcEnd=`echo " 20 + $lbcStart " |bc` 

#echo $lbcStart $lbcEnd

sed -n $lbcStart','$lbcEnd'p' $runInputFile


#zBC=`   grep "LBC(isFsur)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
#ubarBC=`grep "LBC(isUbar)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
#vbarBC=`grep "LBC(isVbar)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
#uvelBC=`grep "LBC(isUvel)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
#vvelBC=`grep "LBC(isVvel)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
#mtkeBC=`grep "LBC(isMtke)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
#
#tempBC=`grep "! temperature" $runInputFile |grep -v salin | grep -v '!!' | grep -v '! !' | grep -v ad_ `
#saltBC=`grep "! salinity" $runInputFile |grep -v temp | grep -v '!!' | grep -v '! !' | grep -v ad_ `
#
#saltBC=`echo -e $saltBC | cut -d '\' -f 1`
#saltBC="\t  $saltBC ! \t salinity"
##echo -e $saltBC
#
#echo $zBC	        > dum.txt
#echo $ubarBC	   >> dum.txt
#echo $vbarBC       >> dum.txt
#echo $uvelBC       >> dum.txt
#echo $vvelBC       >> dum.txt
#echo $mtkeBC       >> dum.txt
#echo $tempBC       >> dum.txt
#echo -e $saltBC    >> dum.txt
#
#cat dum.txt | column -s" " -t
#\rm dum.txt


echo " ";echo " "


# spot check
case $interactive in
    [yY][eE][sS]|[yY])

  read -r -p "Everything OK? About to compile. [Y/n] " input

  case $input in
     [nN][oO]|[nN])
  exit 1
       ;;
  esac

  ;;
esac


#exit


#!!!!!!!!!!!!!!!!!!!!
# Optional README file for the experiment directory
                      
echo $exptName > README
echo "The idea here is to redo an old experiment" >>README
echo "  /archive/u1/uaf/jgpender/roms-kate_svn/TS_0.03125/ExperimentsTS_0.03125_2015_001_TidesM2_10plus5days_tidesOnly" >>README
echo "with a different bathy smoothing. The grid file has" >>README
echo "14 layers in hmax, so the point is to put a different one of these into h." >>README




#!!!!!!!!!!!!!!
# put exit here to stop before compile


#exit

#mkdir $exptName
#mkdir $exptName/Apps




#!!!!!!!!!!!!!!!!!!!!!!!!!!!
# compile ROMS and move the executable to the experiment directory


# normal compile

cp ./coawst.bash_TEMPLATE coawst.bash
# update the COAWST_APPLICATION variable
sed -i "s/XXXX/$gridName/" coawst.bash
echo ""   
echo "" 
echo ""
make -j 8   > makelogG
echo "compile"
./coawst.bash
echo "done with normal compile"

#exit

# debug compile (you have to do the regular compile first)
#  the compilation process put "G" at the end of the executable file name

sed -i "s/USE_DEBUG=  /USE_DEBUG=on/" coawst.bash
echo ""
echo ""
echo ""
make -j 8   > makelogG
echo "compile"
./coawst.bash
echo "done with debug compile"




#exit

if [ -f coawstM ] || [ -f coawstG ]; then

	mkdir $exptName
	mkdir $exptName/Apps

	mv coawstM $exptName
    mv coawstG $exptName
#	mv makelogM $exptName
#    mv makelogG $exptName
else
	echo "Compile problem, dude."
	exit
fi

echo "done with compiles"

cp  $compileInputFile 				$exptName/Apps
cp  $compileInputFile"_"$exptMode 	$exptName/Apps
cp  $runInputFile					$exptName/Apps				
cp  $runInputFile"_"$exptMode		$exptName/Apps

cp runROMS.bash $exptName/Apps



# move to the experiment directory and tidy up

cd $exptName
pwd

#echo "gridName=" $gridName
#\mv $gridName "Apps"
#mv varinfo.dat Apps

mv ../../README .

mv coawstM coawstROMSonly

#cp ~/.runROMSintel Apps/runROMSintel
#chmod gu+w Apps/runROMSintel

#cp ~/roms/ROMS .



#mv Apps/TPXOstuff .



#mv Apps/matlab .
#mv Apps/regridTools .
#mv Apps/spectralTools .

#cp $ROMSdir/addlTools/* .

#cp ../../InputFiles/Gridpak/$gridFileShort .


# create the batch script and start the job

wallTime="12:00:00"
nProc=` echo " $tileX * $tileY " | bc `



#echo "np is " $np
#echo "wallTime is " $wallTime
#echo "number of processors is "$nProc
#echo "number of nodes is " $nNodes

echo " "
echo "NOTE: this is a $runDays day run and the requested wall time is $wallTime using $nProc processors"
echo " "



    batName=$ROI".sbat"
    echo $batName


    echo "#!/bin/bash" 																					> $batName
    echo '#SBATCH --partition=t2standard'               												>>$batName
#    echo '#SBATCH --partition=t2small'              													>>$batName 
    echo '#SBATCH --ntasks='$nProc            															>>$batName
    echo '#SBATCH --mail-user=jgpender@alaska.edu'     													>>$batName
    echo '#SBATCH --mail-type=BEGIN'      																>>$batName
    echo '#SBATCH --mail-type=END'      																>>$batName
    echo '#SBATCH --mail-type=FAIL'      																>>$batName
    echo '#SBATCH --time='$wallTime      																>>$batName
    echo '#SBATCH --output=roms.%j'      																>>$batName

    echo 'source ~/.runROMSintel'                   													>>$batName

    echo 'ulimit -l unlimited'                         													>>$batName
    echo 'ulimit -s unlimited'                        													>>$batName


    echo '/bin/rm -r  netcdfOutput log '		            											>>$batName
    echo 'mkdir netcdfOutput'																			>>$batName




    echo 'NRREC=`grep NRREC Apps/ocean*.in | grep -v ! | cut -d "=" -f2 | cut -c 2`'					>>$batName
    echo 'if [ $NRREC != "0" ]; then'																	>>$batName
    echo '	lastData=`grep ININAME Apps/ocean*.in | grep -v '!' | rev | cut -d '/' -f2 | rev`'			>>$batName
    echo '	cp $lastData/*rst.nc netcdfOutput'															>>$batName
    echo '    cp $lastData/*flt.nc netcdfOutput'														>>$batName
    echo '	ROI=`find Apps -name *.in | rev | cut -d '.' -f2 | cut -d '_' -f1 |rev`'					>>$batName	
    echo '	dum="_rst.nc"'																				>>$batName
    echo '	sed -i "s/floats_$ROI.in/floats_$ROI$dum/" Apps/ocean_$ROI.in'								>>$batName		
    echo 'fi'																							>>$batName


	echo "cp `grep GRDNAME Apps/ocean*.in | grep -v '!' | cut -d '=' -f3` ."         					>>$batName


    echo "mpirun -np $nProc  coawstROMSonly ./Apps/ocean_$exptname.in > log"   							>>$batName 

    echo "bash /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/timeROMS/getRunTime.bash >> log" 	>>$batName
    echo "cp log netcdfOutput"	   																		>>$batName
    echo "cp Apps/ocean*.in  netcdfOutput"                                                          	>>$batName
#    rm nodes.*


mkdir netcdfOutput

# temp stuff
#mpirun -np 4 ./oceanM  Apps/ocean_palau.in >log &
# temp end





sbatch $batName


echo "again, the experiment name is"
echo $exptName







