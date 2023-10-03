oldFile = 'UH.nc_misOrdered';
newFile = 'UH.nc';

unix(['cp ',oldFile,' ',newFile]);


oldTime = nc_varget(oldFile,'ocean_time')';

fig(1);clf;plot(oldTime)
length(oldTime)

% [oldTime(1:8) oldTime(17:end) oldTime(9:16)];
% fig(2);clf;plot(ans)

newTime = oldTime;
newTime(9:80) = oldTime(17:end);
newTime(81:end) = oldTime(9:16);
fig(3);clf;plot(newTime)
nc_varput(newFile,'ocean_time',newTime);


oldVar = nc_varget(oldFile,'zeta');
newVar = oldVar;
newVar(9:80,:,:) = oldVar(17:end,:,:);
newVar(81:end,:,:) = oldVar(9:16,:,:);
nc_varput(newFile,'zeta',newVar);

oldVar = nc_varget(oldFile,'ubar');
newVar = oldVar;
newVar(9:80,:,:) = oldVar(17:end,:,:);
newVar(81:end,:,:) = oldVar(9:16,:,:);
nc_varput(newFile,'ubar',newVar);

oldVar = nc_varget(oldFile,'vbar');
newVar = oldVar;
newVar(9:80,:,:) = oldVar(17:end,:,:);
newVar(81:end,:,:) = oldVar(9:16,:,:);
nc_varput(newFile,'vbar',newVar);

%


oldVar = nc_varget(oldFile,'salt');
newVar = oldVar;
newVar(9:80,:,:,:) = oldVar(17:end,:,:,:);
newVar(81:end,:,:,:) = oldVar(9:16,:,:,:);
nc_varput(newFile,'salt',newVar);

oldVar = nc_varget(oldFile,'temp');
newVar = oldVar;
newVar(9:80,:,:,:) = oldVar(17:end,:,:,:);
newVar(81:end,:,:,:) = oldVar(9:16,:,:,:);
nc_varput(newFile,'temp',newVar);

oldVar = nc_varget(oldFile,'u');
newVar = oldVar;
newVar(9:80,:,:,:) = oldVar(17:end,:,:,:);
newVar(81:end,:,:,:) = oldVar(9:16,:,:,:);
nc_varput(newFile,'u',newVar);

oldVar = nc_varget(oldFile,'v');
newVar = oldVar;
newVar(9:80,:,:,:) = oldVar(17:end,:,:,:);
newVar(81:end,:,:,:) = oldVar(9:16,:,:,:);
nc_varput(newFile,'v',newVar);
