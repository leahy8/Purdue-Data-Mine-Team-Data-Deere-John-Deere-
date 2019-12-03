library(ggplot2)
library(dplyr)
require(RJSONIO)
library(plyr)

#Read JSON File
json_file <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Wisconsin_GSOM_TAVG.json")
json_file2 <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Wisconsin_GSOM_TMAX.json")
json_file3 <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Wisconsin_GSOM_TMIN.json")


#Convert to dataframe
dfa_1 <- ldply (json_file, data.frame)
dfa_2 <- ldply (json_file2, data.frame)
dfa_3 <- ldply (json_file3, data.frame)

#Make date column
dfb_1 = dfa_1
dfb_2 = dfa_2
dfb_3 = dfa_3
dfb_1$date <- as.character(dfb_1$date)
dfb_2$date <- as.character(dfb_2$date)
dfb_3$date <- as.character(dfb_3$date)

#Transform
dfc_1 <- read.table(text = dfb_1$date, sep = "-", colClasses = "character")
dfc_2 <- read.table(text = dfb_2$date, sep = "-", colClasses = "character")
dfc_3 <- read.table(text = dfb_3$date, sep = "-", colClasses = "character")
dfb_1$year <- dfc_1$V1
dfb_2$year <- dfc_2$V1
dfb_3$year <- dfc_3$V1
dfb_1$month <- dfc_1$V2
dfb_2$month <- dfc_2$V2
dfb_3$month <- dfc_3$V2

#Build df for display
displayDF_1 <- data.frame(year = as.numeric(unique(dfb_1$year)))
displayDF_2 <- data.frame(year = as.numeric(unique(dfb_2$year)))
displayDF_3 <- data.frame(year = as.numeric(unique(dfb_3$year)))

#Get year averages
displayDF_1$yearAvg <- tapply(dfb_1$value, dfb_1$year,mean)
displayDF_2$yearAvg <- tapply(dfb_2$value, dfb_2$year,mean)
displayDF_3$yearAvg <- tapply(dfb_3$value, dfb_3$year,mean)


plot(displayDF_1$year,displayDF_1$yearAvg, type='n',
     main='Temperature in Wisconsin', ylab='Temperature (°C)', xlab='Year', ylim=c(0,20))

#lines(displayDF_3$year,displayDF_3$yearAvg,col='grey') #Bot
#lines(displayDF_2$year,displayDF_2$yearAvg,col='grey') #Top
lines(displayDF_1$year, displayDF_1$yearAvg,col=rgb(0,0,0,1)) #Avg

polygon(c(displayDF_1$year, rev(displayDF_1$year), displayDF_1$year[1]), c(displayDF_3$yearAvg, rev(displayDF_2$yearAvg), displayDF_3$yearAvg[1]),
        col=rgb(1, 0, 0,.5), border=NA) 







#myDF <- data.frame(
#  x = c(1,2,3),
#  top = c(2,2,2),
#  bot = c(0,1,0),
#  mid = c(1,2,1)
#)

#x2 <- append(myDF$x, myDF$x)
#y2 <- append(myDF$bot, myDF$top)


###
#plot(x2,y2,type='n',ylab='Y Range',
#     xlab='Age (years)')
#
#lines(myDF$x,myDF$bot,col='grey')
#lines(myDF$x,myDF$top,col='grey')


#polygon(c(myDF$x, rev(myDF$x), myDF$x[1]), c(myDF$bot, rev(myDF$top), myDF$bot[1]),
#        col = "grey30") 
###











#ggplot(NULL, aes(x=x, y=mid, group=1)) + 
#  geom_point(data = myDF, aes()) + 
#  geom_line(data = myDF, aes(x, mid)) +
#  geom_polygon(aes(x=x2, y = y2,alpha = 0.5, fill="red"))
  






#ggplot(data=myDF, aes(x=myDF$x, y=myDF$mid, group=1))+
#  geom_line()+
#  geom_point()       

#ggplot(data=myDF, aes(x=myDF$x, y=myDF$top, group=1))+
#  geom_line()+
#  geom_point()  

#plot(1, 1, col = "white", xlab = "X", ylab = "Y")            # Draw empty plot

#polygon(x = c(0.7, 1.3, 1.2, 0.8),                           # X-Coordinates of polygon
#        y = c(0.6, 0.8, 1.4, 1),                             # Y-Coordinates of polygon
#        col = "#1b98e0")                                     # Color of polygon
