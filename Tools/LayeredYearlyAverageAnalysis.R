require(RJSONIO)

library(plyr) #mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)
library(RColorBrewer) #colors

#Read JSON File
json_file <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Wisconsin_GSOM_TAVG.json")
json_file2 <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Minnesota_GSOM_TAVG.json")
json_file3 <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Michigan_GSOM_TAVG.json")
json_file4 <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Iowa_GSOM_TAVG.json")

#Convert to dataframe
dfa_1 <- ldply (json_file, data.frame)
dfa_2 <- ldply (json_file2, data.frame)
dfa_3 <- ldply (json_file3, data.frame)
dfa_4 <- ldply (json_file4, data.frame)

dfb_1 = dfa_1
dfb_2 = dfa_2
dfb_3 = dfa_3
dfb_4 = dfa_4
dfb_1$date <- as.character(dfb_1$date)
dfb_2$date <- as.character(dfb_2$date)
dfb_3$date <- as.character(dfb_3$date)
dfb_4$date <- as.character(dfb_4$date)

dfc_1 <- read.table(text = dfb_1$date, sep = "-", colClasses = "character")
dfc_2 <- read.table(text = dfb_2$date, sep = "-", colClasses = "character")
dfc_3 <- read.table(text = dfb_3$date, sep = "-", colClasses = "character")
dfc_4 <- read.table(text = dfb_4$date, sep = "-", colClasses = "character")
dfb_1$year <- dfc_1$V1
dfb_2$year <- dfc_2$V1
dfb_3$year <- dfc_3$V1
dfb_4$year <- dfc_4$V1
dfb_1$month <- dfc_1$V2
dfb_2$month <- dfc_2$V2
dfb_3$month <- dfc_3$V2
dfb_4$month <- dfc_4$V2

#Build df for display
displayDF_1 <- data.frame(year = unique(dfb_1$year))
displayDF_2 <- data.frame(year = unique(dfb_2$year))
displayDF_3 <- data.frame(year = unique(dfb_3$year))
displayDF_4 <- data.frame(year = unique(dfb_4$year))

#Get year averages
displayDF_1$yearAvg <- tapply(dfb_1$value, dfb_1$year,mean)
displayDF_2$yearAvg <- tapply(dfb_2$value, dfb_2$year,mean)
displayDF_3$yearAvg <- tapply(dfb_3$value, dfb_3$year,mean)
displayDF_4$yearAvg <- tapply(dfb_4$value, dfb_4$year,mean)

# Add in a state column used for aesthetic grouping
displayDF_1$state <- "Wisconsin"
displayDF_2$state <- "Minnesota"
displayDF_3$state <- "Michigan"
displayDF_4$state <- "Iowa"


#No default; data explicitly specified for each geom
#http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/
ggplot(NULL, aes(x=year, y=yearAvg, group=state)) + 
    geom_point(data = displayDF_1, aes(color = "Wisconsin")) + 
    geom_line(data = displayDF_1, aes(year, yearAvg, color = "Wisconsin")) +
    
    geom_point(data = displayDF_2, aes(colour = "Minnesota")) + 
    geom_line(data = displayDF_2, aes(year, yearAvg, colour = "Minnesota")) + 
  
    geom_point(data = displayDF_3, aes(colour = "Michigan")) + 
    geom_line(data = displayDF_3, aes(year, yearAvg, colour = "Michigan")) + 

    geom_point(data = displayDF_4, aes(colour = "Iowa")) + 
    geom_line(data = displayDF_4, aes(year, yearAvg, colour = "Iowa")) +
  
    ggtitle("Yearly Average Temperature")+
    labs(x="Year", y="Temperature (°C)", color="Legend")
    
    #theme(legend.position="right")
    

  
  


# Basic line plot with points
#ggplot(data=displayDF_1, aes(x=displayDF_1$year, y=displayDF_1$yearAvg, group=1))+#,color = myDF$Year)) +
#  geom_line()+
#  geom_point()+
#  ylim(40, 100)+
#  labs(x="Year", y="Rainfall (mm)")+
#  ggtitle("Average Yearly Rainfall")
