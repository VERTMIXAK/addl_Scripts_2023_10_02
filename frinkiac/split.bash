#!/bin/bash
source ~/.ROMSnetcdf

#\rm dum.nc


for file in ./short/r*; do
	
	Nt=`ncdump -h $file |grep UNLIMITED |cut -d "(" -f2 | cut -d " " -f1`
	echo $Nt

	for (( ii=0; ii<$Nt; ii++ ))
	do	
		echo $ii
		ncks -d ocean_time,$ii $file dum.nc


		time=`ncdump -v ocean_time dum.nc |grep "ocean_time =" | tail -1 | cut -d "=" -f2 |cut -d " " -f2`
		echo $time

		length=${#time}
	

		if (( $(bc <<< "$length == 4") )); then
                        echo "length is 4"
			name="fleat_"$time".000.nc"
		fi

                if (( $(bc <<< "$length == 6") )); then
			echo "length is 6"
                        name="fleat_"$time"00.nc"
                fi

                if (( $(bc <<< "$length == 7") )); then
                        echo "length is 7"
                        name="fleat_"$time"0.nc"
                fi

                if (( $(bc <<< "$length == 8") )); then
                        echo "length is 8"
                        name="fleat_"$time".nc"
                fi

		echo $name


		mv -n dum.nc ./temp/$name		
		\rm dum.nc
	done
	echo " "

done

