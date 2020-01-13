# First, we install the ggmap package
install.packages("ggmap")
# and load the ggmap.
library(ggmap)
#We download Michigan Station Location Data by reading csv files.
Michigan_StationData <- read.csv('/home/leahy8/Downloads/Mich_stations.csv')
#We use the head command to double check whether we downladed the right data file. 
head(Michigan_StationData)
#We use Google API key to use Google maps.
register_google(key = 'API', write = TRUE)
Michigan_center = as.numeric(geocode("Michigan"))
#We create station points using longitude and latitidue. 
mypoints <- data.frame(lon=Michigan_StationData$longitude,lat=Michigan_StationData$latitude)
#We use the zoom rate of 7 to have a proper look of the map which is the plot of our code. 
Michigan_Map <- ggmap(get_googlemap(center = Michigan_center,zoom=7))
Michigan_Map
#We add station locations onto the map and choose the size of the dot that will appear on the map
Michigan_Map <- Michigan_Map + geom_point(data=mypoints, size=0.1)
Michigan_Map

