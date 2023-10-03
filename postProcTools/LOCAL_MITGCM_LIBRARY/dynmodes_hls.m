function [wmodes,pmodes,ke]=dynmodes(Nsq,z,OB)
%function [wmodes,pmodes,w,wz,wzz,ke]=dynmodes(Nsq,z,OB)



% DYNMODES calculates ocean dynamic vertical modes
%  taking a column vector of Brunt-Vaisala values (Nsq) at
%  different pressures (p) and calculating some number of
%  dynamic modes (nmodes).
%  Note: The input pressures need not be uniformly spaced,
%    and the deepest pressure is assumed to be the bottom.
%
%  USAGE: [wmodes,pmodes,ce]=dynmodes(Nsq,p,nmodes);
%                               or
%                            dynmodes;  % to show demo
%
%     Inputs: 	Nsq = column vector of Brunt-Vaisala buoyancy frequency (s^-2)
%		    	  p = column vector of pressure (decibars)
%           nmodes = number of vertical modes to calculate
%
%       Outputs:   wmodes = vertical velocity structure
%                  pmodes = horizontal velocity structure
%                      ce = modal speed (m/s)
%  developed by J. Klinck. July, 1999
%  send comments and corrections to klinck@ccpo.odu.edu
%  modifiled by H. Simmons 2012

%JGP  NOTE:  I have configured this routine so that it receives numbers
% (Nsq and z) on a denser grid than the one in gendata.m.  Specifically,
% the z grid contains the cell centers AND the cell faces.  gendata.m
% really only wants the cell centers so the very end of this routine cuts
% the internally generated wmodes and pmodes down to just the cell center
% points.


nz=length(z);

%          calculate depths and spacing
%        spacing
dz(1:nz-1)=z(1:nz-1)-z(2:nz);
%        midpoint depth
zm(1:nz-1)=z(1:nz-1)-.5*dz(1:nz-1)';
%        midpoint spacing
dzm=zeros(1,nz);
dzm(2:nz-1)=zm(1:nz-2)-zm(2:nz-1);
dzm(1)=dzm(2);
dzm(nz)=dzm(nz-1);

%        get dynamic modes
D2 = zeros(nz,nz);
B = zeros(nz,nz);
%             create second derivative matrix
for i=2:nz-1
    D2(i,i-1) = -1/(dz(i-1)*dzm(i));
    
    D2(i,i  ) = +1/(dz(i-1)*dzm(i))  + 1/(dz(i)*dzm(i));
    D2(i,i+1) = -1/(dz(i)*dzm(i));
end



% Solve the ODE
%    w'' +  ke^2 N^2 / (omega^2 - f^2) = 0

for i=1:nz
    %B(i,i)=N2(i); % orig
    B(i,i)=Nsq(i);        %JGP use this for multi-mode forcing
    %B(i,i)=Nsq(i);%/(omega^2-f^2);
    %B(i,i)=Nsq(i)/(OB.omegaS^2-OB.omegaCoriolis^2);   %JGP used to be this
end

%             set boundary conditions
D2(1 ,1) =-1.; % rigid lid   % HLSrho0ofZ
D2(nz,1) =-1.; % flat bottom % HLS
%
[wFull,keSq] = eig(D2,B);

%          extract eigenvalues  and sort
keSq=diag(keSq);
%
ind=find(imag(keSq)==0);
keSq=keSq(ind);
wFull=wFull(:,ind);
%
ind=find(keSq>=1.e-10);
keSq=keSq(ind);
wFull=wFull(:,ind);
%
[keSq,ind]=sort(keSq);
wFull=wFull(:,ind);

nm=length(keSq);
for idum=1:nm
    wFull(:,idum)= - wFull(:,idum) * sign(wFull(2,idum));
end;

ke= keSq.^(1/2);

%  Calculate first deriv wrt z of wmodes

for i=1:nm
    %           calculate first deriv of vertical modes
    pr(:,i)=diff(wFull(:,i));
    pr(1:nz-1,i)= pr(1:nz-1,i)./dz(1:nz-1)';
    %       linearly interpolate back to original depths
    wzFull(2:nz-1,i)=.5*(pr(2:nz-1,i)+pr(1:nz-2,i));
    wzFull(1,i)=pr(1,i);
    wzFull(nz,i)=pr(nz-1,i);
end

% Rescale the wmodes so that each mode conforms to the desired
% depth-integrated energy flux F

dzmat=repmat(dz',1,nm);
%JGP A=((2*OB.flux_mag*OB.omegaS*ke'.^3)./(OB.rho0*(OB.omegaS^2-OB.omegaCoriolis^2).*sum(dzmat.*pr.^2,1))).^(1/2);
A=((2*OB.flux_mag*ke'.^3)./(OB.rho0.*sum(dzmat.*pr.^2,1))).^(1/2);
A=repmat(abs(A),nz,1);

wFull=wFull.*A;
wzFull=wzFull.*A;

%  Calculate second deriv of wmodes wrt z

for i=1:nm
    %           calculate first deriv of vertical modes
    pr(:,i)=diff(wzFull(:,i));
    pr(1:nz-1,i)= pr(1:nz-1,i)./dz(1:nz-1)';
    %       linearly interpolate back to original depths
    wzzFull(2:nz-1,i)=.5*(pr(2:nz-1,i)+pr(1:nz-2,i));
    wzzFull(1,i)=pr(1,i);
    wzzFull(nz,i)=pr(nz-1,i);
end

% Calculate the pmodes
%JGP pFull=repmat(OB.rho0*(OB.omegaS^2-OB.omegaCoriolis^2)./(ke.^2)',nz,1).*wzFull;
pFull=repmat(OB.rho0./(ke.^2)',nz,1).*wzFull;

%Optional rescaling scheme for the full pmodes (as opposed to scaling the
%pmodes, which don't have a point on the ocean surface
[pnz pnModes] = size(pFull);

% option to include barotropic pmode
pFull=[1+0*pFull(:,1) pFull];        % shoe horn in the barotropic mode
pnModes=pnModes+1;

for ii=1:pnModes
    pFull(:,ii)=pFull(:,ii)/pFull(1,ii);
    %pmodes(:,ii)=pmodes(:,ii)/norm(pmodes(:,ii));
    %wmodes(:,ii)=wmodes(:,ii)/max(abs(wmodes(:,ii)));
end;


% Return only the numbers that are on the Cell-center grid

wmodes=wFull(2:2:end,:);
[nw dum]=size(wmodes);
wmodes=wmodes(:,1:nw);
% % % wmodes=wFull;

%w=wFull(2:2:end,:);
%[nw dum]=size(w);
%w=w(:,1);


%wz=wzFull(2:2:end,:);
%[nw dum]=size(wz);
%wz=wz(:,1);

%wzz=wzzFull(2:2:end,:);
%[nw dum]=size(wzz);
%wzz=wzz(:,1);

pmodes=pFull(2:2:end,:);
[np dum]=size(pmodes);

pmodes=pmodes(:,1:np);
% % % pmodes=pFull;



%Optional rescaling scheme for the pmodes
% for ii=1:np
%     pmodes(:,ii)=pmodes(:,ii)/pmodes(1,ii);
%     %pmodes(:,ii)=pmodes(:,ii)/norm(pmodes(:,ii));
%     wmodes(:,ii)=wmodes(:,ii)/max(abs(wmodes(:,ii)));
% end;

% DO NOT skip every other value for k!
% NOTE: the barotropic mode doesn't get a ke
% ke=ke(1:length(pmodes)-1);
% % % ke=ke(1:length(pmodes));

aaa=5;      % a stopping place for the debuggerer


