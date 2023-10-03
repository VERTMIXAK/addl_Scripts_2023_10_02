clear;

% The raw data is in ../netcdfOutput, as usual, but it's convenient to
% squash the data into single files, like this:
%   ncrcat ../netcdfOutput/TS_his_* TS_his.nc
%   ncrcat ../netcdfOutput/TS_his2_* TS_his2.nc

grid = roms_get_grid('../TS_0.25.nc','TS_his.nc',0,1);
Z_r  = -flipdim(grid.z_r,1);
Z_w  = -flipdim(grid.z_w,1);
[nz,ny,nx]=size(Z_r);

dZ   = 0*Z_r;
for myI=1:nx; for jj=1:ny
        dZ(:,jj,myI) = diff(Z_w(:,jj,myI));
    end;end; %myI,jj

U   = flipdim(nc_varget('./TS_his.nc','u_eastward') ,2);
V   = flipdim(nc_varget('./TS_his.nc','v_northward'),2);
RHO = flipdim(nc_varget('./TS_his.nc','rho')        ,2);

T   = flipdim(nc_varget('./TS_his.nc','temp') ,2);
S   = flipdim(nc_varget('./TS_his.nc','salt') ,2);


mask= grid.mask_rho;
H   = grid.h .* mask;

[nt,nz,ny,nx]=size(T);


%% Calculate N2 from S and T, then compare the numbers to the N2 field
%   I've squirreled away in the ROMS output files. Turns out they line up
%   just fine.

N20file = 'N2.mat';

if ~exist(N20file)
    
    P_r   =    zeros(nz,ny,nx);
    N20_r = zeros(nt,nz,ny,nx);
    rho_r = zeros(nt,nz,ny,nx);
    
    P_w   =    zeros(nz+1,ny,nx);
    N20_w = zeros(nt,nz+1,ny,nx);
    
    for tt=1:nt
        for ii = 1:nx;disp(['calculating N20 in psi, ',num2str(ii),' of ',num2str(nx)])
            for jj = 1:ny

                if  mask(jj,ii)==1;
                    P_r(:,jj,ii) = sw_pres(abs(Z_r(:,jj,ii)),-43);  % JGP calculate P_r for archive
                    P_w(:,jj,ii) = sw_pres(abs(Z_w(:,jj,ii)),-43);  % JGP use P_w in dynmodes
                    
                    tmpS_r = sq(S(tt,:,jj,ii))';
                    tmpT_r = sq(T(tt,:,jj,ii))';
                    tmpP_r = P_r(:,jj,ii);
                    
                    tmpz_r = Z_r(:,jj,ii);
                    tmpz_w = Z_w(:,jj,ii);
                    
                    % JGP note: interp1 will give a warning message if tmpS_r has NaNs, which
                    % is the case for any point under the land mask
                    
                    tmpS_w = interp1(tmpz_r, tmpS_r, tmpz_w, 'linear', 'extrap');
                    tmpT_w = interp1(tmpz_r, tmpT_r, tmpz_w, 'linear', 'extrap');
                    tmpP_w = P_w(:,jj,ii);
                    
                    %   fig(1);clf;plot(z(:,jj,ii),tmpS_r,'b');hold on;plot(zw(:,jj,ii),tmpS_w,'r');title('S_r vs S_w')
                    %   fig(2);clf;plot(z(:,jj,ii),tmpT_r,'b');hold on;plot(zw(:,jj,ii),tmpT_w,'r');title('T_r vs T_w')
                    
                    if max(tmpS_r)>0;
                        
                        [tmpN2_r,~,p_ave_r] = sw_bfrq(tmpS_r,  sw_temp(tmpS_r,tmpT_r,tmpP_r,0) ,tmpP_r); tmpN2_r(tmpN2_r<1e-8)=1e-8;
                        [tmpN2_w,~,p_ave_w] = sw_bfrq(tmpS_w,  sw_temp(tmpS_w,tmpT_w,tmpP_w,0) ,tmpP_w); tmpN2_w(tmpN2_w<1e-8)=1e-8;
                        
                        tmpN2_r = interp1(p_ave_r,tmpN2_r,tmpP_r,'pchip');tmpN2_r(tmpN2_r<1e-8)=1e-8;
                        tmpN2_w = interp1(p_ave_w,tmpN2_w,tmpP_w,'pchip');tmpN2_w(tmpN2_w<1e-8)=1e-8;
                        
                        N20_r(tt,:,jj,ii) = tmpN2_r;
                        N20_w(tt,:,jj,ii) = tmpN2_w;
                        
                        rho_r(tt,:,jj,ii) = sw_dens(tmpS_r, tmpT_r, tmpP_r);
                        
                        %    fig(3);clf;plot(tmpP_r,tmpN2_r,'b');hold on;plot(tmpP_w,tmpN2_w,'r');title('N20_r vs N20_w')
                        
                    end; %if
                    
                end; %if mask
            end; %jj
        end; %ii
    end; %tt
    
    eval(['save -v7.3 ',N20file,' N20_r P_r N20_w P_w rho_r'])
else
    eval(['load       ',N20file,' N20_w N20_r P_w P_r'])
end
done('N2')

% Optional check, assuming I've squirreled ROMS' internal N2 values into
% the w field.

N2_w_ROMS = flipdim(nc_varget('./TS_his.nc','w') ,2);
% N2diff = N2_w_ROMS-N20_w;


% fig(1);clf;
% myI=25;myJ=10;plot(N20_w(32,:,myJ,myI));hold on;plot(N2_w_ROMS(32,:,myJ,myI),'r');
% myI=30;myJ=90;plot(N20_w(32,:,myJ,myI));hold on;plot(N2_w_ROMS(32,:,myJ,myI),'r')
% title(['N2 within ROMS vs N2 calculated from T and S for a couple X,Y',10])

aaa=5;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% From here on out just use the ROMS numbers

Rho_r = RHO;
N2_w  = N2_w_ROMS;
clearvars S T N20_r N20_w N20file N2_w_ROMS N2diff RHO



%% Precondition N2(z)

% I'm not sure why, but ROMS clamps N2_w at the ocean surface and the ocean
% floor. It's possible that ROMS simply doesn't use these numbers for
% anything so never assigns values. I need N2_r, which I'll extract from
% N2_w, and those zero values screw things up.

