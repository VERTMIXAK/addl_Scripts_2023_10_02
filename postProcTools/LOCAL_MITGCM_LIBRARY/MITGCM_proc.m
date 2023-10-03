
%%
clear
MODEL.base = '/home/hsimmons/PROJ/MODELS/MITgcm/EXP/TASMAN/'
MODEL.exp  = 'TEST_WAVE_8kmx8km_for_JGP'
MODEL.output_dir = 'output0001';MODEL=MITGCM_get_files(MODEL);MODEL=MITGCM_get_grid(MODEL);
%%
%% regress model against M2
tmp=load([MODEL.base,MODEL.exp,'/saves/data.mat']);MODEL.data.N2=tmp.MODEL.N2;MODEL.data.Tref=tmp.MODEL.Tref;MODEL.data.Tinit=tmp.MODEL.Tinit;
time=nc_varget(MODEL.files.u,'T')/3600;tdx=length(time)-24:length(time);% last 25 records
 MITGCM_calc_regress(MODEL.files.u   ,'UVEL'    ,1,MODEL,1/12.4206,tdx,'M2')
 MITGCM_calc_regress(MODEL.files.v   ,'VVEL'    ,2,MODEL,1/12.4206,tdx,'M2')
 MITGCM_calc_regress(MODEL.files.rhop,'RHOAnoma',0,MODEL,1/12.4206,tdx,'M2')

%%
%%
clear;rmpath LOCAL_MITGCM_LIBRARY % make sure to use the main library. 
%! /home/hsimmons/matlab/MITGCM/MITGCM_proc.csh ~/PROJ/MODELS/MITgcm/EXP/TASMAN/TEST_WAVE_8kmx8km_1/saves/output0001/
MODEL.base = '~/PROJ/MODELS/MITgcm/EXP/TASMAN/'
MODEL.exp  = 'TEST_WAVE_8kmx8km_1';MODEL.output_dir = 'saves/output0001/';MODEL.suffix1 = '.t001';MODEL.suffix2 = '.';
MODEL=MITGCM_get_files(MODEL);MODEL=MITGCM_get_grid(MODEL);
MODEL=MITGCM_IJPR(MODEL,1:120)
%%
load(MODEL.files.IFufile)