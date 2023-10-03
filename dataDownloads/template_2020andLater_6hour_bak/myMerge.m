outFile = 'out.nc';

dum.Name = 'thetao';
dum.Nctype = 'short';
dum.Dimension = {'time','depth','latitude','longitude'};
dum.Attribute = struct('Name',{'long_name','units','_FillValue','add_offset','scale_factor'},'Value',{'Temperature','degrees_C',-32767,21.,0.000732444226741791});
nc_addvar(outFile,dum);

dum = nc_varget('T.nc','thetao');
nc_varput('out.nc','thetao',dum);


dum.Name = 'so';
dum.Nctype = 'short';
dum.Dimension = {'time','depth','latitude','longitude'};
dum.Attribute = struct('Name',{'long_name','units','_FillValue','add_offset','scale_factor'},'Value',{'Salinity','1e-3',-32767,-0.00152592547237873,0.00152592547237873});
nc_addvar(outFile,dum);

dum = nc_varget('S.nc','so');
nc_varput('out.nc','so',dum);



dum.Name = 'zos';
dum.Nctype = 'short';
dum.Dimension = {'time','latitude','longitude'};
dum.Attribute = struct('Name',{'long_name','units','_FillValue','add_offset','scale_factor'},'Value',{'Sea surface height','m',-32767,0.,0.000305185094475746});
nc_addvar(outFile,dum);

myZ = nc_varget('Z.nc','zos');
tZ  = nc_varget('Z.nc','time');
tOthers = nc_varget('T.nc','time');

dum = nc_varget('S.nc','so');
dum = sq(dum(:,1,:,:));
[nt,ny,nx] = size(dum);

for jj=1:ny; for ii=1:nx
%     jj
	dum(:,jj,ii) = interp1(tZ,myZ(:,jj,ii),tOthers);
end;end;

nc_varput('out.nc','zos',dum);






