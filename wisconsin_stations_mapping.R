# install.packages("ggmap")
library(ggmap)
#Download Wisconsin Station Location Data by reading the csv file. 
Wisconsin_StationData <- read.csv('/home/hgronwol/Downloads/wisconsin_stations.csv')
#Use the head command to check whehter we downloaded the correct data.
head(Wisconsin_StationData)
#We use the google API code to get the google maps.
register_google(key = 'API', write = TRUE)
Wisconsin_center = as.numeric(geocode("Wisconsin"))
#We create station points using longitude and latitude.
mypoints <- data.frame(lon=Wisconsin_StationData$results__longitude,lat=Wisconsin_StationData$results__latitude)
#We choose the zoom rate of 7 to have a proper look of our map which is the plot of our code. 
Wisconsin_Map <- ggmap(get_googlemap(center = Wisconsin_center,zoom=7))
Wisconsin_Map
#We add station locations onto the map and choose the size of the dots that will represent the stations on the map
Wisconsin_Map <- Wisconsin_Map + geom_point(data=mypoints, size=0.1)
Wisconsin_Map
