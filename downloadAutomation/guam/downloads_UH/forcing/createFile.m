clear; close all



% Most of the fields have three arguments - lat, lon, and t - but a few
% also include a 4th field - height

names= {'Pair',       'Qair',     'Tair',      'Uwind',     'Vwind',       'rain',  'lwrad_down', 'swrad',     'cloud',      'albedo'};
times= {'pair_time','qair_time', 'tair_time', 'wind_time', 'wind_time', 'rain_time', 'lrf_time', 'srf_time', 'cloud_time', 'albedo_time'};
    
longNames = {'Pressure_surface', ...
        'Specific_humidity_height_above_ground', ...
        'Temperature_height_above_ground', ...
        'u-component_of_wind_height_above_ground', ...
        'v-component_of_wind_height_above_ground', ...
        'Precipitation_rate_surface', ...
        'Downward_Long-Wave_Radp_Flux_surface_6_Hour_Average', ...
        'Downward_Short-Wave_Radiation_Flux_surface_3_Hour_Average', ...
        'Total_cloud_cover_entire_atmosphere_3_Hour_Average'...
        'Albedo_surface_6_Hour_Average'};

units = {'Pa', ...
        'kg kg-1', ...
        'Celsius', ...
        'm s-1', ...
        'm s-1', ...
        'kg m-2 s-1', ...
        'W m-2', ...
        'W m-2', ...
        '1', ...
        '1'};



for ii=1:9
% for ii=1:1
    
    outFile = [char(names(ii)),'.nc']
    oldFile = [outFile,'_ORIG']
    
    lon = nc_varget(oldFile,'lon');
    lat = nc_varget(oldFile,'lat');
    time = nc_varget(oldFile,char(times(ii)));
    var = nc_varget(oldFile,char(names(ii)));
    [nt, ny, nx] = size(var);
    
    % the GFS data has latitude reversed for some reason
%     lat = flipud(lat);
%     for tt=1:nt
%         var(tt,:,:) = flipud(sq(var(tt,:,:)));
%     end;
    
    
    nc_create_empty(outFile,nc_64bit_offset_mode);
    
    % Dimension section
    nc_add_dimension(outFile,char(times(ii)),length(time));
    nc_add_dimension(outFile,'lat',length(lat));
    nc_add_dimension(outFile,'lon',length(lon));
    
    % Variables section
    
    dum.Name = 'lon';
    dum.Nctype = 'double';
    dum.Dimension = {'lon'};
    dum.Attribute = struct('Name',{'long_name','units'},'Value',{'longitude','degrees_east'});
    nc_addvar(outFile,dum);
    
    dum.Name = 'lat';
    dum.Nctype = 'double';
    dum.Dimension = {'lat'};
    dum.Attribute = struct('Name',{'long_name','units'},'Value',{'latitude','degrees_north'});
    nc_addvar(outFile,dum);
    
    dum.Name = char(times(ii));
    dum.Nctype = 'double';
    dum.Dimension = {char(times(ii))};
    dum.Attribute = struct('Name',{'long_name','units'},'Value',{char(times(ii)),'days since 1900-01-01 00:00:00'});
    nc_addvar(outFile,dum)
    
    dum.Name = char(names(ii));
    dum.Nctype = 'double';
    dum.Dimension = {char(times(ii)),'lat','lon'};
    dum.Attribute = struct('Name',{'long_name','units','coordinates'},'Value',{char(longNames(ii)),char(units(ii)),['lon lat']});
    nc_addvar(outFile,dum);
    
    % Global attributes section
    
    nc_attput(outFile,nc_global,'title', 'Surface forcing data from GFS' );
    nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
    nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );
    
    aaa=5;
    
    nc_varput(outFile,'lat',lat);
    nc_varput(outFile,'lon',lon);
    nc_varput(outFile,char(names(ii)),var);
    nc_varput(outFile,char(times(ii)),time);
    
    ['ncks ==mk_rec_dmn ',char(times(ii)),' -O ',outFile,' ',outFile]
    unix(['ncks --mk_rec_dmn ',char(times(ii)),' -O ',outFile,' ',outFile]);
      
end;

