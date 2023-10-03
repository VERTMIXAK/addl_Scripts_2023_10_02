oldFile="gridBrian.nc_ORIG"
newFile="gridBrian.nc"


eta_psi=`ncdump -h $oldFile | grep 'eta_psi =' | cut -d ' ' -f3`
eta_u=`ncdump -h $oldFile | grep 'eta_u =' | cut -d ' ' -f3`
eta_v=`ncdump -h $oldFile | grep 'eta_v =' | cut -d ' ' -f3`

xi_psi=`ncdump -h $oldFile | grep 'xi_psi =' | cut -d ' ' -f3`
xi_u=`ncdump -h $oldFile | grep 'xi_u =' | cut -d ' ' -f3`
xi_v=`ncdump -h $oldFile | grep 'xi_v =' | cut -d ' ' -f3`

eta_psiM1=`echo "$eta_psi - 1" | bc`
eta_uM1=`echo "$eta_u - 1" | bc`
eta_vM1=`echo "$eta_v - 1" | bc`
xi_psiM1=`echo "$xi_psi - 1" | bc`
xi_uM1=`echo "$xi_u - 1" | bc`
xi_vM1=`echo "$xi_v - 1" | bc`

eta_psiM2=`echo "$eta_psi - 2" | bc`
eta_uM2=`echo "$eta_u - 2" | bc`
eta_vM2=`echo "$eta_v - 2" | bc`
xi_psiM2=`echo "$xi_psi - 2" | bc`
xi_uM2=`echo "$xi_u - 2" | bc`
xi_vM2=`echo "$xi_v - 2" | bc`

echo "eta_psi $eta_psi   xi_psi $xi_psi"
echo "eta_u   $eta_u   xi_u   $xi_u"
echo "eta_v   $eta_v   xi_v   $xi_v"

ncks -O -d eta_psi,0,$eta_psiM2 -d xi_psi,1,$xi_psiM1 -d xi_u,1,$xi_uM1 -d eta_v,0,$eta_vM2 $oldFile $newFile