myT=32;myI=80;myJ=60;
% fig(1);clf;plot(Z_w(:,myJ,myI),N2_w(myT,:,myJ,myI));title('N2_w');xlabel('z')
% fig(2);clf;plot(Z_w(end-15:end,myJ,myI),N2_w(myT,end-15:end,myJ,myI));title('N2_w');xlabel('z')
% fig(3);clf;plot(Z_w(1:15,myJ,myI),N2_w(myT,1:15,myJ,myI));title('N2_w');xlabel('z')

% There are many ways to go on this and all I really want to do right now
% is make sure there's no big spike at either end so I will simply set
%   N2_w(1)     = N2_w(2)
%   N2_w(end-1) = N2_w(end)

for tt=1:nt; for ii=1:nx; for jj=1:ny
            N2_w(tt,1,jj,ii) = N2_w(tt,2,jj,ii);
            N2_w(tt,end,jj,ii) = N2_w(tt,end-1,jj,ii);
        end;end;end;%ii,jj,tt

% fig(4);clf;plot(Z_w(end-15:end,myJ,myI),N2_w(myT,end-15:end,myJ,myI));title('N2_w');xlabel('z')
% fig(5);clf;plot(Z_w(1:15,myJ,myI),N2_w(myT,1:15,myJ,myI));title('N2_w');xlabel('z')

% And get rid of negative values
N2_w(N2_w<1e-8)=1e-8;

% !!!!!!!!!!!  Optional
% Do I also want to smooth the buoyancy, given that I'm going to use them
% to calculate the modes? Rate this as optional, but it seems like a good
% way to get rid of noisy stuff and instabilities.

%pick a point and check the effect of smoothing
% myT=32;myI=80;myJ=60;
nsmoo=3;
dum=sq(N2_w(myT,:,myJ,myI));
fig(6);clf;plot(dum);hold on;plot(smooth(dum,nsmoo),'r')
title(['N2(myT=',num2str(myT),',myJ=',num2str(myJ),',myI=',num2str(myI),') versus a smoothed version',10])

% Go ahead and smooth all the N2(x,y,z,t) as above.
N2smoofile = 'N2smoo.mat';
if ~exist(N2smoofile)
    N2_w_smoo = zeros(nt,nz+1,ny,nx);
    for ii=1:nx; for jj=1:ny; for tt=1:nt;
                N2_w_smoo(tt,:,jj,ii) = smooth(N2_w(tt,:,jj,ii),nsmoo);
                N2_r_smoo(tt,:,jj,ii) = .5 * ( N2_w_smoo(tt,1:end-1,jj,ii) + N2_w_smoo(tt,2:end,jj,ii) );
            end;end;end;%ii,jj,tt
    
    eval(['save -v7.3 ',N2smoofile,' N2_w_smoo N2_r_smoo'])
else
    eval(['load       ',N2smoofile,' N2_w_smoo N2_r_smoo'])
end;%if

% N2_w = N2_w_smoo; clearvars N2_w_smoo N2smoofile;

% Then generate N2_r
N2_r=zeros(tt,nz,ny,nx);
for tt=1:nt; for ii=1:nx; for jj=1:ny
            N2_r(tt,:,jj,ii) = .5 * ( N2_w(tt,1:end-1,jj,ii) + N2_w(tt,2:end,jj,ii) );
        end;end;end;%ii,jj,tt

aaa=5;


%% Choose N20 and Rho0 for generating the modes

Rho0_r = zeros(nz,ny,nx);
N20_r  = zeros(nz,ny,nx);

% for jj=1:ny; for ii=1:nx; for kk=1:nz
% 	Rho0_r(kk,jj,ii) = mean( Rho_r(:,kk,jj,ii) );
% 	 N20_r(kk,jj,ii) = mean(  N2_r(:,kk,jj,ii) );
% end;end;end;%ii,jj,kk

for jj=1:ny; for ii=1:nx; for kk=1:nz
            Rho0_r(kk,jj,ii) = Rho_r(1,kk,jj,ii) ;
            N20_r(kk,jj,ii) =  N2_r(1,kk,jj,ii) ;
        end;end;end;%ii,jj,kk




%% Pick some point x,y as a test case,
%    Evaluate all the eigenmodes and eigencoefficients for all times.

myI=30; myJ=90;          % lots of variation
% myI=80;myJ=60;  %also good
nVel   = 3;
nD = 3;

PatmyImyJ  = zeros(nVel,nt,nz);
WatmyImyJ  = zeros(nD,nt,nz);

for tt=1:nt
    if ( grid.mask_rho(myJ,myI) == 1 )
        
        z_r = Z_r(:,myJ,myI);
        z_w = Z_w(:,myJ,myI);
        dz  =  dZ(:,myJ,myI);
        
        p_r = P_r(:,myJ,myI);
        p_w = P_w(:,myJ,myI);
        %         rho_r = RHO(tt,:,myJ,myI)';
        
        n2_w = N2_w_smoo(tt,:,myJ,myI)';%n2_w(n2_w<1e-8)=1e-8;
        %         n2_w = N2_w(tt,:,myJ,myI)';n2_w(n2_w<1e-8)=1e-8;
        %         n2_r = N2_r(tt,:,myJ,myI)';n2_r(n2_r<1e-8)=1e-8;
        
        [w, p, ce, Pout]=ROMS_dynmodes_jgp(n2_w,p_w,p_r);
        %         p = [ones(nz,1)/1030. p];    // barotropic mode
        
        for nn = 1:nVel;    % nVel modes are relevant
            p(:,nn) = p(:,nn)/sign(p(1,nn));
            pnorm = p(1,nn);
            p(:,nn) = p(:,nn)/pnorm;
            PatmyImyJ(nn,tt,:) =  p(:,nn);
        end; %nn
        
        for nn = 1:nD;    % nD modes are relevant
            w(:,nn) = w(:,nn)/sign(w(1,nn));
            WatmyImyJ(nn,tt,:) =  w(:,nn);
        end % nn
        
    else
        'masked out'
    end;% if
end;% tt
done(['Evaluating all modes at (myJ=',num2str(myJ),',myI=',num2str(myI),',all t)'])

%% Simplex method: use t=0 modes at X,Y for all t. Keep myI,myJ as above

eigUsimplex = zeros(nVel,nt);
eigUideal   = zeros(nVel,nt);
eigRsimplex = zeros(nD,nt);
eigRideal   = zeros(nD,nt);
eigDsimplex = zeros(nD,nt);
eigDideal   = zeros(nD,nt);

