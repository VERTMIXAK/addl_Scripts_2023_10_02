clear;

fileIn  = 'HYCOM_2013_2014_bdry_BoB2_2km.nc_noChannels';
fileOut = 'HYCOM_2013_2014_bdry_BoB2_2km.nc';

times=nc_varget(fileIn,'ocean_time');
nt = length(times)

dt = (times(2)-times(1))*24    % time step in hours

nb = 9;


%%

z_west_ORIG = nc_varget(fileIn,'zeta_west');done('ORIG')
dat_ORIG = z_west_ORIG(1:nt,350);

% screw around with 1/win until you get below S1

win = 12;

[dat_smoo_dum]=hls_lowpassbutter(dat_ORIG,1/win,1,9);
[f,G_ORIG]=hls_spectra(dat_ORIG);
[f,G_smoo_dum]=hls_spectra(dat_smoo_dum);

figure(99);clf
subplot(2,1,1)
semilogy(f/3,G_ORIG,'b');hold on;
semilogy(f/3,G_smoo_dum,'k');hold on;
legend('orig','di,')
plot([1 1]/12.42,[1e-3 1e0])
plot([1 1]/24,[1e-3 1e0]);ylim([1e-12,1e2])

text(1/12.42,1,'M2')
text(1/24,1,'S1')

subplot(2,1,2)
plot(3*(1:nt)/24,dat_ORIG,'b');hold on
plot(3*(1:nt)/24,dat_smoo_dum,'k');

aaa=5;

%%




% The guts of this script is a custom low-pass filter
%
%   new(:,ii) = hls_lowpassbutter(old(:,ii),1/win,1,nb);
%
% where (from the help file)
%   [d]=lowpass(dat,flo,delt,n)
%  
%   lowpass a time series with a n order butterworth filter
%  
%   dat  = input time series
%   flo  = highpass corner frequency
%   delt = sampling interval of data
%   n    =  butterworth filter order
% If flo is the highpass corner freq then win = 1/flo must be the highpass
% corner period, which is 4 days for the daily HYCOM source as I received
% this script.
%
% As written, a 3-hour sampling (the frinkiac data) gives 
%       win = 1/(36/3) = 1/12
% which is obviously wrong because it must be true that
%       0 < 1/win < 1
% Perhaps I should try to make the highpass corner period fixed, so win
% equals however many intervals add up to 4 days, like this:
%       win = 4* 24/dt
% or
%       1/win = dt / (4 * 24) where dt is in hours
% So can I interpret 1/win as 1/4 of a day?


% win = 4* 24/dt

% original code
% if dt==24;
%     win = 4*dt/24   ;else
%     win = 1/(36/dt);
% end

%% make variable list

varNames={'zeta_north' ...
'zeta_south' ...
'zeta_east' ...
'zeta_west' ...
'temp_north' ...
'temp_south' ...
'temp_east' ...
'temp_west' ...
'salt_north' ...
'salt_south' ...
'salt_east' ...
'salt_west' ...
'u_north' ...
'u_south' ...
'u_east' ...
'u_west' ...
'ubar_north' ...
'ubar_south' ...
'ubar_east' ...
'ubar_west' ...
'v_north' ...
'v_south' ...
'v_east' ...
'v_west' ...
'vbar_north' ...
'vbar_south' ...
'vbar_east' ...
'vbar_west'};

%%

for vv=1:length(varNames)
    old = nc_varget(fileIn,varNames{vv} );
    new = old;
    [~,nvar] = size(size(old));
    varNames{vv}
    if nvar==2
        [nt,nx] = size(old);
        for ii=1:nx
            new(:,ii) = hls_lowpassbutter(old(:,ii),1/win,1,nb); 
        end;
    else
        [nt,nz,nx] = size(old);
        for ii=1:nx; for zz=1:nz
            new(:,zz,ii) = hls_lowpassbutter(old(:,zz,ii),1/win,1,nb); 
        end;end;
    end;
    
    nc_varput(fileOut,varNames{vv},new);
end;

file_smoo = fileOut;
file_ORIG = fileIn;
%%
z_west_ORIG = nc_varget(file_ORIG,'zeta_west');done('ORIG')
z_west_smoo = nc_varget(file_smoo,'zeta_west');done('smoo')
%%
dat_ORIG = z_west_ORIG(1:60,350);
dat_smoo = z_west_smoo(1:60,350);
[dat_smoo_hls]=hls_lowpassbutter(dat_ORIG,1/win,1,9);
[f,G_ORIG]=hls_spectra(dat_ORIG);
[f,G_smoo]=hls_spectra(dat_smoo);
[f,G_smoo_hls]=hls_spectra(dat_smoo_hls);
figure(2);clf
subplot(2,1,1)
semilogy(f/3,G_ORIG,'b');hold on;
semilogy(f/3,G_smoo_hls,'k');hold on;
semilogy(f/3,G_smoo,'r');hold on;
legend('orig','hls','JGP')
plot([1 1]/12.42,[1e-3 1e0])
plot([1 1]/24,[1e-3 1e0]);ylim([1e-12,1e2])

text(1/12.42,1,'M2')
text(1/24,1,'S1')

subplot(2,1,2)
plot(3*(1:60)/24,dat_ORIG,'b');hold on
plot(3*(1:60)/24,dat_smoo,'r');hold on
plot(3*(1:60)/24,dat_smoo_hls,'k');


%%

% fig(3);clf;
% 
% % dat_ORIG = z_west_ORIG(1:60,350);
% % dat_smoo = z_west_smoo(1:60,350);
% [dat_smoo_hls]=hls_lowpassbutter(dat_ORIG,1/win,1,9);
% [f,G_ORIG]=hls_spectra(dat_ORIG);
% [f,G_smoo]=hls_spectra(dat_smoo);
% [f,G_smoo_hls]=hls_spectra(dat_smoo_hls);
% 
% subplot(2,1,1)
% semilogy(f/3,G_ORIG,'b');hold on;
% semilogy(f/3,G_smoo_hls,'k');hold on;
% semilogy(f/3,G_smoo,'r');hold on;
% legend('orig','hls','JGP')
% plot([1 1]/12.42,[1e-3 1e0])
% plot([1 1]/24,[1e-3 1e0]);ylim([1e-12,1e2])
% subplot(2,1,2)
% plot(3*(1:60)/24,dat_ORIG,'b');hold on
% plot(3*(1:60)/24,dat_smoo,'r');hold on
% plot(3*(1:60)/24,dat_smoo_hls,'k');


%%

% fig(4);clf
% 
% [dat_smoo_dum]=hls_lowpassbutter(dat_ORIG,1/win,1,9);
% [f,G_ORIG]=hls_spectra(dat_ORIG);
% [f,G_smoo_dum]=hls_spectra(dat_smoo_dum);
% 
% 
% subplot(2,1,1)
% semilogy(f/3,G_ORIG,'b');hold on;
% semilogy(f/3,G_smoo_dum,'k');hold on;
% legend('orig','di,')
% plot([1 1]/12.42,[1e-3 1e0])
% plot([1 1]/24,[1e-3 1e0]);ylim([1e-12,1e2])
% 
% text(1/12.42,1,'M2')
% text(1/24,1,'S1')
% 
% subplot(2,1,2)
% plot(3*(1:60)/24,dat_ORIG,'b');hold on
% plot(3*(1:60)/24,dat_smoo_dum,'k');
