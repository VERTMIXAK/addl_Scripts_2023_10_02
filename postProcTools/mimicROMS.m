clear

% Load in spectral transform vectors
load ../spectralTools/MODEL

% Load in grid

[~,gridFile]=unix('ls .. |grep ".nc"');gridFile=strcat('../',gridFile);subGrid.gridFile=gridFile;
bathy=nc_varget(gridFile,'h');


% Load in some ROMS output

nameTemp=dir('../netcdf_All/*_his_*');
fileList={ nameTemp.name};subGrid.fileList=fileList;

tmp = strcat('../netcdf_All/',fileList(end));
sampleHISfile = tmp{1};subGrid.sampleHISfile=sampleHISfile;


zeta = nc_varget(sampleHISfile,'zeta');
u = nc_varget(sampleHISfile,'u');

[Nz Ny Nx] = size(u);

nmodes=10;
uSpec  =  zeros([ Ny Nx  nmodes ]);

%% Find the spectral coefficients





tic
for ii=1:Nx; for jj=1:Ny
% for ii=50:50; for jj=50:50
        for kk=1:MODEL.nH-1
%             [kk bathy(jj,ii) MODEL.H(kk)]
            totalHeight = bathy(jj,ii) + zeta(jj,ii);
            if bathy(jj,ii) > MODEL.H(kk) & bathy(jj,ii) < MODEL.H(kk+1)  
%                 [MODEL.H(kk)   bathy(jj,ii)  MODEL.H(kk+1)]
                dum1=(MODEL.H(kk+1)-bathy(jj,ii))/(MODEL.H(kk+1)-MODEL.H(kk)) * squeeze(MODEL.vXfm(kk,:,:));
                dum2=(bathy(jj,ii)-MODEL.H(kk))/(MODEL.H(kk+1)-MODEL.H(kk))   * squeeze(MODEL.vXfm(kk+1,:,:));               
                (dum1+dum2)'*u(:,jj,ii);
                uSpec(jj,ii,:)=ans(1:nmodes); 
            end
        end;
    end;end
toc