z_r = Z_r(:,myJ,myI);
z_w = Z_w(:,myJ,myI);
dz  = dZ( :,myJ,myI);

rho0_r = Rho0_r(:,myJ,myI);

for tt=1:nt;
    %     for tt=1:nt;
    
    n2_r   = N2_r(tt,:,myJ,myI)';
    u_r    = U(tt,:,myJ,myI)';
    rho_r  = Rho_r(tt,:,myJ,myI)';
    
    for nn=1:nVel
        % case 1: find the eigencoefficients from the t=0 wmodes
        num = sum(sq(PatmyImyJ(nn,1,:)) .* dz .* u_r);
        denom = sum( sq(PatmyImyJ(nn,1,:)).^2 .* dz  );
        eigUsimplex(nn,tt) = num/denom;
        
        % case 2: find the eigencoefficients from the updated wmodes
        num = sum(sq(PatmyImyJ(nn,tt,:)) .* dz .* u_r);
        denom = sum( sq(PatmyImyJ(nn,tt,:)).^2 .* dz  );
        eigUideal(nn,tt) = num/denom;
    end; %nn
    
    % Notes. I am trying to evaluate
    %       D = g/rho0 (rho-rho0) / N2
    % rho and rho0 are on the rho grid and I have N2_r here, so no problem.
    % Sanity check. Plot rho vs rho0 near the top of the ocean.
    %     fig(99);clf;ndum=30;plot(z_r(1:ndum),rho0_r(1:ndum),'r');hold on;plot(z_r(1:ndum),rho_r(1:ndum),'.');title('rho vs rho0')
    %     fig(98);clf;plot(z_r(1:ndum),N20_r(1:ndum,myJ,myI),'r');hold on;plot(z_r(1:ndum),n2_r(1:ndum));title('N20')
    
    % At (tt,myJ,myI) = (1,90,30) you see that the first blue dot has the same
    % density as a depth of 30-40m so D=3040. By about the 27th dot (200 m
    % down) the dot is on top of the rho0 curve so D=0.
    % At (tt,myJ,myI) = (32,90,30) you see that the first blue dot has to
    % travel left to a fictition point (D=-836) well above the sea surface to get to the
    % rho0 curve. By about the 23rd dot (150 m down) the dot is on top of the
    % rho0 curve so D=0.
    
    % NOTE: the displacement D has nothing to do with zeta.
    
    % The problem is that the displacement I calculate is much higher than the
    % one I would expect from the plot.
    
    for nn=1:nD
        D = 9.8 * (rho_r-rho0_r) ./ (1000+rho0_r) ./ sq(N20_r(:,myJ,myI)) ;
        
        % case 1: find the eigencoefficients from the t=0 wmodes
        num = sum( n2_r .* sq(WatmyImyJ(nn,1,:)) .* dz );
        denom = sum( n2_r .* sq(WatmyImyJ(nn,1,:)).^2 .* dz  );
        eigDsimplex(nn,tt) = num/denom;
        
        % case 2: find the eigencoefficients from the updated wmodes
        num = sum( n2_r .* sq(WatmyImyJ(nn,tt,:)) .* dz );
        denom = sum( n2_r .* sq(WatmyImyJ(nn,tt,:)).^2 .* dz  );
        eigDideal(nn,tt) = num/denom;
    end; %nn
    
    for nn=1:nD
        % case 1: find the eigencoefficients from the t=0 wmodes
        num = sum(sq(WatmyImyJ(nn,1,:)) .* dz .* (rho_r-rho0_r));
        denom = sum( n2_r .* sq(WatmyImyJ(nn,1,:)).^2 .* dz  );
        eigRsimplex(nn,tt) = num/denom;
        
        % case 2: find the eigencoefficients from the updated wmodes
        num = sum(sq(WatmyImyJ(nn,tt,:)) .* dz .* (rho_r-rho0_r));
        denom = sum( n2_r .* sq(WatmyImyJ(nn,tt,:)).^2 .* dz  );
        eigRideal(nn,tt) = num/denom;
    end; %nn
    
    
end;

tMax=nt;

fig(5);clf;suptitle('U eigencoefficients. Ideal (red) vs Simplex (blue)')
subplot(3,1,1);plot(eigUsimplex(1,1:tMax));hold on;plot(eigUideal(1,1:tMax),'r');xlabel('days');ylabel('eigU 1')
subplot(3,1,2);plot(eigUsimplex(2,1:tMax));hold on;plot(eigUideal(2,1:tMax),'r');xlabel('days');ylabel('eigU 2')
subplot(3,1,3);plot(eigUsimplex(3,1:tMax));hold on;plot(eigUideal(3,1:tMax),'r');xlabel('days');ylabel('eigU 3')

