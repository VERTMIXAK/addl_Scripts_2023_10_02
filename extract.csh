ncrcat -v temp     ../netcdf_All/palau_his2_* temp.nc
ncrcat -v latent   ../netcdf_All/palau_his2_* latent.nc
ncrcat -v lwrad    ../netcdf_All/palau_his2_* lwrad.nc
ncrcat -v sensible ../netcdf_All/palau_his2_* sensible.nc
ncrcat -v shflux   ../netcdf_All/palau_his2_* shflux.nc
ncrcat -v swrad    ../netcdf_All/palau_his2_* swrad.nc
ncrcat -v Uwind    ../netcdf_All/palau_his2_* uwind.nc
ncrcat -v Vwind    ../netcdf_All/palau_his2_* vwind.nc
ncrcat -v ssflux   ../netcdf_All/palau_his2_* ssflux.nc
ncrcat -v salt     ../netcdf_All/palau_his2_* salt.nc
ncrcat -v sustr    ../netcdf_All/palau_his2_* sustr.nc
ncrcat -v svstr    ../netcdf_All/palau_his2_* svstr.nc

ncks -v mask_rho,mask_u,mask_v ../PALAU_0.0083.nc masks.nc
