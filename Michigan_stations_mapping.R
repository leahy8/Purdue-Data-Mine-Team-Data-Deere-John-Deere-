# First, we install the ggmap package
install.packages("ggmap")
# and load the ggmap.
library(ggmap)
#Download Michigan Station Location Data
Michigan_StationData <- read.csv('/home/leahy8/Downloads/Mich_stations.csv')
head(Michigan_StationData)
#Use Google API
register_google(key = "AIzaSyAGZ9Ehcd8fy9PO_q7JXeDGMuLxTkB9o2E", write = TRUE)
Michigan_center = as.numeric(geocode("Michigan"))
#Create station points
mypoints <- data.frame(lon=Michigan_StationData$longitude,lat=Michigan_StationData$latitude)
Michigan_Map <- ggmap(get_googlemap(center = Michigan_center,zoom=7))
Michigan_Map
#add station locations onto the map
Michigan_Map <- Michigan_Map + geom_point(data=mypoints, size=0.1)
Michigan_Map

