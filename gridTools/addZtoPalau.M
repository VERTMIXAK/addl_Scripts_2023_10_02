clear

% Get the grid.

nameTemp=dir('../netcdf_All/*_his_*');
fileList={ nameTemp.name};subGrid.fileList=fileList;

tmp = strcat('../netcdf_All/',fileList(1));
sampleHISfile = tmp{1};subGrid.sampleHISfile=sampleHISfile;
[~,gridFile]=unix('ls .. |grep ".nc"');gridFile=strcat('../',gridFile);subGrid.gridFile=gridFile;


gridFile = a9'

ROMSgrid=roms_get_grid(gridFile,sampleHISfile,0,1);