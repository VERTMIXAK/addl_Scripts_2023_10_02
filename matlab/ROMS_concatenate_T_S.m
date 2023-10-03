if ~exist(roms.analysis_path);eval(['!mkdir -p ',roms.analysis_path]);end
%keyboard 
for kk = 1:nz;%disp(['kk = ',num2str(kk)])
  tic
   if strmatch(roms.type,'tideonly')
    outfile = [roms.analysis_path,num2str(kk),'_T_his.nc'];disp(outfile)
    if ~exist(outfile);eval(['!ncrcat -v temp -d s_rho,',num2str(kk-1),',',num2str(kk-1),',1 ',roms.path1,'/',roms.exp,'_his_*_hourly*.nc ',outfile]);end
   else
    outfile = [roms.analysis_path,num2str(kk),'_T_S_his.nc'];disp(outfile)
    if ~exist(outfile);eval(['!ncrcat -v salt,temp -d s_rho,',num2str(kk-1),',',num2str(kk-1),',1 ',roms.path1,'/',roms.exp,'_his_*_hourly*.nc ',outfile]);end
   end
   toc
 end % kk
%% 
