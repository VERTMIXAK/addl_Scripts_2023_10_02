function [c,u,v,w,p,rho,eta]=VERT_STRUCTURE(z,N2,f,nmode,F,omega,ifnonhydrostatic)
%USAGE: [c,u,v,w,p,rho,eta]=VERT_STRUCTURE(z,N2,f,nmode,F,omega)
%
%Produces vertical stucture functions for a nonhydrostatic, inviscid, stratified,
%f-plane, un-sheared, Boussinesq fluid, with omega frequency and rigid lid boundary 
%conditions.  Much can be explained from Gill pp.253,256-263 and Kundu.
%
%INPUTS
% z = vertical coordinate vector (evenly spaced, negative)
% N2 = buoyancy frequency squared at each z coordinate
% f = Coriolis frequency in radians/second
% nmode = mode selection in terms of zero crossings, vector
% F = Depth integrated horizontal energy flux in x-direction (scales all eigenfunctions accordingly)
% omega = wave frequency in radians/second, default is M2 frequency
%
%OUTPUTS
% c = omega/k, propogation speed (m/s)
% u = horizontal velocity eigenfunction parallel to direction of propogation 
% v = horizontal velocity eigenfunction perpendicular to direction of propogation
% w = vertical velocity eigenfunction
% p = pressure perturbation eigenfunction
% rho = density perturbation eigenfunction
% eta = surface perturbation
%       NOTE: the solutions are plane waves in time and the horixontal, so 
%           the full u-velocity field is u=real(u.*exp(i*(kx-omega*t)))
%
% Sam Kelly 3/21/07
%
% Harper Simmons June 6, 2012
% ifnonhydrostatic is a flag that turns of hydrostatic vs nonhydrastic
% contributions. See line 59 where alpha is computed

%% Stage 1: Preliminaries
if nargin<6
    omega=0.080511401*2*pi/3600;% ~M2 frequency rad/sec
end

if size(z,1)==1; z=z'; end
if size(N2,1)==1; N2=N2'; end

ii=complex(0.,1.);
del=(z(2)-z(1));
N=length(z);
g=9.81;
rho0=1030;

%% Stage 2: Set up derivative matrices (2nd order accurate finite difference)
D2=zeros(N,N);
for n=2:N-1
    D2(n,n-1) = 1.;
    D2(n,n) = -2.;
    D2(n,n+1) = 1.;
end

% Boundary conditions: rigid lid
D2(1,:)=0;D2(1,1)=-2;D2(1,2)=1;
D2(N,:)=0;D2(N,N)=-2;D2(N,N-1)=1;
D2 = D2/del^2;

%% Stage 3: Set up stabilty matricies and solve eigenvalue problem
% Eigenvalue problem: -(omega^2-f^2)/(N^2-omega^2)*D2*w_hat=k^2*w_hat 
alpha=-(omega^2-f^2)./(N2-ifnonhydrostatic*omega^2); % 0* omega^2 removes nonhydrostatic contribution
A=diag(alpha.^-1);

% Solve generalized eigenvalue problem
[w k_sq]=eig(D2,A);
k_sq=diag(k_sq);
c=omega*(k_sq.^-.5);
k=k_sq.^.5;
[sr,ind]=sort(c,1,'descend');
c=c(ind);
k=k(ind);
w=w(:,ind);

% Save the mode selected via nmode
c=c(nmode);
k=k(nmode);
w=w(:,nmode);
w=w./repmat(max(abs(w)),length(z),1);
w=real(w);
for n=1:size(w,2)
    if abs(min(w(:,n)))>max(w(:,n)); w(:,n)=-w(:,n); end
end

%% Stage 4: Compute first derivative matrix 
% Make a first derivative matrix
D=zeros(N,N);
for n=2:N-1
    D(n,n-1)=-1.;
    D(n,n+1)=1.;
end

% Boundary conditions (one sided/open)
D(1,1)=-3;D(1,2)=4;D(1,3)=-1.;
D(N,N)=3;D(N,N-1)=-4.;D(N,N-2)=1;
D=D/(2*del);

%% Stage 5: Scale w to match inputed F
wz=D*w;

A=((2*F*omega*k'.^3)./(rho0*(omega^2-f^2).*sum(del*wz.^2,1))).^(1/2);
A=repmat(A,length(z),1);
w=A.*w;
wz=D*w;

%% Stage 6: Compute other relations
u=repmat((ii./k)',length(z),1).*wz;
v=-ii*f/omega*u;
p=repmat(rho0*(omega^2-f^2)./(k*omega)',length(z),1).*u;
%p=repmat(rho0./(ii*k)',length(z),1).*(ii*omega*u+f*v);
rho=-(rho0/g)*(-ii*omega*w+D*p/rho0);
%rho=rho0*repmat((ii*N2/(g*omega)),1,length(nmode)).*w; 
eta=p(1,:)/(g*rho0);

return 
end





