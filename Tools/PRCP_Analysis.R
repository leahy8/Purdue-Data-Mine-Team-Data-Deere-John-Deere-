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

#Get monthly sums
monthlySums <- tapply(df$value, df$date,sum)

#Display monthly sums
monthlySums

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
