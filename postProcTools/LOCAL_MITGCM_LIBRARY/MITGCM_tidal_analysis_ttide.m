function [tidecon]=MITGCM_tidal_analysis_ttide(datfile,datvar,pt,MODEL,tdx,const,hskip)
%keyboard
%%
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

outfile=[MODEL.exp,'_',datvar,'_amp_pha_',const(1:2),'.mat']; 

%%
sz=nc_varsize(datfile,datvar);
if     pt==1
	sz=[sz(end-2) sz(end-1)     (sz(end)-1) ]
elseif pt==2
	sz=[sz(end-2) (sz(end-1)-1) sz(end)     ]
else
	sz=[sz(end-2) sz(end-1)     sz(end)     ]
end
%%
%const_names=['M2  ';'S2  ';'O1  ';'K1  ']

tidecon.amp = nan*ones(sz);
tidecon.pha = nan*ones(sz);
%keyboard
%%
timeS = nc_varget(datfile,'T');
timedatenum=MODEL.data.OB.timeD(1)+timeS/86400;timeH=timedatenum*24;
%%
%keyboard
for kdx=1:sz(1);disp([datvar,' level = ',num2str(kdx)]);
   dat = nc_varget(datfile,datvar,[tdx(1)-1,kdx-1,0,0],[length(tdx),1,-1,-1]);dat(dat == 0)= nan; % possibly dangerous way to mask non ocean points
   %keyboard
   if pt == 1 % we are on a u point
       dat = (dat(:,:,1:end-1)+dat(:,:,2:end))/2; 
   elseif pt == 2 % we are on a v pt
       dat = (dat(:,1:end-1,:)+dat(:,2:end,:))/2; 
   end
for ii=1:hskip:sz(3);disp(['in GOLD_calc_tidal_regress ', datvar,': kdx = ',num2str(kdx),' of ',num2str(sz(1)),' ii = ',num2str(ii),' of ',num2str(sz(3))])
for jj=1:hskip:sz(2);
%%
if MODEL.H(jj,ii) > 100 & length(find(1-isnan(dat(:,jj,ii)))) > 0
%%		for kk = 1:length(const_names)
			[name,freq,tmptidecon,~]=t_tide_silent(sq(dat(:,jj,ii)),'start_time',timedatenum(tdx(1)),'rayleigh',const,'interval',diff(timeH(1:2)),'output','none');
			%keyboard
			tname =   name(1:2);tfreq=freq;tcon = tmptidecon(:);
			eval(['tidecon.tname           = tname;']);
			eval(['tidecon.tfreq           = ',num2str(tfreq),';']);
			eval(['tidecon.amp(kdx,jj,ii)  = tcon(1);']);
			eval(['tidecon.pha(kdx,jj,ii)  = tcon(3);']);
%		end
	end;% D test
end % jj
		 %%
end % ii
end
README = 'blah blah blah';
disp(['save ',MODEL.base,MODEL.exp,'/saves/',outfile,'  -v7.3 tidecon time* MODEL README'])
eval(['save ',MODEL.base,MODEL.exp,'/saves/',outfile,'  -v7.3 tidecon time* MODEL README'])
