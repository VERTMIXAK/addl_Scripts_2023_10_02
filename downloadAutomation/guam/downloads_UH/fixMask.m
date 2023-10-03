oldGridFile = 'gridBin_defunct/gridBrian.nc_ORIG2';
gridFile    = 'gridBin_defunct/gridBrian.nc';

oldNowFile  = 'now.nc_ORIG2';
nowFile     = 'UH.nc';

% unix(['cp ',oldGridFile,' ',gridFile]);
% unix(['cp ',oldNowFile, ' ',nowFile]);


%% zeta

zeta = nc_varget(nowFile,'zeta');
fig(1);clf;pcolor(sq(zeta(10,:,:)));shading flat

[nt ny nx] = size(zeta);
for ii=1:nx;for jj=1:ny
    if isnan(zeta(1,jj,ii)) 
%        [jj,ii]
        for tt=1:nt
            zeta(tt,jj-1:jj+1,ii-1:ii+1);
            zeta(tt,jj,ii) = nanmean(ans(:));
        end
    end
    end;end

fig(2);clf;pcolor(sq(zeta(10,:,:)));shading flat
nc_varput(nowFile,'zeta',zeta);
        
        
%% ubar

ubar = nc_varget(nowFile,'ubar');
fig(1);clf;pcolor(sq(ubar(10,:,:)));shading flat

[nt ny nx] = size(ubar);
for ii=1:nx;for jj=1:ny
    if isnan(ubar(1,jj,ii)) 
%        [jj,ii]
        for tt=1:nt
            ubar(tt,jj-1:jj+1,ii-1:ii+1);
            ubar(tt,jj,ii) = nanmean(ans(:));
        end
    end
    end;end

fig(2);clf;pcolor(sq(ubar(10,:,:)));shading flat
nc_varput(nowFile,'ubar',ubar);
    
        
%% vbar

vbar = nc_varget(nowFile,'vbar');
fig(1);clf;pcolor(sq(vbar(10,:,:)));shading flat

[nt ny nx] = size(vbar);
for ii=1:nx;for jj=1:ny
    if isnan(vbar(1,jj,ii)) 
%       [jj,ii]
        for tt=1:nt
            vbar(tt,jj-1:jj+1,ii-1:ii+1);
            vbar(tt,jj,ii) = nanmean(ans(:));
        end
    end
    end;end

fig(2);clf;pcolor(sq(vbar(10,:,:)));shading flat
nc_varput(nowFile,'vbar',vbar);
        
%% v

v = nc_varget(nowFile,'v');
fig(1);clf;pcolor(sq(v(10,end,:,:)));shading flat

[nt nz ny nx] = size(v);
for ii=1:nx;for jj=1:ny;for kk=1:nz
    if isnan(v(1,kk,jj,ii)) 
%         [jj,ii]
        for tt=1:nt
            v(tt,kk,jj-1:jj+1,ii-1:ii+1);
            v(tt,kk,jj,ii) = nanmean(ans(:));
        end
    end
    end;end;end

fig(2);clf;pcolor(sq(v(10,end,:,:)));shading flat
nc_varput(nowFile,'v',v);
        
%% u

u = nc_varget(nowFile,'u');
fig(1);clf;pcolor(sq(u(10,end,:,:)));shading flat

[nt nz ny nx] = size(u);
for ii=1:nx;for jj=1:ny;for kk=1:nz
    if isnan(u(1,kk,jj,ii)) 
%         [jj,ii]
        for tt=1:nt
            u(tt,kk,jj-1:jj+1,ii-1:ii+1);
            u(tt,kk,jj,ii) = nanmean(ans(:));
        end
    end
    end;end;end

fig(2);clf;pcolor(sq(u(10,end,:,:)));shading flat
nc_varput(nowFile,'u',u);
        

%% temp

temp = nc_varget(nowFile,'temp');
fig(1);clf;pcolor(sq(temp(10,end,:,:)));shading flat

[nt nz ny nx] = size(temp);
for ii=1:nx;for jj=1:ny;for kk=1:nz
    if isnan(temp(1,kk,jj,ii)) 
%         [jj,ii]
        for tt=1:nt
            temp(tt,kk,jj-1:jj+1,ii-1:ii+1);
            temp(tt,kk,jj,ii) = nanmean(ans(:));
        end
    end
    end;end;end

fig(2);clf;pcolor(sq(temp(10,end,:,:)));shading flat
nc_varput(nowFile,'temp',temp);
        

%% salt

salt = nc_varget(nowFile,'salt');
fig(1);clf;pcolor(sq(salt(10,end,:,:)));shading flat

[nt nz ny nx] = size(salt);
for ii=1:nx;for jj=1:ny;for kk=1:nz
    if isnan(salt(1,kk,jj,ii)) 
%         [jj,ii]
        for tt=1:nt
            salt(tt,kk,jj-1:jj+1,ii-1:ii+1);
            salt(tt,kk,jj,ii) = nanmean(ans(:));
        end
    end
    end;end;end

fig(2);clf;pcolor(sq(salt(10,end,:,:)));shading flat
nc_varput(nowFile,'salt',salt);
        

%% masks

mask = nc_varget(gridFile,'mask_rho');
fig(1);clf;pcolor(mask);shading flat
mask(mask==0) = 1;
fig(2);clf;pcolor(mask);shading flat
nc_varput(gridFile,'mask_rho',mask);

mask = nc_varget(gridFile,'mask_psi');
fig(1);clf;pcolor(mask);shading flat
mask(mask==0) = 1;
fig(2);clf;pcolor(mask);shading flat
nc_varput(gridFile,'mask_psi',mask);

mask = nc_varget(gridFile,'mask_u');
fig(1);clf;pcolor(mask);shading flat
mask(mask==0) = 1;
fig(2);clf;pcolor(mask);shading flat
nc_varput(gridFile,'mask_u',mask);

mask = nc_varget(gridFile,'mask_v');
fig(1);clf;pcolor(mask);shading flat
mask(mask==0) = 1;
fig(2);clf;pcolor(mask);shading flat
nc_varput(gridFile,'mask_v',mask);


