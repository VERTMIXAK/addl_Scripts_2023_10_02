clear

[~,year] = unix(['pwd | rev | cut -d ''/'' -f2 | rev | cut -d ''_'' -f2']);
year=year(1:end-1)


%% lwrad_down


var = 'lwrad_down'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% albedo

var = 'albedo'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Pair

var = 'Pair'

oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

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

var = 'Qair'

oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% rain

var = 'rain'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% swrad

var = 'swrad'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

unix(['cp ',oldFile,' ',newFile]);

lat = nc_varget(oldFile,'lat');
field = nc_varget(oldFile,var);

field = flipdim(field,2);
lat = flipud(lat);

nc_varput(newFile,'lat',lat');
nc_varput(newFile,var,field);

%% Tair


var = 'Tair'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

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


var = 'Uwind'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

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

var = 'Vwind'
oldFile = ['../intermediateStage/ERA5_',year,'_',var,'.nc']
newFile = ['ERA5_',year,'_',var,'.nc']

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

