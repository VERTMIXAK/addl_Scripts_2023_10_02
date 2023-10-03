
normal=(31 28 31 30 31 30 31 31 30 31 30 31)
leap=(31 29 31 30 31 30 31 31 30 31 30 31)
myMonths=(01 02 03 04 05 06 07 08 09 10 11 12)
myDays=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)

#echo $myMonths
#echo $myDays

#uafDay=41273
#uhDay=4749
#year=2013

uafDay=36890
uhDay=366
year=2001
seconds=3187296000
unixS=978339600


# do 6 sets



for ii in `seq 1 6`;do




# do 3 regular years

for yearCount in `seq 1 3`;do
    nDay=1

    for month in `seq 0 11`;do
#	echo "`expr $month + 1 `  test ${normal[$month]}"
#	echo "month $month start "
        nDays=`expr ${normal[$month]} - 1`
        for day in `seq 0 $nDays`;do
#           echo "day $day   ${myDays[$day]}"

            printf "%s-%s-%s %8d %04d %03d %12d %12d \n" $year ${myMonths[$month]} ${myDays[$day]} $uafDay $uhDay $nDay $seconds $unixS
#           echo -e "$year-${myMonths[$month]}-${myDays[$day]}"'\t'"$uafDay"'\t'"$uhDay"'\t'"$nDay"

            uafDay=`expr $uafDay + 1`
            uhDay=`expr $uhDay + 1`
            nDay=`expr $nDay + 1`
            seconds=`expr $seconds + 86400`
            unixS=`expr $unixS + 86400`
        done
    done

    year=`expr $year + 1`

done


# do a leap year

for yearCount in `seq 1 1`;do
        nDay=1

        for month in `seq 0 11`;do
#               echo "`expr $month + 1 `  test ${normal[$month]}"
#               echo "month $month start "
                nDays=`expr ${leap[$month]} - 1`
                for day in `seq 0 $nDays`;do
#                       echo "day $day   ${myDays[$day]}"
#                        echo -e "$year-${myMonths[$month]}-${myDays[$day]}"'\t'"$uafDay"'\t'"$uhDay"'\t'"$nDay"
#                        printf "%s-%s-%s %8d %04d %03d \n" $year ${myMonths[$month]} ${myDays[$day]} $uafDay $uhDay $nDay
                        printf "%s-%s-%s %8d %04d %03d %12d %12d \n" $year ${myMonths[$month]} ${myDays[$day]} $uafDay $uhDay $nDay $seconds $unixS
                        uafDay=`expr $uafDay + 1`
                        uhDay=`expr $uhDay + 1`
                        nDay=`expr $nDay + 1`
                        seconds=`expr $seconds + 86400`
                        unixS=`expr $unixS + 86400`
                done
        done

    year=`expr $year + 1`

done




done