fig(6);clf;suptitle('Pmodes at X,Y -  31 days')
subplot(3,1,1);plot(z_r,sq(PatmyImyJ(1,1:tMax,:))');ylabel('pmode 1');axis([0 max(z_r) -1.1 1.1]);xlabel('z');hold on;plot(z_r,sq(PatmyImyJ(1,1,:)),'r','LineWidth',3)
subplot(3,1,2);plot(z_r,sq(PatmyImyJ(2,1:tMax,:))');ylabel('pmode 2');axis([0 max(z_r) -1.1 1.1]);xlabel('z');hold on;plot(z_r,sq(PatmyImyJ(2,1,:)),'r','LineWidth',3)
subplot(3,1,3);plot(z_r,sq(PatmyImyJ(3,1:tMax,:))');ylabel('pmode 3');axis([0 max(z_r) -1.1 1.1]);xlabel('z');hold on;plot(z_r,sq(PatmyImyJ(3,1,:)),'r','LineWidth',3)

fig(7);clf;suptitle('Displacement eigencoefficients. Ideal (red) vs Simplex (blue)')
subplot(3,1,1);plot(eigDsimplex(1,1:tMax));hold on;plot(eigDideal(1,1:tMax),'r');xlabel('days');ylabel('eigD 1')
subplot(3,1,2);plot(eigDsimplex(2,1:tMax));hold on;plot(eigDideal(2,1:tMax),'r');xlabel('days');ylabel('eigD 2')
subplot(3,1,3);plot(eigDsimplex(3,1:tMax));hold on;plot(eigDideal(3,1:tMax),'r');xlabel('days');ylabel('eigD 3')
suptitle('D eigencoefficients. Ideal (red) vs Simplex (blue)')

fig(8);clf;suptitle('Wmodes at X,Y -  31 days')
subplot(3,1,1);plot(z_r,sq(WatmyImyJ(1,1:tMax,:))');ylabel('wmode 1');axis([0 max(z_r)  0   1.1]);xlabel('z');hold on;plot(z_r,sq(WatmyImyJ(1,1,:)),'r','LineWidth',3)
subplot(3,1,2);plot(z_r,sq(WatmyImyJ(2,1:tMax,:))');ylabel('wmode 2');axis([0 max(z_r) -1.1 1.1]);xlabel('z');hold on;plot(z_r,sq(WatmyImyJ(2,1,:)),'r','LineWidth',3)
subplot(3,1,3);plot(z_r,sq(WatmyImyJ(3,1:tMax,:))');ylabel('wmode 3');axis([0 max(z_r) -1.1 1.1]);xlabel('z');hold on;plot(z_r,sq(WatmyImyJ(3,1,:)),'r','LineWidth',3)

fig(9);clf;suptitle('Rho eigencoefficients. Ideal (red) vs Simplex (blue)')
subplot(3,1,1);plot(eigRsimplex(1,1:tMax));hold on;plot(eigRideal(1,1:tMax),'r');xlabel('days');ylabel('eigR 1')
subplot(3,1,2);plot(eigRsimplex(2,1:tMax));hold on;plot(eigRideal(2,1:tMax),'r');xlabel('days');ylabel('eigR 2')
subplot(3,1,3);plot(eigRsimplex(3,1:tMax));hold on;plot(eigRideal(3,1:tMax),'r');xlabel('days');ylabel('eigR 3')


% General conclusions:
%  1) The pmodes are generally better behaved for some reason
%  2) The more zero crossings the worse the divergence
%  3) The divergence isn't usually too bad for at least a few days
%  4) Since the simplex modes are not changing, the eigencoefficients
%       calculated from the simplex modes have less variation
%  5) The Displacement eigencoefficients are all over the map for some
%  reason.



%% Best-Mode method: Keep myI,myJ as above

% The idea is this: there are many sites which have very nearly the same
% ocean depth as my test point, H(myJ,myI). It is probable that one of these
% has pmodes and wmodes that are more like the t>0 modes than the simplex
% case, which uses the modes for X,Y and t=0.

% Given the depth at X,Y there are a fair few grid points with comparable
% depth.

myDepth=10*round(grid.h(myJ,myI)/10);
binWidth = 50;

[jPool,iPool] = find ( abs(myDepth - H) < binWidth);
length(jPool);

myXYinPool=intersect(find(myJ == jPool),find(myI == iPool))

aaa=6;

%% The crucial issue is to find the pmodes and wmodes most like the ones I
% would calculate on the fly at a given X,Y,T, except that I don't have
% those modes. What I have is N2(X,Y,T) and Rho(X,Y,T) (ROMS calculates it as
% matter of routine) so I will have to - somehow - figure out the best way
% to compare this N2 and/or Rho to all the N2 curves and/or Rho curves
% in my pool of comparable depths as calculated at T=0.

% Create a few new arrays for convenience:
%  N2_r_ofTatmyImyJ    N2  on rho grid, at point X,Y for all values of T
%  N2_r_Pool           N2  on rho grid at t=0, for a set of points with H close to H(X,Y)
%
%  Rho_r_ofTatmyImyJ   Rho on rho grid, at point X,Y for all values of T
%  Rho_r_Pool          Rho on rho grid at t=0, for a set of points with H close to H(X,Y)


N2_r_ofTatmyImyJ = sq(N2_r(:,:,myJ,myI));
Rho_r_ofTatmyImyJ = sq(Rho_r(:,:,myJ,myI));

N2_r_Pool = zeros(length(jPool),nz);
Rho_r_Pool = zeros(length(jPool),nz);
for mm=1:length(jPool)
    N2_r_Pool(mm,:)  =  N2_r(1,:,jPool(mm),iPool(mm));
    Rho_r_Pool(mm,:) = Rho_r(1,:,jPool(mm),iPool(mm));
end;%mm

% % Here is one way to make my job easier: It is apparent from the
% % differential equation that generates the modes that N2 can be multiplied
% % by any constant without changing the modes. So I will pull out the
% % N2(t) at my reference point X,Y and normalize them in some way. Choose
% %       Integral(N2(z) dz) = 1
% % note: I've tried other normalizations and have had the most success with this one
%
% for tt=1:nt
%     N2_r_ofTatmyImyJ(tt,:) = N2_r_ofTatmyImyJ(tt,:) / norm(N2_r_ofTatmyImyJ(tt,:) .* dz');
% end;%tt
%
% for mm=1:length(jPool)
%     N2_r_Pool(mm,:) = N2_r_Pool(mm,:) / norm(N2_r_Pool(mm,:) .* dz');
% end;%mm

% NOTE: there's not much point plotting density because it doesn't vary
% enough to see the variation.


% Over time, N2 evolves from the blue line to the red line. The other
% lines are all the intermediate steps.

fig(10);clf;plot(N2_r_ofTatmyImyJ(2:end-1,:)');hold on;plot(N2_r_ofTatmyImyJ(1,:),'b','LineWidth',3);plot(N2_r_ofTatmyImyJ(nt,:),'r','LineWidth',3);
title('Evolution of N2 at X,Y - t=0 (blue) and t=Tend (red)')

% A particular snapshot, at tt=nt=32 days, in red line. All the other
% curves are from my pool of candidates at t=0. Surely, one of these must
% have a better suite of modes than the t=0 modes for X,Y

fig(11);clf;plot(N2_r_Pool(:,:)');hold on;plot(N2_r_ofTatmyImyJ(end,:),'r','LineWidth',3);
title('N2(Tfinal,Y,X) and the pool of relevant N2 at t=0')

% fig(12);clf;plot(N2_r_ofTatmyImyJ(1,:),'b');hold on;plot(N2_r_Pool(myXYinPool,:),'r');
% title('make sure N2_r_Pool(myXYinPool) looks OK')


fig(12);clf;plot(Rho_r_ofTatmyImyJ(2:end-1,:)');hold on;plot(Rho_r_ofTatmyImyJ(1,:),'b','LineWidth',3);plot(Rho_r_ofTatmyImyJ(nt,:),'r','LineWidth',3);
title('Evolution of Rho at X,Y - t=0 (blue) and t=Tend (red)')

% A particular snapshot, at tt=nt=32 days, in red line. All the other
% curves are from my pool of candidates at t=0. Surely, one of these must
% have a better suite of modes than the t=0 modes for X,Y

fig(13);clf;plot(Rho_r_Pool(:,:)');hold on;plot(Rho_r_ofTatmyImyJ(end,:),'r','LineWidth',3);
title('Rho(Tfinal,Y,X) and the pool of relevant N2 at t=0')

%% Generate the pmodes and wmodes at t=0 for the pool of candidates.

PPool  = zeros(nVel,length(jPool),nz);
WPool  = zeros(nD,length(jPool),nz);

for mm=1:length(jPool)
    % for mm=45:46
    if ( grid.mask_rho(myJ,myI) == 1 )
        
        z_r = Z_r(:,jPool(mm),iPool(mm));
        z_w = Z_w(:,jPool(mm),iPool(mm));
        dz  = diff(z_w);
        
        p_r = P_r(:,jPool(mm),iPool(mm));
        p_w = P_w(:,jPool(mm),iPool(mm));
        
        n2_w = N2_w_smoo(1,:,jPool(mm),iPool(mm))';%n2_w(n2_w<1e-8)=1e-8;
        %         n2_r = N2_r(1,:,jPool(mm),iPool(mm))';n2_r(n2_r<1e-8)=1e-8;
        
        [w, p, ce, Pout]=ROMS_dynmodes_jgp(n2_w,p_w,p_r);
        %         p = [ones(nz,1)/1030. p];    // barotropic mode
        
        for nn = 1:nVel;    % nVel modes are relevant
            p(:,nn) = p(:,nn)/sign(p(1,nn));
            pnorm = p(1,nn);
            p(:,nn) = p(:,nn)/pnorm;
            PPool(nn,mm,:) =  p(:,nn);
        end; %nn
        
        for nn = 1:nD;    % nD modes are relevant
            w(:,nn) = w(:,nn)/sign(w(1,nn));
            WPool(nn,mm,:) =  w(:,nn);
        end % nn
        
    else
        'masked out'
    end;% if
end;% mm

%  Some checks. Overlap should be perfect for timeIndex = 1; imperfect otherwise
% fig(11);clf;plot(sq(PatmyImyJ(:,1,:))','b');hold on;plot(sq(PPool(:,myXYinPool,:))','r');
% title('make sure the modes look OK')
%
% fig(12);clf;plot(sq(WatmyImyJ(:,1,:))','b');hold on;plot(sq(WPool(:,myXYinPool,:))','r');
% title('make sure the modes look OK')


%% Stage 1.
% Identify the Pool element for each snapshot which gets closest to the
% actual eigencoefficients.

z_r = Z_r(:,myJ,myI);
z_w = Z_w(:,myJ,myI);
dz  = dZ( :,myJ,myI);
rho0_r = Rho0_r(:,myJ,myI);

eigUphase1 = zeros(nVel,nt,length(jPool));
eigRphase1 = zeros(nD,  nt,length(jPool));
eigDphase1 = zeros(nD,  nt,length(jPool));

for tt=1:nt;
    n2_r   = N2_r(tt,:,myJ,myI)';
    u_r    = U(tt,:,myJ,myI)';
    rho_r  = Rho_r(tt,:,myJ,myI)';
    
    for mm=1:length(jPool)
        
        for vv=1:nVel
            num = sum(sq(PPool(vv,mm,:)) .* dz .* u_r);
            denom = sum( sq(PPool(vv,mm,:)).^2 .* dz  );
            eigUphase1(vv,tt,mm) = num/denom;
        end;%vv
        
        D = 9.8 * (rho_r-rho0_r) ./ (1000+rho0_r) ./ sq(N20_r(:,myJ,myI)) ;
        for dd=1:nD
            num = sum( n2_r .* sq(WPool(dd,mm,:)) .* dz );
            denom = sum( n2_r .* sq(WPool(dd,mm,:)).^2 .* dz  );
            eigDphase1(dd,tt,mm) = num/denom;
        end; %dd
        
        for rr=1:nD
            num = sum(sq(WPool(rr,mm,:)) .* dz .* (rho_r-rho0_r));
            denom = sum( n2_r .* sq(WPool(rr,mm,:)).^2 .* dz  );
            eigRphase1(rr,tt,mm) = num/denom;
        end; %nn
        
    end;%mm
end;%tt

CofMerit1 = zeros(length(jPool),nt);
for mm=1:length(jPool)
    
    dum = ( (eigUideal(vv,1) - eigUphase1(vv,1,mm))/eigUideal(vv,1) )^2;
    CofMerit1(mm,1) = CofMerit1(mm,1) + dum;
    
    for tt=2:nt
        for vv=1:nVel
            dum =  ( (eigUideal(vv,tt) - eigUphase1(vv,tt,mm))/eigUideal(vv,tt) )^2;
            CofMerit1(mm,tt) = CofMerit1(mm,tt) + dum;
        end;%vv
        for rr=1:nD
            dum = ( (eigRideal(rr,tt) - eigRphase1(rr,tt,mm))/eigRideal(rr,tt) )^2;
            CofMerit1(mm,tt) = CofMerit1(mm,tt) + dum;
        end;%vv
    end;%tt
end;%mm

for tt=1:nt
    myBest1(tt) =  find(CofMerit1(:,tt) == min(CofMerit1(:,tt)));
end;%tt

eigU1 = zeros(nVel,nt);
for tt=1:nt; 
    for vv=1:nVel
        eigU1(vv,tt) = eigUphase1(vv,tt,myBest1(tt));
    end;%vv 
    for rr=1:nD
        eigD1(rr,tt) = eigDphase1(rr,tt,myBest1(tt));
        eigR1(rr,tt) = eigRphase1(rr,tt,myBest1(tt));
    end;%vv
end;%vv


tMax=5;

fig(5);clf;suptitle('U eigencoefficients. Ideal (blue) vs Simplex (red) vs Phase1 (green)')
subplot(3,1,1);plot(eigUsimplex(1,1:tMax),'r');hold on;plot(eigUideal(1,1:tMax),'b');
    plot(eigU1(1,1:tMax),'g')  
    xlabel('days');ylabel('eigU 1')
subplot(3,1,2);plot(eigUsimplex(2,1:tMax),'r');hold on;plot(eigUideal(2,1:tMax),'b');
    plot(eigU1(2,1:tMax),'g')  
    xlabel('days');ylabel('eigU 2')
subplot(3,1,3);plot(eigUsimplex(3,1:tMax),'r');hold on;plot(eigUideal(3,1:tMax),'b');
    plot(eigU1(3,1:tMax),'g')  
    xlabel('days');ylabel('eigU 3')

fig(7);clf;suptitle('Displacement eigencoefficients. Ideal (blue) vs Simplex (red) vs Phase1 (green)')
subplot(3,1,1);plot(eigDsimplex(1,1:tMax),'r');hold on;plot(eigDideal(1,1:tMax),'b');
    plot(eigD1(1,1:tMax),'g')  
    xlabel('days');ylabel('eigD 1')
subplot(3,1,2);plot(eigDsimplex(2,1:tMax),'r');hold on;plot(eigDideal(2,1:tMax),'b');
    plot(eigD1(2,1:tMax),'g')  
    xlabel('days');ylabel('eigD 2')
subplot(3,1,3);plot(eigDsimplex(3,1:tMax),'r');hold on;plot(eigDideal(3,1:tMax),'b');
    plot(eigD1(3,1:tMax),'g')  
    xlabel('days');ylabel('eigD 3')

fig(9);clf;suptitle('Rho eigencoefficients. Ideal (blue) vs Simplex (red) vs Phase1 (green)')
subplot(3,1,1);plot(eigRsimplex(1,1:tMax),'r');hold on;plot(eigRideal(1,1:tMax),'b');
    plot(eigR1(1,1:tMax),'g')  
    xlabel('days');ylabel('eigR 1')
subplot(3,1,2);plot(eigRsimplex(2,1:tMax),'r');hold on;plot(eigRideal(2,1:tMax),'b');
    plot(eigR1(2,1:tMax),'g') 
    xlabel('days');ylabel('eigR 2')
subplot(3,1,3);plot(eigRsimplex(3,1:tMax),'r');hold on;plot(eigRideal(3,1:tMax),'b');
    plot(eigR1(3,1:tMax),'g') 
    xlabel('days');ylabel('eigR 3')












%% Ok, now do a little reverse engineering.
%   I have all the pmodes calculated. Given the modes for a specific state
%   myI,myJ,myT I can find the location in my Pool whose modes most match
%   and I can find the location in my Pool which best reproduces the
%   eigencoefficients and see if the two correspond.

myT=32;
[myT myJ myI]

% First find the best fit on the modes themselves
myBestModesList=zeros(length(jPool),1);
for mm=1:length(jPool)
    for vv=1:nVel
        %         myBestModesList(mm)=myBestModesList(mm) +
    end;%vv
    for rr=1:nD
        %         sdf
    end;%rr
end;%mm




%% so I can figure out which I like the
%   best then come up with a rule that choose the N2 from my pool that
%   gives me those modes.

myT = 16;
myList = zeros(length(jPool),1);
myN2ofT = N2_r_ofTatmyImyJ(myT,:)';
for mm=1:length(jPool)
    for rr=1:nD
        myList(mm) = myList(mm) + norm( sq(WPool(rr,mm,:) - WatmyImyJ(rr,myT,:)) );
    end;%rr
    for vv=1:nVel
        myList(mm) = myList(mm) + norm( sq(PPool(vv,mm,:) - PatmyImyJ(vv,myT,:)) );
    end;%vv
end;%mm

myBest=find(min(myList)==myList)
fig(20);clf;suptitle(['Scheme 1 works. myBest = ',num2str(myBest),10])
% plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:),'r');plot(N2_r_Pool(myBest,:),'g');
subplot(3,2,1);plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:),'r');
plot(N2_r_Pool(myBest,:),'g');title('unnormalized');ylabel('N2')
subplot(3,2,3);plot(N2_r_ofTatmyImyJ(myT,:)/max(N2_r_ofTatmyImyJ(myT,:)),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:)/max(N2_r_ofTatmyImyJ(1,:)),'r');
plot(N2_r_Pool(myBest,:)/max(N2_r_Pool(myBest,:)),'g');title('normalized to max value');ylabel('N2')
subplot(3,2,5);plot(N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz'),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz'),'r');
plot(N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz'),'g');title('normalized to rms integral');ylabel('N2')
subplot(3,2,2);plot(z_r,N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:),'r');
plot(z_r,N2_r_Pool(myBest,:),'g');title('unnormalized');ylabel('N2')
subplot(3,2,4);plot(z_r,N2_r_ofTatmyImyJ(myT,:)/max(N2_r_ofTatmyImyJ(myT,:)),'b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:)/max(N2_r_ofTatmyImyJ(1,:)),'r');
plot(z_r,N2_r_Pool(myBest,:)/max(N2_r_Pool(myBest,:)),'g');title('normalized to max value');ylabel('N2')
subplot(3,2,6);plot(z_r,N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz'),'b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz'),'r');
plot(z_r,N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz'),'g');title('normalized to rms integral');ylabel('N2')

fig(21);clf;suptitle(['Scheme 1 works. myBest = ',num2str(myBest),10])
subplot(3,2,1);plot(sq(PatmyImyJ(1,myT,:)),'b');hold on;plot(sq(PatmyImyJ(1,1,:)),'r');plot(sq(PPool(1,myBest,:)),'g');ylabel('pmode 1')
subplot(3,2,3);plot(sq(PatmyImyJ(2,myT,:)),'b');hold on;plot(sq(PatmyImyJ(2,1,:)),'r');plot(sq(PPool(2,myBest,:)),'g');ylabel('pmode 2')
subplot(3,2,5);plot(sq(PatmyImyJ(3,myT,:)),'b');hold on;plot(sq(PatmyImyJ(3,1,:)),'r');plot(sq(PPool(3,myBest,:)),'g');ylabel('pmode 3')
subplot(3,2,2);plot(sq(WatmyImyJ(1,myT,:)),'b');hold on;plot(sq(WatmyImyJ(1,1,:)),'r');plot(sq(WPool(1,myBest,:)),'g');ylabel('wmode 1')
subplot(3,2,4);plot(sq(WatmyImyJ(2,myT,:)),'b');hold on;plot(sq(WatmyImyJ(2,1,:)),'r');plot(sq(WPool(2,myBest,:)),'g');ylabel('wmode 2')
subplot(3,2,6);plot(sq(WatmyImyJ(3,myT,:)),'b');hold on;plot(sq(WatmyImyJ(3,1,:)),'r');plot(sq(WPool(3,myBest,:)),'g');ylabel('wmode 3')

% This looks pretty useful - bottom right
fig(22);clf;suptitle(['Scheme 1 works. myBest = ',num2str(myBest),10])
% plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:),'r');plot(N2_r_Pool(myBest,:),'g');
subplot(3,2,1);plot(N2_r_ofTatmyImyJ(myT,:).*dz','b');hold on;plot(N2_r_ofTatmyImyJ(1,:).*dz','r');
plot(N2_r_Pool(myBest,:).*dz','g');title('unnormalized');ylabel('N2 dz')
subplot(3,2,3);plot((N2_r_ofTatmyImyJ(myT,:)/max(N2_r_ofTatmyImyJ(myT,:))).*dz','b');hold on;plot((N2_r_ofTatmyImyJ(1,:)/max(N2_r_ofTatmyImyJ(1,:))).*dz','r');
plot((N2_r_Pool(myBest,:)/max(N2_r_Pool(myBest,:))).*dz','g');title('normalized to max value');ylabel('N2 dz')
subplot(3,2,5);plot((N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz')).*dz','b');hold on;plot((N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz')).*dz','r');
plot((N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz')).*dz','g');title('normalized to rms integral');ylabel('N2 dz')
subplot(3,2,2);plot(z_r,N2_r_ofTatmyImyJ(myT,:).*dz','b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:).*dz','r');
plot(z_r,N2_r_Pool(myBest,:).*dz','g');title('unnormalized');ylabel('N2 dz')
subplot(3,2,4);plot(z_r,(N2_r_ofTatmyImyJ(myT,:)/max(N2_r_ofTatmyImyJ(myT,:))).*dz','b');hold on;plot(z_r,(N2_r_ofTatmyImyJ(1,:)/max(N2_r_ofTatmyImyJ(1,:))).*dz','r');
plot(z_r,(N2_r_Pool(myBest,:)/max(N2_r_Pool(myBest,:))).*dz','g');title('normalized to max value');ylabel('N2 dz')
subplot(3,2,6);plot(z_r,(N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz')).*dz','b');hold on;plot(z_r,(N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz')).*dz','r');
plot(z_r,(N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz')).*dz','g');title('normalized to rms integral');ylabel('N2 dz')

% I really like the plot at bottom left above. The N2 curve that produces
% the best mode match does a great job of following N2(X,Y,myT) for, like,
% 90% of the water column. The y axis already has dz in it so it's a little
% weird that I'm considering another factor of dz in my buoyance selection
% criterion.

% Give it a try.


myList = zeros(length(jPool),1);
myN2ofT

for mm=1:length(jPool)
    myList(mm) = norm( (myN2ofT'/norm(myN2ofT .* dz') - N2_r_Pool(mm,:)/norm(N2_r_Pool(mm,:) .* dz') ) .* dz' .* dz');
end;
newMyBest=find(min(myList)==myList)

fig(25);clf;
plot(z_r,(N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz')).*dz','b');hold on;plot(z_r,(N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz')).*dz','r');
plot(z_r,(N2_r_Pool(newMyBest,:)/norm(N2_r_Pool(newMyBest,:) .* dz')).*dz','g');title('normalized to rms integral');ylabel('N2 dz')
plot(z_r,(N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz')).*dz','k')


% % myList = zeros(length(jPool),1);
% % myN2ofT = N2_r_ofTatmyImyJ(myT,:)';
% % for mm=1:length(jPool)
% %     for rr=1:nD
% %         myList(mm) = myList(mm) + norm( (sq(WPool(rr,mm,:) - WatmyImyJ(rr,myT,:))) .* dz );
% %     end;%rr
% %     for vv=1:nVel
% %         myList(mm) = myList(mm) + norm( (sq(PPool(vv,mm,:) - PatmyImyJ(vv,myT,:))) .* dz );
% %     end;%vv
% % end;%mm
% %
% % myBest=find(min(myList)==myList)
% % fig(22);clf;suptitle(['Scheme 2. myBest = ',num2str(myBest)])
% % plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:),'r');plot(N2_r_Pool(myBest,:),'g');
% %
% % fig(23);clf;suptitle(['Scheme 2. myBest = ',num2str(myBest)])
% % subplot(3,2,1);plot(sq(PatmyImyJ(1,myT,:)),'b');hold on;plot(sq(PatmyImyJ(1,1,:)),'r');plot(sq(PPool(1,myBest,:)),'g');ylabel('pmode1')
% % subplot(3,2,3);plot(sq(PatmyImyJ(2,myT,:)),'b');hold on;plot(sq(PatmyImyJ(2,1,:)),'r');plot(sq(PPool(2,myBest,:)),'g');ylabel('pmode2')
% % subplot(3,2,5);plot(sq(PatmyImyJ(3,myT,:)),'b');hold on;plot(sq(PatmyImyJ(3,1,:)),'r');plot(sq(PPool(3,myBest,:)),'g');ylabel('pmode3')
% % subplot(3,2,2);plot(sq(WatmyImyJ(1,myT,:)),'b');hold on;plot(sq(WatmyImyJ(1,1,:)),'r');plot(sq(WPool(1,myBest,:)),'g');ylabel('wmode1')
% % subplot(3,2,4);plot(sq(WatmyImyJ(2,myT,:)),'b');hold on;plot(sq(WatmyImyJ(2,1,:)),'r');plot(sq(WPool(2,myBest,:)),'g');ylabel('wmode2')
% % subplot(3,2,6);plot(sq(WatmyImyJ(3,myT,:)),'b');hold on;plot(sq(WatmyImyJ(3,1,:)),'r');plot(sq(WPool(3,myBest,:)),'g');ylabel('wmode3')




% % % myList = zeros(length(jPool),1);
% % % myN2ofT = N2_r_ofTatmyImyJ(myT,:)';
% % % for mm=1:length(jPool)
% % %     for rr=1:nD
% % %         myList(mm) = myList(mm) + dot( sq(WPool(rr,mm,:)), sq(WatmyImyJ(rr,myT,:)) );
% % %     end;%rr
% % %     for vv=1:nVel
% % %         myList(mm) = myList(mm) + dot( sq(PPool(vv,mm,:)), sq(PatmyImyJ(vv,myT,:)) );
% % %     end;%vv
% % % end;%mm
% % %
% % % myBest=find(max(myList)==myList)
% % % fig(24);clf;suptitle(['Scheme 3 sucks. myBest = ',num2str(myBest),10])
% % % % plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:),'r');plot(N2_r_Pool(myBest,:),'g');
% % % subplot(3,2,1);plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:),'r');
% % %     plot(N2_r_Pool(myBest,:),'g');title('unnormalized');ylabel('N2')
% % % subplot(3,2,3);plot(N2_r_ofTatmyImyJ(myT,:)/max(N2_r_ofTatmyImyJ(myT,:)),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:)/max(N2_r_ofTatmyImyJ(1,:)),'r');
% % %     plot(N2_r_Pool(myBest,:)/max(N2_r_Pool(myBest,:)),'g');title('normalized to max value');ylabel('N2')
% % % subplot(3,2,5);plot(N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz'),'b');hold on;plot(N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz'),'r');
% % %     plot(N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz'),'g');title('normalized to rms integral');ylabel('N2')
% % % subplot(3,2,2);plot(z_r,N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:),'r');
% % %     plot(z_r,N2_r_Pool(myBest,:),'g');title('unnormalized');ylabel('N2')
% % % subplot(3,2,4);plot(z_r,N2_r_ofTatmyImyJ(myT,:)/max(N2_r_ofTatmyImyJ(myT,:)),'b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:)/max(N2_r_ofTatmyImyJ(1,:)),'r');
% % %     plot(z_r,N2_r_Pool(myBest,:)/max(N2_r_Pool(myBest,:)),'g');title('normalized to max value');ylabel('N2')
% % % subplot(3,2,6);plot(z_r,N2_r_ofTatmyImyJ(myT,:)/norm(N2_r_ofTatmyImyJ(myT,:) .* dz'),'b');hold on;plot(z_r,N2_r_ofTatmyImyJ(1,:)/norm(N2_r_ofTatmyImyJ(1,:) .* dz'),'r');
% % %     plot(z_r,N2_r_Pool(myBest,:)/norm(N2_r_Pool(myBest,:) .* dz'),'g');title('normalized to rms integral');ylabel('N2')
% % %
% % % fig(25);clf;suptitle(['Scheme 3sucks. myBest = ',num2str(myBest),10])
% % % subplot(3,2,1);plot(sq(PatmyImyJ(1,myT,:)),'b');hold on;plot(sq(PatmyImyJ(1,1,:)),'r');plot(sq(PPool(1,myBest,:)),'g')
% % % subplot(3,2,3);plot(sq(PatmyImyJ(2,myT,:)),'b');hold on;plot(sq(PatmyImyJ(2,1,:)),'r');plot(sq(PPool(2,myBest,:)),'g')
% % % subplot(3,2,5);plot(sq(PatmyImyJ(3,myT,:)),'b');hold on;plot(sq(PatmyImyJ(3,1,:)),'r');plot(sq(PPool(3,myBest,:)),'g')
% % % subplot(3,2,2);plot(sq(WatmyImyJ(1,myT,:)),'b');hold on;plot(sq(WatmyImyJ(1,1,:)),'r');plot(sq(WPool(1,myBest,:)),'g')
% % % subplot(3,2,4);plot(sq(WatmyImyJ(2,myT,:)),'b');hold on;plot(sq(WatmyImyJ(2,1,:)),'r');plot(sq(WPool(2,myBest,:)),'g')
% % % subplot(3,2,6);plot(sq(WatmyImyJ(3,myT,:)),'b');hold on;plot(sq(WatmyImyJ(3,1,:)),'r');plot(sq(WPool(3,myBest,:)),'g')



% myBest hits Pool(23) either way, so what criterion can I choose for the
% match between myN2ofT and the elements of N2Pool that also hits 23?


%% Pick best fit from N2

% Try normalizing each N2 by norm of N2 .* dz, then minimize difference
% between
%           myN2ofT .* dz
% and
%           N2Pool(mm) .* dz
% i.e. norm( vec1 - vec2)




%% Ok, now I want to pick some N2_r_ofTatmyImyJ and select the element of N2_r_Pool
%       that has the best mode match

% % % % Try minimizing norm of the depth integral of the difference - Definitely better
% % % myList = zeros(length(jPool),1);
% % %
% % % myT = 32;
% % % myN2ofT = N2_r_ofTatmyImyJ(myT,:)';
% % %
% % % for mm=1:length(jPool)
% % %         myList(mm) = norm( myN2ofT - N2_r_Pool(mm,:)' );
% % % end;%mm
% % %
% % % myBest=find(min(myList)==myList)
% % %
% % % fig(13);clf;plot(N2_r_ofTatmyImyJ(myT,:),'b');hold on;plot(N2_r_Pool(myBest,:),'r')
% % %
% % % fig(15);clf;plot(sq(PatmyImyJ(:,myT,:))','b');hold on;plot(sq(PPool(:,myBest,:))','r');
% % % title('make sure the modes look OK')
% % %
% % % fig(16);clf;plot(sq(WatmyImyJ(:,myT,:))','b');hold on;plot(sq(WPool(:,myBest,:))','r');
% % % title('make sure the modes look OK')



% fig(15);clf;plot(sq(WatmyImyJ(:,myT,:))','b');hold on;plot(sq(WatmyImyJ(:,1,:))','r');plot(sq(WPool(:,myBest,:))','g')





%
% myLoc=intersect(find(myJ==jDepth),find(myI==iDepth));
% fig(52);clf;plot(z_r,sq(N2_r(tt,:,myJ,myI)));hold on;plot(z_r,N20(myBest,:),'r');title('N2 versus "best fit" from t=0')
%
% % blue is calculated on the fly, green is my "best guess", red is just
% % sticking with the original x,y
% fig(53);clf;plot(z_r,sq(W(:,tt,:))','b');hold on;plot(z_r,sq(W0(:,myBest,:))','g');plot(z_r,sq(W0(:,myLoc,:))','r');title('Compare w modes')
%
% fig(54);clf;plot(z_r,sq(N2_r(tt,:,myJ,myI)),'LineWidth',3);hold on;plot(z_r,N20(1:15:length(jDepth),:)');title('N2 versus "best fit" from t=0')
%
%
% aaa=5;

