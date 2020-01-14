#Wisconsin Stations Mapping
#This code is very similar to the Iowa and Michigan stations mapping codes.  We again tried this to explore mapping with another state 
#to make sure our mapping code was consistent.

#First we install the ggmap package.
library(ggmap)
#Then we download the Wisconsin station location data by reading the csv file.  The file location will vary by user.
Wisconsin_StationData <- read.csv('/home/hgronwol/Downloads/wisconsin_stations.csv')
#Use the head command to check whether we downloaded the correct data.
head(Wisconsin_StationData)
#We use the google API code to get the google maps and select a centerpoint for the map using a geocode.  The API key will vary by user.
register_google(key = 'API', write = TRUE)
Wisconsin_center = as.numeric(geocode("Wisconsin"))
#We create station points using the longitude and latitude values from our dataset.
mypoints <- data.frame(lon=Wisconsin_StationData$results__longitude,lat=Wisconsin_StationData$results__latitude)
#We use the ggmap command with a zoom rate of 7 to have a proper look of the Wisconsin base map.
Wisconsin_Map <- ggmap(get_googlemap(center = Wisconsin_center,zoom=7))
Wisconsin_Map
#We finally add station locations onto the map and choose the size of the dots that will represent the stations on the base map.
Wisconsin_Map <- Wisconsin_Map + geom_point(data=mypoints, size=0.1)
Wisconsin_Map
