
ubtoutfile = [roms.analysis_path,'/ubt_vbt_his2.nc'];disp(ubtoutfile)
if ~exist(ubtoutfile);
    eval(['!ncrcat -v ubar,vbar ',roms.path1,'/',roms.exp,'_his2_*.nc ',ubtoutfile]);done(['concatenating ',ubtoutfile])
end

roms.files.ubtoutfile=ubtoutfile;
done('concatenate ubt')