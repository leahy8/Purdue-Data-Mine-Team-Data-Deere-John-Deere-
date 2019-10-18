#first we load in the csv file
CropYield <-read.csv('/home/leahy8/Downloads/Crop_Yield_County_NorthernMW_2002-12_modified.csv')
#We also need to call in the ggmap packages.
library(ggmap)
#Now, we will cut this down to just Michigan.
MiCY <- subset(CropYield, CropYield$State == 'MICHIGAN')
#We can make this even smaller by selecting a year.  For this, lets select 2002.
MiCY2002 <- subset(MiCY, MiCY$Year == '2002')
head(MiCY2002)
#Now lets load in our API to create the map of Michigan.
register_google(key = "API", write = TRUE)
Michigan_center = as.numeric(geocode("Michigan"))
#We can use the cordinates of latitude and longitude for our map points.
mypoints <- data.frame(lon=MiCY2002$Longitude,lat=MiCY2002$Latitude)
#Now we should look at the range of data to see how we want to categorize it.
max(MiCY2002$Value)
min(MiCY2002$Value)
#The max yield was 144 and the min yield was 0 (bushels/acre).  
mean(MiCY2002$Value)
median(MiCY2002$Value)
#The average crop yield overall was 106.2754 bushels/acre.
sd(MiCY2002$Value)
#The standard deviation of the yield values was 26.17862
#For simplity's sake in this demo, we will split this into 4 categories.
#Category 1 will be everything 2 standard deviations below the mean (extremely low).
Cat1_MiCY2002 <- subset(MiCY2002, MiCY2002$Value < 53.91816)
mypoints1 = data.frame(lon=Cat1_MiCY2002$Longitude,lat=Cat1_MiCY2002$Latitude)
#Category 2 will be everything between 2 and 1 standard deviation below the mean (below average).
Cat2_MiCY2002 <- subset(MiCY2002, MiCY2002$Value < 80.09678 & MiCY2002$Value > 53.91816)
mypoints2 = data.frame(lon=Cat2_MiCY2002$Longitude,lat=Cat2_MiCY2002$Latitude)
#Category 3 will be everything within 1 standard deviation of the mean (average)
Cat3_MiCY2002 <- subset(MiCY2002, MiCY2002$Value > 80.09678 & MiCY2002$Value < 132.45402)
mypoints3 = data.frame(lon=Cat3_MiCY2002$Longitude,lat=Cat3_MiCY2002$Latitude)
#Category 4 will be everything above 1 standard deviation of the mean (high)
Cat4_MiCY2002 <- subset(MiCY2002, MiCY2002$Value > 132.45402)
mypoints4 = data.frame(lon=Cat4_MiCY2002$Longitude,lat=Cat4_MiCY2002$Latitude)
#IN THIS CASE, THE CATEGORIES ARE JUST EXAMPLES, WE WILL NEED TO LOOK AT WHAT A GOOD HARVEST IS DEFINED AS.

#Now we can map this points with a dot map, with every category representated by its own color.
MiCY_Map2002 <- ggmap(get_googlemap(center = Michigan_center,zoom=7, maptype = 'hybrid'))
MiCY_Map2002
MiCY_Map2002 <- MiCY_Map2002 + geom_point(data = mypoints1, color = "green", size=5, alpha=1)
MiCY_Map2002 <- MiCY_Map2002 + geom_point(data = mypoints2, color = "yellow", size=5, alpha=1)
MiCY_Map2002 <- MiCY_Map2002 + geom_point(data = mypoints3, color = "orange", size=5, alpha=1)
MiCY_Map2002 <- MiCY_Map2002 + geom_point(data = mypoints4, color = "red", size=5, alpha=1)
MiCY_Map2002 + ggtitle("Michigan 2002 Crop Yield Data") + xlab('Longitude')+ylab('Latitude')

#Right now the map return is only made up of small dots, but we are looking into editing this data as well as adding a scale.
#Our main challange right now is cleaning up the precipitation data (get names of locations matched with coordinates)
#There is still a lot of work to be done, but we are going in the right direction!

