function [amp,pha,omega,time]=MITgcm_calc_regress(datfile,datvar,pt,MODEL,omega,tdx,consts)
% puts u and v onto rho points using the pt flag.
% pt == 1 is a u point
% pt == 2 is a v point
% pt == 0 is a rho point, do nothing.

% frequencies we fit 
%T=[];
%T.O1   =1./0.0387307;  
%T.K1   =1./0.0417807; 
%T.M2   =1./0.0805114;  
%T.S2   =1./0.0833333;  
%omega = [1/T.S2 1/T.M2 1/T.O1 1/T.K1];   % [cycles per hour]

outfile=[MODEL.exp,'_',datvar,'_amp_pha_',consts,'.mat']; 

sz=[length(omega) length(MODEL.RC) size(MODEL.H)]
%%
sz=nc_varsize(datfile,datvar);
if     pt==1
	sz=[length(omega) sz(end-2) sz(end-1)     (sz(end)-1) ]
elseif pt==2
	sz=[length(omega) sz(end-2) (sz(end-1)-1) sz(end)     ]
else
	sz=[length(omega) sz(end-2) sz(end-1)     sz(end) ]
end
%%

amp = nan*ones(sz);
pha = nan*ones(sz);

time=nc_varget(datfile,'T',[tdx(1)-1],length(tdx))/3600;
time=nc_varget(datfile,'T')/3600;
%keyboard
timeD=MODEL.data.OB.timeD(1)+nc_varget(datfile,'T')/86400;timeH=timeD(tdx)*24;
%keyboard
for kdx=1:sz(2);disp([datvar,' level = ',num2str(kdx)]);
   dat = nc_varget(datfile,datvar,[tdx(1)-1,kdx-1,0,0],[length(tdx),1,-1,-1]);dat(dat == 0)= nan; % possibly dangerous way to mask non ocean points
   %keyboard
   if pt == 1 % we are on a u point
       dat = (dat(:,:,1:end-1)+dat(:,:,2:end))/2; 
   elseif pt == 2 % we are on a v pt
       dat = (dat(:,1:end-1,:)+dat(:,2:end,:))/2; 
   end
	for jj = 1:sz(3);
		[amp(:,kdx,jj,:),pha(:,kdx,jj,:)]=harmonic_fit(timeH,sq(dat(:,jj,:)),omega);	
	end;
end
README = 'amp and phase are dimensioned nomega * nz * ny * nx, omega is in the units of 1/time';
disp(['save ',MODEL.base,MODEL.exp,'/saves/',outfile,'  -v7.3 amp pha omega time* MODEL README'])
eval(['save ',MODEL.base,MODEL.exp,'/saves/',outfile,'  -v7.3 amp pha omega time* MODEL README'])
