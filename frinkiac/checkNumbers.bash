start=`ls -1 singleSnapshots/ | head -n1  | rev | cut -d '.' -f3 | cut -c 2-3 |rev`
end=`  ls -1 singleSnapshots/ | tail -n1  | rev | cut -d '.' -f3 | cut -c 2-3 |rev`

#echo $start '  ' $end

first="singleSnapshots/fleat_5"
last='*.nc'

for i in $(seq $start $end)
do
	echo "fleat_5$i"
	echo $first$i$last | wc -w
done
