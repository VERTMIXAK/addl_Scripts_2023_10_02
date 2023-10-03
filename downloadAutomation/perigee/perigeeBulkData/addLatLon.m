% These forcing files are on the same exact grid as the experiment, which
% means they are not on the same grid as my experiment. This would be fine
% if these files had lat and lon fields but they do not. The point of this
% script is to add the lat and lon fields from my subset of the LiveOcean
% grid.

gridFile = '../cas6_v3_lo8b_HIS_2021/PS_UW_grid.nc';



latGrid = nc_varget(gridFile,'lat_rho'); latGrid = latGrid(:,1);
lonGrid = nc_varget(gridFile,'lon_rho'); lonGrid = lonGrid(1,:); lonGrid = lonGrid + 360;



% new variables
dum.Name = 'lon';
dum.Nctype = 'double';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units'},'Value',{'Longitude','degrees_east'});

nc_addvar(['lwrad_down.nc'],dum);
nc_addvar(['Pair.nc'],dum);
nc_addvar(['Qair.nc'],dum);
nc_addvar(['rain.nc'],dum);
nc_addvar(['swrad.nc'],dum);
nc_addvar(['Tair.nc'],dum);
nc_addvar(['Uwind.nc'],dum);
nc_addvar(['Vwind.nc'],dum);



dum.Name = 'lat';
dum.Nctype = 'double';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units'},'Value',{'Latitude','degrees_north'});

nc_addvar(['lwrad_down.nc'],dum);
nc_addvar(['Pair.nc'],dum);
nc_addvar(['Qair.nc'],dum);
nc_addvar(['rain.nc'],dum);
nc_addvar(['swrad.nc'],dum);
nc_addvar(['Tair.nc'],dum);
nc_addvar(['Uwind.nc'],dum);
nc_addvar(['Vwind.nc'],dum);


nc_varput(['lwrad_down.nc'],'lon',lonGrid);
nc_varput(['lwrad_down.nc'],'lat',latGrid);

nc_varput(['Pair.nc'],'lon',lonGrid);
nc_varput(['Pair.nc'],'lat',latGrid);

nc_varput(['Qair.nc'],'lon',lonGrid);
nc_varput(['Qair.nc'],'lat',latGrid);

nc_varput(['rain.nc'],'lon',lonGrid);
nc_varput(['rain.nc'],'lat',latGrid);

nc_varput(['swrad.nc'],'lon',lonGrid);
nc_varput(['swrad.nc'],'lat',latGrid);

nc_varput(['Tair.nc'],'lon',lonGrid);
nc_varput(['Tair.nc'],'lat',latGrid);

nc_varput(['Uwind.nc'],'lon',lonGrid);
nc_varput(['Uwind.nc'],'lat',latGrid);

nc_varput(['Vwind.nc'],'lon',lonGrid);
nc_varput(['Vwind.nc'],'lat',latGrid);










