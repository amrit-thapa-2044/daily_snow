# title: combine improved daily terra and aqua snow cover product
# code compiler: amrit THAPA
# date: 2019-12-23

# NOTE:make a folder named improved_terra_daily for daily improved terra
# NOTE:make a folder named improved_aqua_daily for daily improved aqua
# NOTE:make a folder named combined_improved_daily for output

rm(list=ls())
library(raster)

setwd("D:/R_script/sher_daily_snow_code")

terra_daily_list<-list.files("./data/improved_MOD10A1",pattern=".tif$",full.names=TRUE)
length(terra_daily_list)
head(terra_daily_list)
tail(terra_daily_list)

aqua_daily_list<-list.files("./data/improved_MYD10A1",pattern=".tif$",full.names=TRUE)
length(aqua_daily_list)
head(aqua_daily_list)
tail(aqua_daily_list)

outpath="./data/combine_improved_MOYD10A1/"

library(stringr)
index_4_name=as.numeric(str_sub(aqua_daily_list,-11,-5))
head(index_4_name)

for(j in 1:length(aqua_daily_list)){
  
 # j=1
  aqua<-raster(aqua_daily_list[j])
  terra<-raster(terra_daily_list[j])
  
  # plot(terra);freq(terra)
  # plot(aqua);freq(aqua)
  
  AT_com_day<-terra
  AT_com_day[AT_com_day>=0]<-NA
  
  
  #Aqua and Terra snow combination
  idx_SS=values(aqua==200) & values(terra==200)
  values(AT_com_day)[idx_SS]=200
#  freq(AT_com_day)
  
  #Aqua and Terra land combination  
  idx_LL=values(aqua==25) & values(terra==25)
  values(AT_com_day)[idx_LL]=25
 # freq(AT_com_day)
  
  #Aqua and Terra Cloud combination
  idx_CC=values(aqua==50) & values(terra==50)
  values(AT_com_day)[idx_CC]=50
#  freq(AT_com_day)
  
  #Aqua land and Terra snow combination
  idx_LS=values(aqua==25) & values(terra==200)
  values(AT_com_day)[idx_LS]=198
 # freq(AT_com_day)
  
  #Aqua snow and Terra land combination
  idx_SL=values(aqua==200) & values(terra==25)
  values(AT_com_day)[idx_SL]=199
#  freq(AT_com_day)
  
  #Aqua Cloud and Terra land combination
  idx_CL=values(aqua==50) & values(terra==25)
  values(AT_com_day)[idx_CL]=25
 # freq(AT_com_day)
  
  #Aqua land and Terra Cloud combination
  idx_LC=values(aqua==25) & values(terra==50)
  values(AT_com_day)[idx_LC]=25
#  freq(AT_com_day)
  
  # Aqua Cloud and Terra snow combination
  idx_SC=values(aqua==50) & values(terra==200)
  values(AT_com_day)[idx_SC]=198
#  freq(AT_com_day)
  
  #Aqua snow and Terra Cloud combination
  idx_CS=values(aqua==200) & values(terra==50)
  values(AT_com_day)[idx_CS]=199
 # freq(AT_com_day)
  
  writeRaster(AT_com_day,
              filename=paste0(outpath,'Combined_Terra_Aqua_',index_4_name[j],".tif"),
              format="GTiff",datatype='INT1U', overwrite=TRUE)
  
  
}


