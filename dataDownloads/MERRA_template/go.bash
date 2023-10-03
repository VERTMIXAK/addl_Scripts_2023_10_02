source ~/.runROMSintel

#\rm -r M2T1NXINT
#cp -R ../MERRA_getData_template/M2T1NXINT .

#\rm -r M2T1NXALB
#cp -R ../MERRA_getData_template/M2T1NXALB .

#\rm -r M2T1NXRAD
#cp -R ../MERRA_getData_template/M2T1NXRAD .

#\rm -r M2T1NXSLV
#cp -R ../MERRA_getData_template/M2T1NXSLV .



cd M2T1NXALB
bash batch*.bash

cd ../M2T1NXINT
bash batch*.bash

cd ../M2T1NXRAD 
bash batch*.bash

cd ../M2T1NXSLV
bash batch*.bash

