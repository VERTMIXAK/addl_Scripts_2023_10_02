source ~/.runROMSintel

\rm -r M2T1NXINT
cp -R ../MERRA_getData_template/M2T1NXINT .


\rm -r M2T1NXALB
cp -R ../MERRA_getData_template/M2T1NXALB .



\rm -r M2T1NXRAD
cp -R ../MERRA_getData_template/M2T1NXRAD .


\rm -r M2T1NXSLV
cp -R ../MERRA_getData_template/M2T1NXSLV .


year=`head -2 subset_INT_1.txt | tail -1 | grep -Eo [0-9]{8} | cut -c 1-4`

echo $year
sed -i "s/YYYY/$year/" M2*/*.py
sed -i "s/YYYY/$year/" M2*/*.m
sed -i "s/YYYY/$year/" M2*/*.bash



exit


cd M2T1NXALB
bash batch*.bash

cd ../M2T1NXINT
bash batch*.bash

cd ../M2T1NXRAD 
bash batch*.bash

cd ../M2T1NXSLV
bash batch*.bash

