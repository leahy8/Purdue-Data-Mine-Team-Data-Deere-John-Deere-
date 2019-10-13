# install.packages("ggmap")
library(ggmap)
#Download Wisconsin Station Location Data
Wisconsin_StationData <- read.csv('/home/hgronwol/Downloads/wisconsin_stations.csv')
head(Wisconsin_StationData)
#Use Google API
register_google(key = 'AIzaSyANN360ijECeXpZ9rac2EmWNBITkCryuK8', write = TRUE)
Wisconsin_center = as.numeric(geocode("Wisconsin"))
#Create station points
mypoints <- data.frame(lon=Wisconsin_StationData$results__longitude,lat=Wisconsin_StationData$results__latitude)
Wisconsin_Map <- ggmap(get_googlemap(center = Wisconsin_center,zoom=7))
Wisconsin_Map
#add station locations onto the map
Wisconsin_Map <- Wisconsin_Map + geom_point(data=mypoints, size=0.1)
Wisconsin_Map
