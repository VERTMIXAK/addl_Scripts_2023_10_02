year = 2022;

% Most of the fields have three arguments - lat, lon, and t - but a few
% also include a 4th field - height

names3 = {'Pair',  'rain', 'lwrad_down', 'swrad', 'cloud', 'albedo'};
times3 = {'pair_time', 'rain_time', 'lrf_time', 'srf_time', 'cloud_time', 'albedo_time'};

names4 = {'Qair', 'Tair', 'Uwind', 'Vwind'};
times4 = {'qair_time', 'tair_time', 'wind_time', 'wind_time'};

long3  = {'Pressure at 2m','rain at surface','downward longwave radiation at surface','downward shortwave radiation at surface','total cloud cover','albedo at ground'};
long4  = {'Specific Humidity at 2m','Temperature at 2m','u component of wind at 10m','v component of wind at 10m'};

units3 = {'Pa','kg m-2 s-1','W m-2','W m-2','%','%'};
units4 = {'kg/kg','C','m/s','m/s'};



%% height-dependent fields

for ii=1:4
    timeVar  = char(times4(ii));
    nameVar  = char(names4(ii));
    longName = char(long4(ii));
    units    = char(units4(ii));
    
    newFile = ['GFS_',nameVar,'_',num2str(year),'.nc']
    oldFile = [newFile,'_ORIG'];
    
    lon = nc_varget(oldFile,'lon');
    lat = nc_varget(oldFile,'lat');
    time = nc_varget(oldFile,timeVar);
    var = nc_varget(oldFile,nameVar);
    
    var = sq(var(:,1,:,:));
    [nt, ny, nx] = size(var);
    
    % lat is flipped in the original downloads for some reason
    lat = flipud(lat);
    for tt=1:nt
        var(tt,:,:) = flipud(sq(var(tt,:,:)));
    end;
    
    nc_create_empty(newFile,nc_64bit_offset_mode);
    
    % Dimension section
    nc_add_dimension(newFile,'lon',length(lon));
    nc_add_dimension(newFile,'lat',length(lat));
    nc_add_dimension(newFile,timeVar,0);
    
    % Variables section
    
    dum.Name = 'lon';
    dum.Nctype = 'float';
    dum.Dimension = {'lon'};
    dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
    nc_addvar(newFile,dum);
    
    dum.Name = 'lat';
    dum.Nctype = 'float';
    dum.Dimension = {'lat'};
    dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
    nc_addvar(newFile,dum);
    
    dum.Name = timeVar;
    dum.Nctype = 'float';
    dum.Dimension = {timeVar};
    dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
    nc_addvar(newFile,dum)
    
    dum.Name = nameVar;
    dum.Nctype = 'float';
    dum.Dimension = {timeVar,'lat','lon'};
    dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{longName,units,timeVar,['lon lat ',timeVar],'placeholder, scalar, series'});
    nc_addvar(newFile,dum);
    
    
    
    
    nc_varput(newFile,'lat',lat);
    nc_varput(newFile,nameVar,var);
    nc_varput(newFile,timeVar,time);
    
end;



%% height-independent fields

for ii=1:5
    timeVar  = char(times3(ii));
    nameVar  = char(names3(ii));
    longName = char(long3(ii));
    units    = char(units3(ii));
    
    newFile = ['GFS_',nameVar,'_',num2str(year),'.nc']
    oldFile = [newFile,'_ORIG'];
    
    lon = nc_varget(oldFile,'lon');
    lat = nc_varget(oldFile,'lat');
    time = nc_varget(oldFile,timeVar);
    var = nc_varget(oldFile,nameVar);
    
    var = sq(var(:,:,:));
    [nt, ny, nx] = size(var);
    
    % lat is flipped in the original downloads for some reason
    lat = flipud(lat);
    for tt=1:nt
        var(tt,:,:) = flipud(sq(var(tt,:,:)));
    end;
    
    nc_create_empty(newFile,nc_64bit_offset_mode);
    
    % Dimension section
    nc_add_dimension(newFile,'lon',length(lon));
    nc_add_dimension(newFile,'lat',length(lat));
    nc_add_dimension(newFile,timeVar,0);
    
    % Variables section
    
    dum.Name = 'lon';
    dum.Nctype = 'float';
    dum.Dimension = {'lon'};
    dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
    nc_addvar(newFile,dum);
    
    dum.Name = 'lat';
    dum.Nctype = 'float';
    dum.Dimension = {'lat'};
    dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
    nc_addvar(newFile,dum);
    
    dum.Name = timeVar;
    dum.Nctype = 'float';
    dum.Dimension = {timeVar};
    dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
    nc_addvar(newFile,dum)
    
    dum.Name = nameVar;
    dum.Nctype = 'float';
    dum.Dimension = {timeVar,'lat','lon'};
    dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{longName,units,timeVar,['lon lat ',timeVar],'placeholder, scalar, series'});
    nc_addvar(newFile,dum);
    
    
    
    
    nc_varput(newFile,'lat',lat);
    nc_varput(newFile,nameVar,var);
    nc_varput(newFile,timeVar,time);
    
end;

