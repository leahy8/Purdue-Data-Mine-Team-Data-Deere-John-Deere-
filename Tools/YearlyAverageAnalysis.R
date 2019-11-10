require(RJSONIO)

library(plyr) #mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)
library(RColorBrewer) #colors

#Read JSON File
json_file <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Wisconsin_GSOM_PRCP.json")

#Convert to dataframe
df <- ldply (json_file, data.frame)

#Check dataframe
df


df2 = df
df2$date <- as.character(df2$date) #https://stackoverflow.com/questions/2851015/convert-data-frame-columns-from-factors-to-characters

df3 <- read.table(text = df2$date, sep = "-", colClasses = "character")#strsplit(df2$date, "-")
df2$year <- df3$V1
df2$month <- df3$V2

#Build df for display
displayDF <- data.frame(year = unique(df2$year))

#Get year averages
displayDF$yearAvg <- tapply(df2$value, df2$year,mean)



# Basic line plot with points
ggplot(data=displayDF, aes(x=displayDF$year, y=displayDF$yearAvg, group=1))+#,color = myDF$Year)) +
  geom_line()+
  geom_point()+
  labs(x="Year since Jan 2002", y="Rainfall (mm)")+
  ggtitle("Average Yearly Rainfall in Wisconsin") #+ 
#scale_color_manual(breaks = c(2002, 2003, 2004),
#values=c("red", "blue", "green"))
















#Build dataframe to display
myDF <- data.frame("Months" = 1:length(monthlySums), "Rain" = monthlySums)
myDF$Year <- floor((1:length(monthlySums) -1) / 12) + 2002

#Check results
myDF$Months
myDF$Year








length(myDF$Color)
# Basic line plot with points
ggplot(data=myDF, aes(x=myDF$Months, y=myDF$Rain/1000, group=1))+#,color = myDF$Year)) +
  #geom_line()+
  geom_point()+
  labs(x="Months since Jan 2002", y="Rainfall (m)")+
  ggtitle("Monthy Rainfall in Wisconsin") #+ 
  #scale_color_manual(breaks = c(2002, 2003, 2004),
  #                    values=c("red", "blue", "green"))
