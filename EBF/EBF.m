clear;

his2File = '../netcdfOutput/bob_his2_00001.nc';
gridFile = '../BoB_4km.nc';

rho0 = 1025;    % this is from the log file
g    = 9.81;

rho   = nc_varget(his2File,'rho');      % rho grid
tau_x = nc_varget(his2File,'sustr');    %   u grid
tau_y = nc_varget(his2File,'svstr');    %   v grid

f    =     nc_varget(gridFile,'f');     % rho grid
dx   = 1./(nc_varget(gridFile,'pm'));   % rho grid
dy   = 1./(nc_varget(gridFile,'pn'));   % rho grid

[nt,nyRho,nxRho] = size(rho);

%% look at the grid for a minute

% I have it from Kate that dx(xi,eta) is the inverse of the physical grid
% interval at (xi,eta). Same for dy. If I plot them I should get pretty
% close to 4km everywhere

% fig(1);clf;pcolor(dx);shading flat;colorbar;title('dx')
% fig(2);clf;pcolor(dy);shading flat;colorbar;title('dy')

%% Calculate the Ekman buoyancy flux on the psi grid

nxPsi = nxRho-1;
nyPsi = nyRho-1;


% Put tau_x on the psi grid by averaging vertically adjacent points

tau_xPsi = zeros(nt,nyPsi,nxPsi);
for tt=1:nt
    tau_xPsi(tt,:,:) = .5 * ( tau_x(tt, 1:end-1,:) + tau_x(tt,2:end,:) );
end;

% Put tau_y on the psi grid by averaging horizontally adjacent points

tau_yPsi = zeros(nt,nyPsi,nxPsi);
for tt=1:nt
    tau_yPsi(tt,:,:) = .5 * (tau_y(tt,:,1:end-1) + tau_y(tt,:,2:end) );
end;

% Put dx and dy and f on the psi grid by averaging over 4 corners
dxPsi(:,:)  =        .25 * (     dx(1:end-1,1:end-1)     + dx(1:end-1,2:end)     + dx(2:end,1:end-1)     + dx(2:end,2:end));
dyPsi(:,:)  =        .25 * (     dy(1:end-1,1:end-1)     + dy(1:end-1,2:end)     + dy(2:end,1:end-1)     + dy(2:end,2:end));
 fPsi(:,:)  =        .25 * (      f(1:end-1,1:end-1)     +  f(1:end-1,2:end)     +  f(2:end,1:end-1)     +  f(2:end,2:end));

% Put rho on the psi grid by averaging over 4 corners
rhoPsi = zeros(nt,nyPsi,nxPsi);
for tt=1:nt
    rhoPsi(tt,:,:) = .25 * ( rho(tt,1:end-1,1:end-1) + rho(tt,1:end-1,2:end) + rho(tt,2:end,1:end-1) + rho(tt,2:end,2:end));
end;


% Calculate (d rho)/(d x) and (d rho)/(d y) on the psi grid

DrhoDxPsi = zeros(nt,nyPsi,nxPsi); DrhoDyPsi=DrhoDxPsi;
for tt=1:nt
    DrhoDxPsi(tt,:,:) = .5 * sq( rho(tt,1:end-1,2:end) - rho(tt,1:end-1,1:end-1) + rho(tt,2:end,2:end) - rho(tt,2:end,1:end-1) ) ./ dxPsi;
    DrhoDyPsi(tt,:,:) = .5 * sq( rho(tt,2:end,1:end-1) - rho(tt,1:end-1,1:end-1) + rho(tt,2:end,2:end) - rho(tt,1:end-1,2:end) ) ./ dyPsi;
end;


% Calculate EBF on the psi grid

const = - g/rho0 ./ fPsi;
EBFPsi =  ( tau_yPsi .* DrhoDxPsi - tau_xPsi .* DrhoDyPsi ) ./ (rhoPsi+rho0);
for tt=1:nt
    EBFPsi(tt,:,:) = sq(EBFPsi(tt,:,:)) .* const;
end;

% fig(5);clf;pcolor(sq(EBFPsi(end,:,:)));shading flat;colorbar;caxis(1*10^-5* [-1 1])

%%

sustr = nc_varget(his2File,'sustr');
svstr = nc_varget(his2File,'svstr');
ebf   = nc_varget(his2File,'EBF');




% tauYpsi = ( svstr(:,:,2:end) + svstr(:,:,1:end-1) )/2;
% 
% pm=1./dx;


sq(ebf(2,1:3,1:3))
sq(EBFPsi(2,1:3,1:3))


% sq(rhoPsi(2,1:3,1:3)) +rho0 
(sq(rhoPsi(2,1:3,1:3)) +rho0 ) .* sq(fPsi(1:3,1:3));


% sq(tauYpsi(2,1:3,1:3))

% % sq(sustr(2,1:3,1:3))/rho0
% % sq(svstr(2,1:3,1:3))/rho0
% sq(rho(2,1:3,1:3))

% ebf - sustr(:,1:end-1,:);pcolor(sq(ans(1,:,:)));shading flat
% ebf - svstr(:,1:end-1,:);pcolor(sq(ans(1,:,:)));shading flat

