gridFile = 'NISKINE_2km.nc';

mask_rho = nc_varget(gridFile,'mask_rho');
mask_psi = nc_varget(gridFile,'mask_psi');
mask_u   = nc_varget(gridFile,'mask_u');
mask_v   = nc_varget(gridFile,'mask_v');



%%


% fig(1);clf;pcolor(mask_psi(830:end,1:250));shading flat;colorbar
% fig(2);clf;pcolor(mask_psi);shading flat;colorbar
mask_rho(830:end,1:250) = 0;
mask_psi(830:end,1:250) = 0;
mask_u(830:end,1:250)   = 0;
mask_v(830:end,1:250)   = 0;
% fig(3);clf;pcolor(mask_psi);shading flat;colorbar

%%

% fig(1);clf;pcolor(mask_psi(1:100,1315:end));shading flat
% fig(2);clf;pcolor(mask_psi);shading flat;colorbar
mask_rho(1:100,1315:end) = 0;
mask_psi(1:100,1315:end) = 0;
mask_u(1:100,1315:end)   = 0;
mask_v(1:100,1315:end)   = 0;
fig(3);clf;pcolor(mask_psi);shading flat;colorbar

%% psi

[ny,nx] = size(mask_psi)
newmask_psi = mask_psi;
for ii=2:nx-1; for jj=2:ny-1
    mask_psi(jj-1:jj+1,ii-1:ii+1);dum=sum(ans(:))-mask_psi(jj,ii);
    if dum == 0
        newmask_psi(jj,ii) = 0;
    end;
    if dum == 8
        newmask_psi(jj,ii) = 1;
    end;
end;end;
nc_varput(gridFile,'mask_psi',newmask_psi);

%% rho

[ny,nx] = size(mask_rho)
newmask_rho = mask_rho;
for ii=2:nx-1; for jj=2:ny-1
    mask_rho(jj-1:jj+1,ii-1:ii+1);dum=sum(ans(:))-mask_rho(jj,ii);
    if dum == 0
        newmask_rho(jj,ii) = 0;
    end;
    if dum == 8
        newmask_rho(jj,ii) = 1;
    end;
end;end;
nc_varput(gridFile,'mask_rho',newmask_rho);


%% u

[ny,nx] = size(mask_u)
newmask_u = mask_u;
for ii=2:nx-1; for jj=2:ny-1
    mask_u(jj-1:jj+1,ii-1:ii+1);dum=sum(ans(:))-mask_u(jj,ii);
    if dum == 0
        newmask_u(jj,ii) = 0;
    end;
    if dum == 8
        newmask_u(jj,ii) = 1;
    end;
end;end;
nc_varput(gridFile,'mask_u',newmask_u);


%% v

[ny,nx] = size(mask_v)
newmask_v = mask_v;
for ii=2:nx-1; for jj=2:ny-1
    mask_v(jj-1:jj+1,ii-1:ii+1);dum=sum(ans(:))-mask_v(jj,ii);
    if dum == 0
        newmask_v(jj,ii) = 0;
    end;
    if dum == 8
        newmask_v(jj,ii) = 1;
    end;
end;end;
nc_varput(gridFile,'mask_v',newmask_v);



% pcolor(newmask_psi);shading flat
% pcolor(mask_psi);shading flat
