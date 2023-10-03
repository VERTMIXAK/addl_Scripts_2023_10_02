#source ~/.runROMSintel

dir='originals/'


source ~/.runPycnal

# First change the numeric value of ocean_time from seconds to days
for file in `ls $dir`
do
	echo $file
        python settime.py $dir$file
done




# then change the ocean_time units for all the fleat files
for file in `ls $dir`
do
 	echo $file
 	ncatted -O -a units,ocean_time,o,c,"days since 2000-01-01 00:00:00" $dir$file $dir$file

done
