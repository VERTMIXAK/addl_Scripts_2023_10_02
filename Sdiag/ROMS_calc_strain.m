function strain = ROMS_calc_strain(u,v,grd)

% dU/dy and dV/dx are sized the same as the psi grid, but
% dU/dx and dV/dy are dimensioned 1 smaller in the x and y direction
% respectively. pm and pn are on the rho grid, which is larger than the psi
% grid by one click in each direction.

%% Put pm and pn on the psi grid

pm_psi = (grd.pm(1:end-1,1:end-1) + grd.pm(2:end,1:end-1) + grd.pm(1:end-1,2:end) + grd.pm(2:end,2:end) ) /4;
pn_psi = (grd.pn(1:end-1,1:end-1) + grd.pn(2:end,1:end-1) + grd.pn(1:end-1,2:end) + grd.pn(2:end,2:end) ) /4;

% fig(1);clf;pcolor(grd.pm);shading flat;colorbar
% fig(2);clf;pcolor(pm_psi);shading flat;colorbar
% 
% fig(3);clf;pcolor(grd.pn);shading flat;colorbar
% fig(4);clf;pcolor(pn_psi);shading flat;colorbar


%% dVdx and dUdy are on the psi grid

dVx = diff(v')';
dUy = diff(u);

size(dVx)
size(dUy)

%% dVdy and dUdx 
% These derivatives are each smaller than the psi grid in one dimension and 
% larger in the other. Shrink each grid in both dimensions with offset
% averages, then pad the short dimension at each end by duplicating the
% row or column.

dVy = diff(v);

dVy = ( dVy(:,1:end-1) + dVy(:,2:end) )/2;
dVy = ( dVy(1:end-1,:) + dVy(2:end,:) )/2;

dVy = [dVy(1,:)' dVy' dVy(end,:)']';




dUx = diff(u')';

dUx = ( dUx(:,1:end-1) + dUx(:,2:end) )/2;
dUx = ( dUx(1:end-1,:) + dUx(2:end,:) )/2;

dUx = [dUx(:,1) dUx dUx(:,end)];


%% Calculate the strain

strain = sqrt( (dUx .* pm_psi - dVy .* pn_psi).^2 + (dVx .* pm_psi + dUy .* pn_psi ).^2  );
