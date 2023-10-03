oldFile = 'SCSAtelescope_4km_full8.nc';
newFile = 'SCSAtelescope_4km_M2S2K1O1.nc';

unix(['cp ',oldFile,' ',newFile]);

dum = nc_varget(newFile,'tide_name')
[nNames,~] = size(dum)

keepN = [6, 7, 4, 2];   % M2, S2, K1, O1
dum(keepN,:)


dum = nc_varget(newFile,'tide_Eamp');
for nn=1:nNames
    if ~ismember(nn, keepN)
        dum(nn,:,:) = 0;
end;end
nc_varput(newFile,'tide_Eamp',dum);

dum = nc_varget(newFile,'tide_Cmax');
for nn=1:nNames
    if ~ismember(nn, keepN)
        dum(nn,:,:) = 0;
end;end
nc_varput(newFile,'tide_Cmax',dum);

dum = nc_varget(newFile,'tide_Cmin');
for nn=1:nNames
    if ~ismember(nn, keepN)
        dum(nn,:,:) = 0;
end;end
nc_varput(newFile,'tide_Cmin',dum);
