#!/bin/csh   

set nonomatch

	foreach fileList(`\ls ../netcdf_All |grep _his2_ `)
#		ncdump -h ../netcdf_All/$fileList
		ncks -d xi_psi,886,982 -d xi_rho,886,983 -d xi_u,886,982 -d xi_v,886,983 -d eta_psi,217,313 -d eta_rho,217,314 -d eta_u,217,314 -d eta_v,217,313 ../netcdf_All/$fileList $fileList		
	end

	foreach fileList(`\ls ../netcdf_All |grep _his_ `)
#               ncdump -h ../netcdf_All/$fileList
                ncks -d xi_psi,886,982 -d xi_rho,886,983 -d xi_u,886,982 -d xi_v,886,983 -d eta_psi,217,313 -d eta_rho,217,314 -d eta_u,217,314 -d eta_v,217,313 ../netcdf_All/$fileList $fileList
        end

	foreach fileList(`\ls ../netcdf_All |grep _avg_ `)
#               ncdump -h ../netcdf_All/$fileList
                ncks -d xi_psi,886,982 -d xi_rho,886,983 -d xi_u,886,982 -d xi_v,886,983 -d eta_psi,217,313 -d eta_rho,217,314 -d eta_u,217,314 -d eta_v,217,313 ../netcdf_All/$fileList $fileList
        end


set gridFile = `ls .. |grep .nc`
ncks -d xi_psi,886,982 -d xi_rho,886,983 -d xi_u,886,982 -d xi_v,886,983 -d eta_psi,217,313 -d eta_rho,217,314 -d eta_u,217,314 -d eta_v,217,313 ../$gridFile $gridFile
  
