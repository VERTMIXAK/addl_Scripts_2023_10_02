source ~/.runPycnal
while [ ! -f ./data_T//GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS_2022_060.nc ]
do
python -m motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu --service-id  GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024-3dinst-thetao  --longitude-min 130 --longitude-max 160 --latitude-min 0 --latitude-max 30 --date-min "2022-03-01 00:00:00" --date-max "2022-03-01 18:00:00" --depth-min 0.494 --depth-max 5727.917 --variable thetao    --out-dir ./data_T/ --out-name GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS_2022_060.nc --user jpender --pwd hiphopCMEMS3~
done
while [ ! -f ./data_T//GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS_2022_061.nc ]
do
python -m motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu --service-id  GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024-3dinst-thetao  --longitude-min 130 --longitude-max 160 --latitude-min 0 --latitude-max 30 --date-min "2022-03-02 00:00:00" --date-max "2022-03-02 18:00:00" --depth-min 0.494 --depth-max 5727.917 --variable thetao    --out-dir ./data_T/ --out-name GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS_2022_061.nc --user jpender --pwd hiphopCMEMS3~
done
