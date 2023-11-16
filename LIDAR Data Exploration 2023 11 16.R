# ESIIL Hackathon 2023
# Team E - Matt Austin, Yanle Lu, Brian Yandell

# Lidar-based Canopy Height
# https://data-library.esiil.org/remote_sensing/lidar_canopy_height/lidar_canopy_height/#1-setup

install.packages("neonUtilities")
install.packages("neonOS")
install.packages("sp")
install.packages("raster")
install.packages("devtools")
devtools::install_github("NEONScience/NEON-geolocation/geoNEON")

library(sp)
library(raster)
library(neonUtilities)
library(neonOS)
library(geoNEON)

options(stringsAsFactors=F)

veglist <- loadByProduct(dpID="DP1.10098.001", 
                         site="WREF", 
                         package="basic", 
                         check.size = FALSE)
head(veglist)

vegmap <- getLocTOS(veglist$vst_mappingandtagging, 
                    "vst_mappingandtagging")

head(vegmap)

veg <- joinTableNEON(veglist$vst_apparentindividual, 
                     vegmap, 
                     name1="vst_apparentindividual",
                     name2="vst_mappingandtagging")


symbols(veg$adjEasting[which(veg$plotID=="WREF_075")], 
        veg$adjNorthing[which(veg$plotID=="WREF_075")], 
        circles=veg$stemDiameter[which(veg$plotID=="WREF_075")]/100/2, 
        inches=F, xlab="Easting", ylab="Northing")

# NEON data products:
# https://data.neonscience.org/data-products/explore

# NEON has various sites in Alaska, which are shown in the following map:
# https://data.neonscience.org/data-products/explore
# Each site has a limited spatial area.


# Fire Event Delineation

packages <- c("tidyverse", "httr", "sf") 
new.packages <- packages[!(packages %in% installed.packages()[,"Package"])] 
if(length(new.packages)>0) install.packages(new.packages) 

lapply(packages, library, character.only = TRUE)

url <- "https://scholar.colorado.edu/downloads/zw12z650d" 
fired <- GET(url) 
data_file <-"fired.zip" 
writeBin(content(fired, "raw"), data_file)

# Unzip the file
unzip(data_file)

fired <- st_read("fired_conus_ak_to_January_2022_gpkg_shp/conus_ak_to2022001_events.shp") 

ggplot(fired) +
  geom_point(aes(ig_day, event_dur)) +
  theme_bw() +
  xlab('Day') +
  ylab('Event duration (days)')

ggplot() + geom_sf(data = fired)










