#Iowa Mapping
#This code was a demo of our exploration of mapping data in R using a google maps API.

# First, we install the ggmap package, which will allow us to create maps.
install.packages("ggmap")
# and load the ggmap.
library(ggmap)
#Next, we download the Iowa station location data.  The file location will change based on the user.
Iowa_StationData <- read.csv('/home/lee3349/Downloads/IOWA.csv')
head(Iowa_StationData)
#Use Google API.  The API will change based on the user.
register_google(key = 'API', write = TRUE)
Iowa_center = as.numeric(geocode("Iowa"))
#Then, we create a vector of station points to put on our map by taking the latitude and longitude points from the dataset.
mypoints <- data.frame(lon=Iowa_StationData$longitude,lat=Iowa_StationData$latitude)
#We then use the ggmap command to create our base map of Iowa.
Iowa_Map <- ggmap(get_googlemap(center = Iowa_center,zoom=7))
Iowa_Map
#Finally, we add the station locations onto our base map.
Iowa_Map <- Iowa_Map + geom_point(data=mypoints, size=0.1)
Iowa_Map
