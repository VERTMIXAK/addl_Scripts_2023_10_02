		ncatted -O -a units,river_time,o,c,"days since 1900-01-01 00:00:00" rivers.nc

	source /import/home/jgpender/.runPycnal
		python settime.py rivers.nc river_time



#   Make the river forcing file

    echo "starting river"
    cd ../Runoff
    \rm river*
    mv ../perigeeData/rivers.nc riversLO.nc
    pwd
    ls

    module purge
    module load matlab/R2013a
    matlab -nodisplay -nosplash < fixRiver.m

exit

#   The surface forcing files do need the lat/lon fields, so add them now


    cd ../perigeeData

    for ii in `seq 6 $nMax`
    do
        echo ${fileList[$ii] } ${timeList[$ii]}
        ncrename -O -d eta_rho,lat -d xi_rho,lon ${fileList[$ii]}
        ncatted -O -a  coordinates,${varList[$ii]},a,c,"lon lat" ${fileList[$ii]}
    done

    matlab -nodisplay -nosplash < addLatLon.m

    echo " "
    echo "done with all the file creation"





#	generate the IC/BC files now

	source /import/home/jgpender/.runPycnal

	cd $baseDir/InputFiles/BC_IC_HC/ini_wetDry
	echo "should be in IC directory" `pwd`
	\rm *.nc
	ls -l

	ncks -O -d ocean_time,0 $baseDir/InputFiles/perigeeData/HIS1.nc HISstart.nc
	python make_weight_files.py
	python ini.py
	echo "should see IC file"
	ls -l
	mv HISstart_*.nc 								$baseDir/Experiments/$exptName/forcing/HC_ic.nc



	cd $baseDir/InputFiles/BC_IC_HC
	echo "should be in BC directory" `pwd`
	\rm *.nc
	
	echo "start BC"
	python bryDaily1.py &
    python bryDaily2.py &
    python bryDaily3.py &
    python bryDaily4.py &
    python bryDaily5.py &

	wait
	echo "should see BC files"
	ls -l
	echo "ncrcat BC files and move to expt forcing directory"
	ncrcat -O HIS*bdry.nc 							$baseDir/Experiments/$exptName/forcing/HC_bdry.nc

	echo "end BC"




#	Move files

	echo "copy remaining forcing files to expt forcing directory"
	cp ../perigeeData/*.nc 													$baseDir/Experiments/$exptName/forcing
	cp ../Runoff/rivers.nc										$baseDir/Experiments/$exptName/forcing
	\rm ../perigeeData/scpDone.txt										


#	Run ROMS
	cd $baseDir/Experiments/$exptName

	mv HC_template.sbat "HC_$exptDate.sbat"

	source /import/home/jgpender/.runROMSintel
	sbatch --reservation=vertmix -N 6  *sbat





fi
