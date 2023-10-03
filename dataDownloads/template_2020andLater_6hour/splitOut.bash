mkdir dataSplit
for file in `ls data_PHY`
do
	root=`echo $file | cut -d '.' -f1`
	echo $file $root

	for ii in `seq 0 3`
	do
		outName=$root"_"$ii".nc"
		echo $outName

		ncks -d ocean_time,$ii data_PHY/$file dataSplit/$outName
	done

done
