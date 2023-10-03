
%Add in F_bp, C_bp, F_tide_regress, C_tide_regress
%%
clear;

for ii=1%:3
    clear roms;
    
    %     roms.exp = 'TS';roms.res = '_0.125';
    roms.dirname=pwd;
    cd ..
    [dum1,dum2] = unix('pwd | rev | cut -d "/" -f1 | rev');
    roms.exp1 = dum2(1:length(dum2)-1);
    [dum1,dum2] = unix('pwd | rev | cut -d "/" -f1 | rev |cut -d "_" -f3');
    roms.year = dum2(1:length(dum2)-1);
    [dum1,dum2] = unix('pwd | rev | cut -d "/" -f1 | rev |cut -d "_" -f1');
    roms.exp = dum2(1:length(dum2)-1);
    [dum1,dum2] = unix('pwd | rev | cut -d "/" -f1 | rev |cut -d "_" -f2');
    roms.res = dum2(1:length(dum2)-1);
    cd ../../..
    [dum1,dum2] = unix('pwd');
    roms.base1 = dum2(1:length(dum2)-1);
    cd(roms.dirname)
        
    if strcmp(roms.exp,'TS')==1
        roms.lon0 = 146;roms.lon1 = 169;roms.lat0 = -55;roms.lat1 = -38 ;
    end;
    
    if strcmp(roms.exp,'SCS')==1
        roms.lon0 = 113.5;roms.lon1 = 128;roms.lat0 = 16.5;roms.lat1 = 25 ; 
    end;    
    
    roms.latlonRange =  [num2str(roms.lon0),'_',num2str(roms.lon1),'_',num2str(roms.lat0),'_',num2str(roms.lat1)];
    roms.nm=3;
    roms.expbase   = [roms.exp,'_',roms.res];
    %     roms.analysis_loc = 'hsimmons'
    %     roms.analysis_loc = 'jpender'
    roms.analysis_path='../Analysis/';
       
    if ii == 1;
        if length( strfind(roms.exp1,'tidesOnly') ) == 1  ;
            roms.type='tideonly';
        else
            roms.type='meso+tides';
        end;end;
    roms = ROMS_get_files_JGP(roms);
    ROMS_F_hp_helper_m(roms);done('ROMS_F')
    ROMS_C_hp_helper_m(roms);done('ROMS_C')
    done
end
%%
% now plot it
% expname = 'TS_0.125_2013_001_TidesM2_10plus5_meso';
% base = '/import/c/w/hsimmons/roms-kate_svn/TS_0.125/Experiments/'
C=load(['../Analysis/roms_C_hp_m_',roms.latlonRange,'.mat'])
F=load(['../Analysis/roms_F_m_',roms.latlonRange,'.mat'])

%%
mdx=1;
vecscale = 1e2;hheadwidth = 2;headl = 2;hshaftwidth=.15;col='r';presmoo=2;postsmoo=2;minv = 1;sub=2
lon0 = roms.lon0;lon1 = roms.lon1;lat0=roms.lat0;lat1=roms.lat1;reflon = 147.5;reflat = -41.5;refv=10;refu=0;
smoofac = 1;
f1;clf;ROMS_F_quickplot_helper
f2;clf;rwb;ROMS_F_C_quickplot_helper
%%
% % compare with JGP version. Fluxes are good, conversion is wrong
% expname = 'TS_0.125_2013_001_TidesM2_10plus5_meso';
% base = '/import/c/w/jpender/roms-kate_svn/TS_0.125/Experiments/'
%%
% mdx=1;
% vecscale = 1e2;hheadwidth = 2;headl = 2;hshaftwidth=.15;col='r';presmoo=2;postsmoo=2;minv = 1;sub=2
% lon0 = roms.lon0;lon1 = roms.lon1;lat0=roms.lat0;lat1=roms.lat1;reflon = 147.5;reflat = -41.5;refv=10;refu=0;
% smoofac = 1;
% f3;clf;ROMS_F_quickplot_helper
% f4;clf;rwb;ROMS_F_C_quickplot_helper
%%


