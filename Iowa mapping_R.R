# First, we install the ggmap package
install.packages("ggmap")
# and load the ggmap.
library(ggmap)
#Download Iowa Station Location Data
Iowa_StationData <- read.csv('/home/lee3349/Downloads/IOWA.csv')
head(Iowa_StationData)
#Use Google API
register_google(key = 'AIzaSyACb7Pmv9cAdE4HFSMTWyll5uMDXeErRyc', write = TRUE)
Iowa_center = as.numeric(geocode("Iowa"))
#Create station points
mypoints <- data.frame(lon=Iowa_StationData$longitude,lat=Iowa_StationData$latitude)
Iowa_Map <- ggmap(get_googlemap(center = Iowa_center,zoom=7))
Iowa_Map
#add station locations onto the map
Iowa_Map <- Iowa_Map + geom_point(data=mypoints, size=0.1)
Iowa_Map