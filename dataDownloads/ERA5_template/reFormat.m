
clear


%% lwrad_down

oldFile = '../intermediateStage/ERA5_2018_lwrad_down.nc';
newFile = 'ERA5_2018_lwrad_down.nc';
var = 'lwrad_down'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% albedo

oldFile = '../intermediateStage/ERA5_2018_albedo.nc';
newFile = 'ERA5_2018_albedo.nc';
var = 'albedo'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Pair

oldFile = '../intermediateStage/ERA5_2018_Pair.nc';
newFile = 'ERA5_2018_Pair.nc';
var = 'Pair'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

lon = nc_varget(oldFile,'lon');
for ii=1:length(lon)
    if lon(ii) > 180
        lon(ii) = lon(ii) - 360;
    end
end
nc_varput(newFile,'lon',lon');

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Qair

oldFile = '../intermediateStage/ERA5_2018_Qair.nc';
newFile = 'ERA5_2018_Qair.nc';
var = 'Qair'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% rain

oldFile = '../intermediateStage/ERA5_2018_rain.nc';
newFile = 'ERA5_2018_rain.nc';
var = 'rain'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% swrad

oldFile = '../intermediateStage/ERA5_2018_swrad.nc';
newFile = 'ERA5_2018_swrad.nc';
var = 'swrad'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Tair

oldFile = '../intermediateStage/ERA5_2018_Tair.nc';
newFile = 'ERA5_2018_Tair.nc';
var = 'Tair'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

lon = nc_varget(oldFile,'lon');
for ii=1:length(lon)
    if lon(ii) > 180
        lon(ii) = lon(ii) - 360;
    end
end
nc_varput(newFile,'lon',lon');

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Uwind

oldFile = '../intermediateStage/ERA5_2018_Uwind.nc';
newFile = 'ERA5_2018_Uwind.nc';
var = 'Uwind'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

lon = nc_varget(oldFile,'lon');
for ii=1:length(lon)
    if lon(ii) > 180
        lon(ii) = lon(ii) - 360;
    end
end
nc_varput(newFile,'lon',lon');

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Vwind

oldFile = '../intermediateStage/ERA5_2018_Vwind.nc';
newFile = 'ERA5_2018_Vwind.nc';
var = 'Vwind'

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

lon = nc_varget(oldFile,'lon');
for ii=1:length(lon)
    if lon(ii) > 180
        lon(ii) = lon(ii) - 360;
    end
end
nc_varput(newFile,'lon',lon');

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

