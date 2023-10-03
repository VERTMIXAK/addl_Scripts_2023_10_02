	echo "begin tidyUp.bash"

	source /import/home/jgpender/.runROMSintel


# there are 11 files but the counting begins at zero
    
	nMax=10 
	fileList=( "HC_2021_356_ic.nc" "HC_2021_bdry.nc" "rivers.nc" "lwrad_down.nc" "Pair.nc" "Qair.nc" "rain.nc" "swrad.nc" "Tair.nc" "Uwind.nc" "Vwind.nc" )
	varList=(         "dum"             "dum"         "dum"       "lwrad_down"    "Pair"    "Qair"    "rain"    "swrad"    "Tair"    "Uwind"    "Vwind" )
	timeList=( "ocean_time" "ocean_time" "river_time" "lrf_time" "pair_time" "qair_time" "rain_time" "srf_time" "tair_time"  "wind_time" "wind_time")



# convert the timestamps to days since 1900
	
	for ii in `seq 0 $nMax`
	do
		echo ${fileList[$ii] } ${timeList[$ii]}
		ncatted -O -a units,${timeList[$ii]},o,c,"days since 1900-01-01 00:00:00" ${fileList[$ii]}
	done

	source /import/home/jgpender/.runPycnal
    for ii in `seq 0 $nMax`
    do
        echo ${fileList[$ii] } ${timeList[$ii]}
		python settime.py ${fileList[$ii] } ${timeList[$ii]}
    done




#	Make the river forcing file

	echo "starting river"
	cd ../Runoff
	\rm river*
	mv ../perigeeBulkData/rivers.nc riversLO.nc
	pwd
	ls
    module purge
    module load matlab/R2013a
	matlab -nodisplay -nosplash < fixRiver.m


#   The surface forcing files do need the lat/lon fields, so add them now


    cd ../perigeeBulkData

    for ii in `seq 3 $nMax`
    do
      	echo ${fileList[$ii] } ${timeList[$ii]}
        ncrename -O -d eta_rho,lat -d xi_rho,lon ${fileList[$ii]}
        ncatted -O -a  coordinates,${varList[$ii]},a,c,"lon lat" ${fileList[$ii]}
    done


    matlab -nodisplay -nosplash < addLatLon.m

	echo " "
	echo "done with all the file creation"

exit


#	Move files


	mv *.nc 													$baseDir/Experiments/$exptName/forcing
	mv ../Runoff/rivers.nc										$baseDir/Experiments/$exptName/forcing
	mv ../BC_IC_HC/ini_wetDry/HISstart_HC_100mMEWetDry.nc 		$baseDir/Experiments/$exptName/forcing/HC_ic.nc
    mv ../BC_IC_HC/HIS?.nc                                      $baseDir/Experiments/$exptName/forcing/

    ncrcat -O ../BC_IC_HC/HIS*bdry.nc  							$baseDir/Experiments/$exptName/forcing/HC_bdry.nc
	mv scpDone.txt												$baseDir/Experiments/$exptName/forcing			


#	Run ROMS
	cd $baseDir/Experiments/$exptName

	mv HC_template.sbat "HC_$exptDate.sbat"

	source /import/home/jgpender/.runROMSintel
	sbatch *sbat




