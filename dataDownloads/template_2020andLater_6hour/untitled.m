    outFile = 'out.nc';

    dum.Name = 'thetao';
    dum.Nctype = 'short';
    dum.Dimension = {'time','depth','latitude','longitude'};
    dum.Attribute = struct('Name',{'long_name','units','_FillValue','add_offset','scale_factor'},'Value',{'Temperature','degrees_C',-32767,21.,0.000732444226741791});
    nc_addvar(dataFile,dum);
    
    nc_varput(dataFile,'lon',newLon);
