#Michigan Stations Mapping
#This code, similar to the Iowa Stations Mapping code, but here we explored more with the Michigan map and how we will map a more
#uniquely shaped state.

# First, we install the ggmap package
install.packages("ggmap")
# and load the ggmap.
library(ggmap)
#We download the Michigan station location data by reading the csv file.  The file location will depend on the user.
Michigan_StationData <- read.csv('/home/leahy8/Downloads/Mich_stations.csv')
#We use the head command to double check whether we downloaded the right data file. 
head(Michigan_StationData)
#We use Google API key to use Google maps.  The API key will very based on the user.  We also create a center point for the map using 
#a geocode.
register_google(key = 'API', write = TRUE)
Michigan_center = as.numeric(geocode("Michigan"))
#We then create station points using the longitude and latitude values from the data set. 
mypoints <- data.frame(lon=Michigan_StationData$longitude,lat=Michigan_StationData$latitude)
#We use the ggmap command with a zoom rate of 7 to create a base map of Michigan.
Michigan_Map <- ggmap(get_googlemap(center = Michigan_center,zoom=7))
Michigan_Map
#We finally add station locations onto the map, choosing the size of the dots that will appear on the base map.
Michigan_Map <- Michigan_Map + geom_point(data=mypoints, size=0.1)
Michigan_Map
