# Title: improve modis daily snow using improved 8-day snow from Sher Muhammad and Amrit Thapa 2019
# Writer: amrit THAPA (amrit.thapa@icimod.org)
# Affiliation:  International Centre for Integrated Mountain Development (ICIMOD,http://www.icimod.org/)
# Date; 2019-11-04
# Disclamier: Use at your own risk

rm(list=ls())
library(raster)
start_time=Sys.time()

# run this scrit twice (replace MYD10A1 by MYD10A1 or vice versa)

# NOTE: make sure that you have 365 images in daily folder and 46 images in 8-day folder
# run the processing seperately for each layer
# keep changing pattern for each year, just change year

# set the working directory
setwd("D:/R_script/sher_daily_snow_code")

# provide the location of daily image in the following line
daily_list<-list.files("./data/MYD10A1",pattern="2018",full.names=TRUE)
length(daily_list)

# provide the location of 8-day product in the following link
eight_snow<-list.files("./data/MOYDGL06",pattern="2018",full.names=TRUE)
eight_snow

# make new folder and provide location for output
outpath="./data/improved_MYD10A1/"

# ex=extent(85,88,28,30)

library(stringr)
index_4_day=as.numeric(str_sub(eight_snow,-7,-5))

for( i in 1:length(index_4_day)){
  #i=1
  s_8=raster(eight_snow[i])
  #s_8=crop(s_8,ex)
  ##plot(s_8)
  ##print(names(s_8))
  
  if(i==46){  d_8=stack(daily_list[index_4_day[i]:(index_4_day[i]+4)])}else{
    d_8=stack(daily_list[index_4_day[i]:(index_4_day[i]+7)])}
  
  #d_8=crop(d_8,ex)
  ##plot(d_8)
  ##print(names(d_8))
  
  for (j in 1:8) {
    #j=1
    #freq(d_8[[j]])
    
      # 8-day=snow, daily=no snow =No snow
      # idx_S_NS<- values(s_8)==200 & values(d_8[[j]])==25
      # values(d_8[[j]])[idx_S_NS]<-25
      # freq(d_8[[j]])
    
    # 8-day=no snow, daily=snow =No snow
    idx_NS_S<- values(s_8)==225 & values(d_8[[j]])==200
    values(d_8[[j]])[idx_NS_S]<-25
    #freq(d_8[[j]])
    
    # 8-day=snow, daily=cloud =snow 
    idx_S_C<- values(s_8)==200 & values(d_8[[j]])==50
    values(d_8[[j]])[ idx_S_C]<-200
    #freq(d_8[[j]])
    
    # 8-day=no snow, daily=cloud = no snow 
    idx_NS_C<- values(s_8)==225 & values(d_8[[j]])==50
    values(d_8[[j]])[idx_NS_C]<-25
    #freq(d_8[[j]])
    
    writeRaster(d_8[[j]],
                filename=paste0(outpath,'Improved_',names(d_8[[j]]),".tif"),
                format="GTiff",datatype='INT1U', overwrite=TRUE)
  }
}
end_time=Sys.time()
print(paste0("Time taken to process = ",round(end_time-start_time,2), " minutes",sep=""))


