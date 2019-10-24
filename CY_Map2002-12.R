#Crop Yield Maps from 2002-2012 (code)

#first we load in the csv file
CropYield <-read.csv('/home/leahy8/Downloads/Crop_Yield_County_NorthernMW_2002-12_modified.csv')
#We also need to call in the ggmap and mapping packages.
library(ggmap)
library(ggplot2)
library(RColorBrewer)
library(mapproj)
#Now, we will cut this down to just 2002.
CY_2002 <- subset(CropYield, CropYield$Year == '2002')
#Now, we need to get our API key, so we can use google maps.
register_google(key = "AIzaSyAGZ9Ehcd8fy9PO_q7JXeDGMuLxTkB9o2E", write = TRUE)
#To get all four states in one map, we need to pick a center point.
NorthMW_center = as.numeric(geocode("Stevens Point, Wisconsin"))
CY_2002_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))
#Now that we have a map, we can plot our points and scale them using ggplot
colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2002_Map <- CY_2002_Mapbase %+% CY_2002 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2002") +
  coord_map()
CY_2002_Map
#This mapping process can be repeated for all of the years:

#2003 Map
CY_2003 <- subset(CropYield, CropYield$Year == '2003')
CY_2003_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2003_Map <- CY_2003_Mapbase %+% CY_2003 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2003") +
  coord_map()
CY_2003_Map

#2004 Map
CY_2004 <- subset(CropYield, CropYield$Year == '2004')
CY_2004_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2004_Map <- CY_2004_Mapbase %+% CY_2004 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2004") +
  coord_map()
CY_2004_Map

#2005 Map
CY_2005 <- subset(CropYield, CropYield$Year == '2005')
CY_2005_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2005_Map <- CY_2005_Mapbase %+% CY_2005 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2005") +
  coord_map()
CY_2005_Map

#2006 Map
CY_2006 <- subset(CropYield, CropYield$Year == '2006')
CY_2006_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2006_Map <- CY_2006_Mapbase %+% CY_2006 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2006") +
  coord_map()
CY_2006_Map

#2007 Map
CY_2007 <- subset(CropYield, CropYield$Year == '2007')
CY_2007_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2007_Map <- CY_2007_Mapbase %+% CY_2007 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2007") +
  coord_map()
CY_2007_Map

#2008 Map
CY_2008 <- subset(CropYield, CropYield$Year == '2008')
CY_2008_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2008_Map <- CY_2008_Mapbase %+% CY_2008 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2008") +
  coord_map()
CY_2008_Map

#2009 Map
CY_2009 <- subset(CropYield, CropYield$Year == '2009')
CY_2009_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2009_Map <- CY_2009_Mapbase %+% CY_2009 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2009") +
  coord_map()
CY_2009_Map

#2010 Map
CY_2010 <- subset(CropYield, CropYield$Year == '2010')
CY_2010_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2010_Map <- CY_2010_Mapbase %+% CY_2010 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2010") +
  coord_map()
CY_2010_Map

#2011 Map
CY_2011 <- subset(CropYield, CropYield$Year == '2011')
CY_2011_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2011_Map <- CY_2011_Mapbase %+% CY_2011 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2011") +
  coord_map()
CY_2011_Map

#2012 Map
CY_2012 <- subset(CropYield, CropYield$Year == '2012')
CY_2012_Mapbase <- ggmap(get_googlemap(center = NorthMW_center, zoom = 6, alpha = 0.5))

colormap <- c("Blue", "Green", "Yellow", "Red")
CY_2012_Map <- CY_2012_Mapbase %+% CY_2012 +
  aes(x = Longitude, y = Latitude, z = Value, size = 10, alpha = 0.03) +
  stat_summary_2d()+
  scale_fill_gradientn(name = "Yield (Bushels/Acre)", colours= colormap, space = "Lab") +
  labs(x = "Longitude", y = "Latitude") +
  ggtitle("                   Upper Midwest Corn Yield 2012") +
  coord_map()
CY_2012_Map

#Notes:
#  -The map of all four states fits the data pretty well, except for on the left edge.
#  -By pulling up all of the maps (on 10/24/19 meeting slides), we can look at changes over the 11 year period.

#Possible Improvements:
#  -Need to look into changing the zoom, some of the left-most points (~10) appear to be getting cut off.
#  -Any specific color scale? (easy to edit)
#  -Possible way to loop the commands? Instead of just repeating code with small changes)

