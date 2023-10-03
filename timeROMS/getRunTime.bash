echo " "
echo " "
echo " "
echo " "


runSeconds=`grep 'total time =' log* | head -1 | rev | cut -d ' ' -f1 |rev`

echo "run time (cpu sec) = " $runSeconds
runHours=`echo "scale=4; $runSeconds / 3600" | bc`
echo "run time (cpu hrs) = " $runHours

dum=`grep "Tile partition information" log* | rev | cut -d ":" -f1 | rev | head -n1`
echo "dum  " $dum

Ni=`echo $dum | cut -d 'x' -f1 `
Nj=`echo $dum | cut -d 'x' -f2 `

echo "ni,nj = $Ni, $Nj"

Ntiles=`echo "$Ni * $Nj" |bc`
echo "Ntiles = $Ntiles"

clockTime=`echo " scale=4; $runHours / $Ntiles" | bc -l`


# Get number of model days
#nModelDays=`ls -1 netcdfOutput/*his2* | wc -l `

dt=`grep dt log* | head -1 | tr -s ' ' | tr ' ' ',' | cut -d ',' -f2 | cut -d '.' -f1`
nTimes=`grep ntimes log* | head -1 | tr -s ' ' | tr ' ' ',' | cut -d ',' -f2`
nModelDays=`echo "$nTimes * $dt / 86400" | bc`
echo "dt="$dt" nTimes="$nTimes" nModelDays="$nModelDays 
echo "number of model days = " $nModelDays



hoursPerDay=`echo " scale=4; $clockTime / $nModelDays" | bc -l`

cpuHoursPerDay=`echo " scale=4; $hoursPerDay *  $Ntiles" | bc -l`


echo "The model ran for $runHours cpu hours using $Ntiles tiles, for a total of $clockTime wall hours"
echo "which works out to $hoursPerDay hours per model day"
echo "or $cpuHoursPerDay cpu hours per model day."

echo " "
echo " "

#nsteps=`grep ntimes log*   | tr -s ' ' | tr ' ' ',' | cut -d ',' -f2`
#echo "nsteps $nsteps"
#
#secPerStep=`echo " scale=4; $runSeconds / $nsteps / $Ntiles" | bc -l`
#
#echo "ran at $secPerStep  seconds per time step"	

