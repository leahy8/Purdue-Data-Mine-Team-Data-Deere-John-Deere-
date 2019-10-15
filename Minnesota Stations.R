# install.packages("ggmap")
library(ggmap)
#Download Minnesota Station Location Data
Minnesota_StationData <- read.csv('/home/thomp626/Downloads/convertcsv(1)(2).csv')
head(Minnesota_StationData)
#Use Google API
register_google(key = 'AIzaSyANN360ijECeXpZ9rac2EmWNBITkCryuK8', write = TRUE)
Minnesota_center = as.numeric(geocode("Minnesota"))
#Create station points
mypoints <- data.frame(lon=Minnesota_StationData$longitude,lat=Minnesota_StationData$latitude)
Minnesota_Map <- ggmap(get_googlemap(center = Minnesota_center,zoom=7))
Minnesota_Map
#add station locations onto the map
Minnesota_Map <- Minnesota_Map + geom_point(data=mypoints, size=0.1)
Minnesota_Map



