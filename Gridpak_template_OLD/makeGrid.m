
    
%% Harper's grid

% The grid is to be centered on 
%   longitude 134
%   latitude   7.75
% in order to be consistent with the PALAU_120C grid.
%
% The central portion of the grid is supposed to have 800m spacing.
%


%%  Start with latitude. The outer limits of the central area are 
%       5.5 to 10 degrees
% I want the transition regions to be about 25km, or about .25 degree. The 
% transition region is meant to be linear, which refers specifically to
% dTheta, so formulate the process using dTheta.

% If you go to
%           edwilliams.org/gccalc.htm
% you can figure out the number of km per deg lon or lat at various places
% on Earth. At 7.75 N there are 110.594 km per deg latitude, so 800m works 
% out to .007235 deg

dLatInner = 800 / 110594;

% Brian's grid is on 2500m intervals, so 

dLatMax = 2500 / 110594;

latCenterMin = 7.75;
latCenterMax = 10;

% number of regularly spaced intervals to edge of central region
nLatInner= round( (latCenterMax - latCenterMin)/dLatInner )

% The transition region has the first dz set at dzOuter, and the subsequent
% dz values get smaller and smaller until they get to the inner region. The
% sum of these dz values has to equal 1. An approximate solution is

[dLatInner:.00093:dLatMax]
sum(ans)

% There are 17 intervals here, and I've used MMA to devise a scheme that
% finds the slope of the line to machine precision using
%   Table[dLatInner + (i-1) C, {i,17}]
%   Solve[Apply[Plus,%] == .25, C]

C = .000934027109;

% Check to make sure the sum is OK

[dLatInner:C:dLatMax];sum(ans)

% Now construct the entire dzLon

% The set of intervals to the right of the center latitude is

[dLatInner*ones(1,nLatInner) [dLatInner:C:dLatMax]];

% so the set of latitudes larger than the center latitude is 

latCenterMin + cumsum(  [dLatInner*ones(1,nLatInner) [dLatInner:C:dLatMax]]   )  ;

% and the total set of allowed latitudes is

myLat =[ ( latCenterMin - fliplr(cumsum(  [dLatInner*ones(1,nLatInner) [dLatInner:C:dLatMax]]) )  ), latCenterMin , latCenterMin + cumsum(  [dLatInner*ones(1,nLatInner) [dLatInner:C:dLatMax]]   )  ];

fig(1);clf;plot(myLat)
fig(2);clf;plot(diff(myLat))


%%  Now do longitude. The outer limits of the central area are 
%       131.5 to 136.5 degrees
% Again, I want the transition regions to be about 25km, or about .25 degree. The 
% transition region is meant to be linear, which refers specifically to
% dTheta, so formulate the process using dTheta.

% If you go to
%           edwilliams.org/gccalc.htm
% you can figure out the number of km per deg lon or lat at various places
% on Earth. At 7.75 N there are 110.3094 km per deg longitude, so 800m works 
% out to .007235 deg

dLonInner = 800 / 110309.4;

% Brian's grid is on 2500m intervals, so 

dLonMax = 2500 / 110309.4;

lonCenterMin = 134;
lonCenterMax = 136.5;

% number of regularly spaced intervals to edge of central region
nLonInner= round( (lonCenterMax - lonCenterMin)/dLonInner )

% The transition region has the first dz set at dzOuter, and the subsequent
% dz values get smaller and smaller until they get to the inner region. The
% sum of these dz values has to equal 1. An approximate solution is

[dLonInner:.00093:dLonMax];
sum(ans)

% There are 17 intervals here, and I've used MMA to devise a scheme that
% finds the slope of the line to machine precision using
%   Table[dLonInner + (i-1) C, {i,17}]
%   Solve[Apply[Plus,%] == .25, C]

C = .000932944238;

% Check to make sure the sum is OK

[dLonInner:C:dLonMax];sum(ans)

% Now construct the entire dzLon

% The set of intervals to the right of the center latitude is

[dLonInner*ones(1,nLonInner) [dLonInner:C:dLonMax]];

% so the set of latitudes larger than the center latitude is 

lonCenterMin + cumsum(  [dLonInner*ones(1,nLonInner) [dLonInner:C:dLonMax]]   )  ;

% and the total set of allowed latitudes is

myLon =[ ( lonCenterMin - fliplr(cumsum(  [dLonInner*ones(1,nLonInner) [dLonInner:C:dLonMax]]) )  ), lonCenterMin , lonCenterMin + cumsum(  [dLonInner*ones(1,nLonInner) [dLonInner:C:dLonMax]]   )  ];

fig(3);clf;plot(myLon)
fig(4);clf;plot(diff(myLon))




%% Create the coast.in file

% the data write begins in the upper left corner, runs counterclockwise
% until you get back (almost) to the starting point.


nx=length(myLon); ny=length(myLat);

dumWest = zeros(ny-1,2);
for jj=1:ny-1
    dumWest(jj,1) = myLat(end-jj+1);
    dumWest(jj,2) = myLon(1);
end

dumSouth = zeros(nx-1,2);
for ii=1:nx-1
    dumSouth(ii,1) = myLat(1);
    dumSouth(ii,2) = myLon(ii);
end

dumEast = zeros(ny-1,2);
for jj=1:ny-1
    dumEast(jj,1) = myLat(jj);
    dumEast(jj,2) = myLon(end);
end

% dumNorth needs one more entry at the end to close the rectangle
dumNorth = zeros(nx,2);
for ii=1:nx
    dumNorth(ii,1) = myLat(end);
    dumNorth(ii,2) = myLon(end-ii+1);
end

coast = vertcat(dumWest,dumSouth,dumEast,dumNorth);

['Include/gridparam.h:  Lm=',num2str(nx-1),'   Mm=',num2str(ny-1)]

save('coast.in','coast','-ascii')