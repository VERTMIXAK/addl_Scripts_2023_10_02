function [dataNew,x,y] = roms_zslice_var(ROMSdata,depth,grd,zsliceStuff)
% $Id: roms_zslice_var.m 358 2008-04-07 14:15:03Z zhang $
% Get a constant-z slice out of a 4-D ROMS variable 
% [data,x,y] = roms_zslice_var(data,time,depth,grd)
%
% Bugs/features:
% 'time' isn't used
% input must be squeezed to dimensions  Z ETA_var XI_var
%
% John Wilkin
% 
% modified for higher throughput    John Pender  26 May 2015

depth = -abs(depth);

sizexy = fliplr(size(ROMSdata));
sizexy = fliplr(sizexy([1 2]));

if ~any(sizexy-size(grd.lon_u))
  var = 'u';
elseif ~any(sizexy-size(grd.lon_v))
  var = 'v';
else
  var = 'a rho-shaped variable';
end


switch var
  case 'u'    
    x = grd.lon_u;
    y = grd.lat_u;
    mask = grd.mask_u;
    
  case 'v'
    x = grd.lon_v;
    y = grd.lat_v;
    mask = grd.mask_v; 
    
  otherwise    
    % for temp, salt, rho, w
    x = grd.lon_rho;
    y = grd.lat_rho;
    mask = grd.mask_rho; 
    
end

% make 2d 'ribbon' out of the depth coordinates
z_r = grd.z_r;

switch var
  case 'u' 
    zg_ind = zsliceStuff.zg_indU;
    zl_ind = zsliceStuff.zl_indU;
    alpha  = zsliceStuff.alphaU;
    N      = zsliceStuff.Nu;
    L      = zsliceStuff.Lu;
    M      = zsliceStuff.Mu;
    
  case 'v'
    zg_ind = zsliceStuff.zg_indV;
    zl_ind = zsliceStuff.zl_indV;
    alpha  = zsliceStuff.alphaV;
    N      = zsliceStuff.Nv;
    L      = zsliceStuff.Lv;
    M      = zsliceStuff.Mv;
    
  otherwise   
    zg_ind = zsliceStuff.zg_indTS;
    zl_ind = zsliceStuff.zl_indTS;
    alpha  = zsliceStuff.alphaTS;
    N      = zsliceStuff.Nts;
    L      = zsliceStuff.Lts;
    M      = zsliceStuff.Mts;
    
end

startingPoint = ROMSdata(:,1:L*M);
startingPoint = [NaN*ones([1 L*M]); startingPoint; startingPoint(N,:)];
startingPoint = flipud(startingPoint);


for zz = [1:length(depth)]

data = startingPoint;

data_greater_z = data(zg_ind(:,zz));
        
% Find the indices of the data values that have just lesser depth
% than depth
data_lesser_z = data(zl_ind(:,zz));
        
% Interpolate between the data values.
data_at_depth = (data_lesser_z.*alpha(:,zz))+(data_greater_z.*(1-alpha(:,zz)));
data = reshape(data_at_depth,[L M]);

% Apply mask to catch shallow water values where the z interpolation does
% not create NaNs in the data
dry = find(mask==0);
mask(dry) = NaN;
data = data.*mask;

dataNew(1,zz,:,:) = data;

end
