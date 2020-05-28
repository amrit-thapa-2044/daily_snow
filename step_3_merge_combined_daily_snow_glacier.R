# Title: merge daily improved snow with RGI06 glacier
# Writer: amrit THAPA (amrit.thapa@icimod.org)
# Affiliation:  International Centre for Integrated Mountain Development (ICIMOD,http://www.icimod.org/)
# Date; 2020-04-20
# Disclamier: Use at your own risk

# clean woking environment
rm(list=ls())

# time at the beginning of the processing
start_time=Sys.time()

# load necessary package/library
library(raster)
library(stringr)

# set working directory (place where you have daily improved snow data)
setwd("D:/R_script/sher_daily_snow_code")

#list all daily snow files from working directory
combined_snow_list<-list.files("./data/combine_improved_MOYD10A1/",pattern=".tif$",full.names=TRUE)

#extract date from file name
DOY=as.numeric(str_sub(combined_snow_list,-11,-5))

# load glacier data
glacier_data=raster("./data/RGI6/RGI6_DebCleanICE.tif")

# directory for output
outpath="./data/final_product_merge_RGI06_MOYD10A1/"

# loop through each image and apply different combinations.
for(i in 1:length(combined_snow_list)){
  
  # import combined snow
  day_snow=raster(combined_snow_list[i])
  
  # create output raster
  snow_glacier=day_snow
  #snow_glacier[snow_glacier>=0]<-NA
  
  # debris-covered ice == 10
  # (snow = 198 + glacier = 10) == asign 238; (snow = 199 + glacier = 10) ==239
  # (snow = 200 + glacier = 10) ==242;  (25/50+glacier 10) ==240
  
  # Terra snow and  debris-covered ice combination
  index_TS_DCI=values(day_snow==198) & values(glacier_data==10)
  values(snow_glacier)[index_TS_DCI]=238
  
  # Aqua snow and debris-covered ice combination
  index_AS_DCI=values(day_snow==199) & values(glacier_data==10)
  values(snow_glacier)[index_AS_DCI]=239
  
  # Both snow and debris-covered ice combination
  index_BS_DCI=values(day_snow==200) & values(glacier_data==10)
  values(snow_glacier)[index_BS_DCI]=242
  
  # cloud-no snow and debris-covered ice combination
  index_CNS_DCI=values(day_snow==50 | day_snow==25) & values(glacier_data==10)
  values(snow_glacier)[index_CNS_DCI]=240
  
  #########################################################
  
  # clean ice == 2-
  # (snow = 198 + glacier = 20) == 248; (snow = 199 + glacier = 20) == 249;
  # (snow = 200 + glacier = 20) ==252; (25/50 + glacier 20) == 250

  # Terra snow and clean ice combination
  index_TS_CI=values(day_snow==198) & values(glacier_data==20)
  values(snow_glacier)[index_TS_CI]=248
  
  # Aqua snow and clean ice combination
  index_AS_CI=values(day_snow==199) & values(glacier_data==20)
  values(snow_glacier)[index_AS_CI]=249
  
  # Both snow and clean ice combination
  index_BS_CI=values(day_snow==200) & values(glacier_data==20)
  values(snow_glacier)[index_BS_CI]=252
  
  # cloud-no snow and clean ice combination
  index_CNS_CI=values(day_snow==50 | day_snow==25) & values(glacier_data==20)
  values(snow_glacier)[index_CNS_CI]=250
  
  # Export final combined product
  writeRaster(snow_glacier,
              filename=paste0(outpath,'MOYD10A1_RGI06_',DOY[i],".tif"),
              format="GTiff",datatype='INT1U', overwrite=TRUE)
}

end_time=Sys.time()
print(paste0("Time taken to process = ",round(end_time-start_time,2), " minutes",sep=""))


