clear;



% %% get all the 2D data
% 
% data = './source.mat'
% 
% if ~exist(data)
%     
%     % Load MERRA
%     
%     leadin = '../../PALAU_0.0083_2014_310.5_NoTides_30days_meso_QMERRA/HIS2_singlets_long/';
%     
%     tempMERRA      = nc_varget([leadin,'temp.nc']    ,'temp'    );
%     saltMERRA      = nc_varget([leadin,'salt.nc']    ,'salt'    );
%     
%     latentMERRA    = nc_varget([leadin,'latent.nc']  ,'latent'  );
%     sensibleMERRA  = nc_varget([leadin,'sensible.nc'],'sensible');
%     
%     shfluxMERRA    = nc_varget([leadin,'shflux.nc']  ,'shflux'  );
%     ssfluxMERRA    = nc_varget([leadin,'ssflux.nc']  ,'ssflux'  );
%     
%     swradMERRA     = nc_varget([leadin,'swrad.nc']   ,'swrad'   );
%     lwradMERRA     = nc_varget([leadin,'lwrad.nc']   ,'lwrad'   );
%     
%     uwindMERRA     = nc_varget([leadin,'uwind.nc']   ,'Uwind'   );
%     vwindMERRA     = nc_varget([leadin,'vwind.nc']   ,'Vwind'   );
%     
%     sustrMERRA     = nc_varget([leadin,'sustr.nc']   ,'sustr'   );
%     svstrMERRA     = nc_varget([leadin,'svstr.nc']   ,'svstr'   );
%     
%     mask_rho = nc_varget([leadin,'masks.nc'],'mask_rho');
%     mask_u = nc_varget([leadin,'masks.nc'],'mask_u');
%     mask_v = nc_varget([leadin,'masks.nc'],'mask_v');
%     
%     [NtMERRA dumy dumx] = size(tempMERRA);
%     
%     tempAveMERRA     = zeros(NtMERRA,1);
%     saltAveMERRA     = zeros(NtMERRA,1);
%     
%     latentAveMERRA   = zeros(NtMERRA,1);
%     sensibleAveMERRA = zeros(NtMERRA,1);
%     
%     lwradAveMERRA    = zeros(NtMERRA,1);
%     swradAveMERRA    = zeros(NtMERRA,1);
%     
%     shfluxAveMERRA   = zeros(NtMERRA,1);
%     shfluxAveMERRA   = zeros(NtMERRA,1);
%     
%     uwindAveMERRA    = zeros(NtMERRA,1);
%     vwindAveMERRA    = zeros(NtMERRA,1);
%     
%     sustrAveMERRA    = zeros(NtMERRA,1);
%     svstrAveMERRA    = zeros(NtMERRA,1);
%     
%     % Load UH
%     
%     leadin = '../../PALAU_0.0083_2014_310.5_NoTides_30days_meso_QUH/HIS2_singlets_long/';
%     
%     tempUH      = nc_varget([leadin,'temp.nc']    ,'temp'    );
%     saltUH      = nc_varget([leadin,'salt.nc']    ,'salt'    );
%     
%     latentUH    = nc_varget([leadin,'latent.nc']  ,'latent'  );
%     sensibleUH  = nc_varget([leadin,'sensible.nc'],'sensible');
%     
%     shfluxUH    = nc_varget([leadin,'shflux.nc']  ,'shflux'  );
%     ssfluxUH    = nc_varget([leadin,'ssflux.nc']  ,'ssflux'  );
%     
%     swradUH     = nc_varget([leadin,'swrad.nc']   ,'swrad'   );
%     lwradUH     = nc_varget([leadin,'lwrad.nc']   ,'lwrad'   );
%     
%     uwindUH     = nc_varget([leadin,'uwind.nc']   ,'Uwind'   );
%     vwindUH     = nc_varget([leadin,'vwind.nc']   ,'Vwind'   );
%     
%     sustrUH     = nc_varget([leadin,'sustr.nc']   ,'sustr'   );
%     svstrUH     = nc_varget([leadin,'svstr.nc']   ,'svstr'   );
%     
%     [NtUH dumy dumx] = size(tempUH);
%     
%     tempAveUH     = zeros(NtUH,1);
%     saltAveUH     = zeros(NtUH,1);
%     
%     latentAveUH   = zeros(NtUH,1);
%     sensibleAveUH = zeros(NtUH,1);
%     
%     lwradAveUH    = zeros(NtUH,1);
%     swradAveUH    = zeros(NtUH,1);
%     
%     shfluxAveUH   = zeros(NtUH,1);
%     shfluxAveUH   = zeros(NtUH,1);
%     
%     uwindAveUH    = zeros(NtUH,1);
%     vwindAveUH    = zeros(NtUH,1);
%     
%     sustrAveUH    = zeros(NtUH,1);
%     svstrAveUH    = zeros(NtUH,1);
%     
%     save data
%     
% else
%     load data
% end
%     
% %% Find the means
% 
% for tt=1:NtMERRA
%     dum = sq(tempMERRA(tt,:,:));
%     tempAveMERRA(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(saltMERRA(tt,:,:));
%     saltAveMERRA(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(latentMERRA(tt,:,:));
%     latentAveMERRA(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(sensibleMERRA(tt,:,:));
%     sensibleAveMERRA(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(shfluxMERRA(tt,:,:));
%     shfluxAveMERRA(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(ssfluxMERRA(tt,:,:));
%     ssfluxAveMERRA(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(lwradMERRA(tt,:,:));
%     lwradAveMERRA(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(swradMERRA(tt,:,:));
%     swradAveMERRA(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(uwindMERRA(tt,:,:));
%     uwindAveMERRA(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(vwindMERRA(tt,:,:));
%     vwindAveMERRA(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(sustrMERRA(tt,:,:));
%     sustrAveMERRA(tt) = mean(dum(find(mask_u==1)));
%     dum = sq(svstrMERRA(tt,:,:));
%     svstrAveMERRA(tt) = mean(dum(find(mask_v==1)));
% end
% 
% 
% for tt=1:NtUH
%     dum = sq(tempUH(tt,:,:));
%     tempAveUH(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(saltUH(tt,:,:));
%     saltAveUH(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(latentUH(tt,:,:));
%     latentAveUH(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(sensibleUH(tt,:,:));
%     sensibleAveUH(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(shfluxUH(tt,:,:));
%     shfluxAveUH(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(ssfluxUH(tt,:,:));
%     ssfluxAveUH(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(lwradUH(tt,:,:));
%     lwradAveUH(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(swradUH(tt,:,:));
%     swradAveUH(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(uwindUH(tt,:,:));
%     uwindAveUH(tt) = mean(dum(find(mask_rho==1)));
%     dum = sq(vwindUH(tt,:,:));
%     vwindAveUH(tt) = mean(dum(find(mask_rho==1)));
% 
%     dum = sq(sustrUH(tt,:,:));
%     sustrAveUH(tt) = mean(dum(find(mask_u==1)));
%     dum = sq(svstrUH(tt,:,:));
%     svstrAveUH(tt) = mean(dum(find(mask_v==1)));
% end

%% Make Plots


if ~exist('averages.mat')
    eval(['save ','averages ','NtMERRA NtUH tempAveMERRA saltAveMERRA latentAveMERRA sensibleAveMERRA lwradAveMERRA swradAveMERRA ssfluxAveMERRA shfluxAveMERRA uwindAveMERRA vwindAveMERRA sustrAveMERRA svstrAveMERRA tempAveUH saltAveUH latentAveUH sensibleAveUH lwradAveUH swradAveUH ssfluxAveUH shfluxAveUH uwindAveUH vwindAveUH sustrAveUH svstrAveUH'])
else
    load('averages')
end


%pcolor(sq(temp(1,:,:)));shading flat


fig(1);clf;plot( [1:NtMERRA]/24,tempAveMERRA,    [1:NtUH]/24,tempAveUH);
title('surface temperature');xlabel('days');ylabel('degrees C');%done('1')
legend({'MERRA','UH'},'Location','southeast')

fig(2);clf;plot( [1:NtMERRA]/24,saltAveMERRA,    [1:NtUH]/24,saltAveUH);
title('surface salinity');xlabel('days');ylabel('salt units');%done('2')
legend({'MERRA','UH'},'Location','southeast')


fig(3);clf;plot( [1:NtMERRA]/24,latentAveMERRA,  [1:NtUH]/24,latentAveUH);
title('latent - surface net latent heat flux');xlabel('days');ylabel('W/m^2');%done('3')
legend({'MERRA','UH'},'Location','southeast')

fig(4);clf;plot( [1:NtMERRA]/24,sensibleAveMERRA, [1:NtUH]/24,sensibleAveUH);
title('sensible - surface net sensible heat flux');xlabel('days');ylabel('W/m^2');%done('4')
legend({'MERRA','UH'},'Location','southeast')


fig(5);clf;plot( [1:NtMERRA]/24,lwradAveMERRA,    [1:NtUH]/24,lwradAveUH);
title('lwrad - surface net longwave flux');xlabel('days');ylabel('W/m^2');%done('5')
legend({'MERRA','UH'},'Location','southeast')

fig(6);clf;plot( [1:NtMERRA]/24,swradAveMERRA,    [1:NtUH]/24,swradAveUH);
title('swrad - surface shortwave flux');xlabel('days');ylabel('W/m^2');%done('6')
legend({'MERRA','UH'},'Location','southeast')


fig(7);clf;plot( [1:NtMERRA]/24,shfluxAveMERRA,   [1:NtUH]/24,shfluxAveUH);
title('shflux - surface net heat flux');xlabel('days');ylabel('W/m^2')
legend({'MERRA','UH'},'Location','southeast')

fig(8);clf;plot( [1:NtMERRA]/24,ssfluxAveMERRA,   [1:NtUH]/24,ssfluxAveUH);
title('ssflux - surface net salt flux');xlabel('days');ylabel('salt units per m^2')
legend({'MERRA','UH'},'Location','southeast')


fig(9); clf;plot( [1:NtMERRA]/24,vwindAveMERRA,   [1:NtUH]/24,vwindAveUH);
title('vwind');xlabel('days');ylabel('m/s')
legend({'MERRA','UH'},'Location','southeast')

fig(10);clf;plot( [1:NtMERRA]/24,uwindAveMERRA,   [1:NtUH]/24,uwindAveUH);
title('uwind');xlabel('days');ylabel('m/s')
legend({'MERRA','UH'},'Location','southeast')



fig(11);clf;plot( [1:NtMERRA]/24,sustrAveMERRA,   [1:NtUH]/24,sustrAveUH);
title('sustr - surface u-momentum stress');xlabel('days');ylabel('N/m^2')
legend({'MERRA','UH'},'Location','southeast')

fig(12);clf;plot( [1:NtMERRA]/24,svstrAveMERRA,   [1:NtUH]/24,svstrAveUH);
title('svstr - surface v-momentum stress');xlabel('days');ylabel('N/m^2')
legend({'MERRA','UH'},'Location','southeast')



dQMERRA = latentAveMERRA + sensibleAveMERRA + lwradAveMERRA + swradAveMERRA - shfluxAveMERRA;
dQUH    = latentAveUH    + sensibleAveUH    + lwradAveUH    + swradAveUH    - shfluxAveUH;
fig(13);clf;plot( [1:NtMERRA]/24,dQMERRA,         [1:NtUH]/24,dQUH);
title('shflux - ( latent + sensible + swrad + lwrad )');xlabel('days');ylabel('W/m^2')
legend({'MERRA','UH'},'Location','southeast')

% Redo a few of the plots

latentGlobalMERRA = mean(latentAveMERRA);
latentGlobalUH = mean(latentAveUH);
fig(3);clf;plot( [1:NtMERRA]/24,latentAveMERRA,     [1:NtUH]/24,latentAveUH);
title('latent - surface net latent heat flux');xlabel('days');ylabel('W/m^2');hold on;
plot([1,NtMERRA]/24,[latentGlobalMERRA,latentGlobalMERRA],'--',[1,NtUH]/24,[latentGlobalUH,latentGlobalUH],'--')
legend({['MERRA ',num2str(round(latentGlobalMERRA))],['UH        ',num2str(round(latentGlobalUH))]},'Location','southeast')

sensibleGlobalMERRA = mean(sensibleAveMERRA);
sensibleGlobalUH = mean(sensibleAveUH);
fig(4);clf;plot( [1:NtMERRA]/24,sensibleAveMERRA,     [1:NtUH]/24,sensibleAveUH);
title('sensible - surface net sensible heat flux');xlabel('days');ylabel('W/m^2');hold on;
plot([1,NtMERRA]/24,[sensibleGlobalMERRA,sensibleGlobalMERRA],'--',[1,NtUH]/24,[sensibleGlobalUH,sensibleGlobalUH],'--')
legend({['MERRA ',num2str(round(sensibleGlobalMERRA))],['UH        ',num2str(round(sensibleGlobalUH))]},'Location','southeast')


lwradGlobalMERRA = mean(lwradAveMERRA);
lwradGlobalUH = mean(lwradAveUH);
fig(5);clf;plot( [1:NtMERRA]/24,lwradAveMERRA,     [1:NtUH]/24,lwradAveUH);
title('lwrad - surface net lwrad flux');xlabel('days');ylabel('W/m^2');hold on;
plot([1,NtMERRA]/24,[lwradGlobalMERRA,lwradGlobalMERRA],'--',[1,NtUH]/24,[lwradGlobalUH,lwradGlobalUH],'--')
legend({['MERRA ',num2str(round(lwradGlobalMERRA))],['UH        ',num2str(round(lwradGlobalUH))]},'Location','southeast')

swradGlobalMERRA = mean(swradAveMERRA);
swradGlobalUH = mean(swradAveUH);
fig(6);clf;plot( [1:NtMERRA]/24,swradAveMERRA,     [1:NtUH]/24,swradAveUH);
title('swrad - surface net swrad flux');xlabel('days');ylabel('W/m^2');hold on;
plot([1,NtMERRA]/24,[swradGlobalMERRA,swradGlobalMERRA],'--',[1,NtUH]/24,[swradGlobalUH,swradGlobalUH],'--')
legend({['MERRA ',num2str(round(swradGlobalMERRA))],['UH        ',num2str(round(swradGlobalUH))]},'Location','southeast')


shfluxGlobalMERRA = mean(shfluxAveMERRA);
shfluxGlobalUH = mean(shfluxAveUH);
fig(7);clf;plot( [1:NtMERRA]/24,shfluxAveMERRA,   [1:NtUH]/24,shfluxAveUH);
title('shflux - surface net heat flux');xlabel('days');ylabel('W/m^2');hold on
plot([1,NtMERRA]/24,[shfluxGlobalMERRA,shfluxGlobalMERRA],'--',[1,NtUH]/24,[shfluxGlobalUH,shfluxGlobalUH],'--')
legend({['MERRA ',num2str(round(shfluxGlobalMERRA))],['UH        ',num2str(round(shfluxGlobalUH))]},'Location','southeast')

ssfluxGlobalMERRA = mean(ssfluxAveMERRA);
ssfluxGlobalUH = mean(ssfluxAveUH);
fig(8);clf;plot( [1:NtMERRA]/24,ssfluxAveMERRA,     [1:NtUH]/24,ssfluxAveUH);
title('ssflux - surface net salt flux');xlabel('days');ylabel('salt units per m^2');hold on
plot([1,NtMERRA]/24,[ssfluxGlobalMERRA,ssfluxGlobalMERRA],'--',[1,NtUH]/24,[ssfluxGlobalUH,ssfluxGlobalUH],'--')
legend({['','','MERRA ',num2str(round(10^8*ssfluxGlobalMERRA)/10^8)],['UH        ',num2str(round(10^8*ssfluxGlobalUH)/10^8)]},'Location','southeast')




