
newFile='gridBrian.nc';

%unix(['cp ',oldFile,' ',newFile]);


dum.Name = 'spherical';
dum.Nctype = 'int';
% #dum.Dimension = {'Y','X'};
dum.Attribute = struct('Name',{'long_name','flag_values','flag_meanings'},'Value',{'Grid type logical switch','0, 1','Cartesian, spherical'});
nc_addvar(newFile,dum);
