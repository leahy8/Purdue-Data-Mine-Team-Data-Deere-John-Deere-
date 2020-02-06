require(RJSONIO)#required to read rson files
library(plyr) #mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)
library(RColorBrewer) #colors

#Read JSON File
json_fileIA <- fromJSON("/home/leahy8/JOHN_DEERE_PROJECT/IowaPrecipitation.json")
#Convert rhe JSON file to a dataframe
IowaPrecipitation<- ldply (json_fileIA, data.frame)
#Check dataframe
IowaPrecipitation
#Get monthly sums of precipitation
monthlySums_IA <- tapply(IowaPrecipitation$value, IowaPrecipitation$date,sum)

#Build dataframe to display
myDF_IA <- data.frame("Months" = 1:length(monthlySums_IA), "Rain" = monthlySums_IA)
myDF_IA$Year <- floor((1:length(monthlySums_IA) -1) / 12) + 2002

#Check results
myDF_IA$Months
myDF_IA$Year

#length(myDF_IA$Color)
# Basic line plot with points
ggplot(data=myDF_IA, aes(x=myDF_IA$Months, y=myDF_IA$Rain/1000, group=1))+#,color = myDF$Year)) +
  geom_line()+
  geom_point()+
  labs(x="Months since Jan 2002", y="Rainfall (m)")+
  ggtitle("Monthy Rainfall in Iowa") #+ 
#scale_color_manual(breaks = c(2002, 2003, 2004),
#values=c("red", "blue", "green"))

#Michigan
json_fileMI <- fromJSON("/home/leahy8/JOHN_DEERE_PROJECT/MichiganPrecipitation.json")
#Convert rhe JSON file to a dataframe
MichiganPrecipitation<- ldply (json_fileMI, data.frame)
#Check dataframe
MichiganPrecipitation
#Get monthly sums of precipitation
monthlySums_MI <- tapply(MichiganPrecipitation$value, MichiganPrecipitation$date,sum)

#Build dataframe to display
myDF_MI <- data.frame("Months" = 1:length(monthlySums_MI), "Rain" = monthlySums_MI)
myDF_MI$Year <- floor((1:length(monthlySums_MI) -1) / 12) + 2002

#Check results
myDF_MI$Months
myDF_MI$Year


#length(myDF$Color)
# Basic line plot with points
ggplot(data=myDF_MI, aes(x=myDF_MI$Months, y=myDF_MI$Rain/1000, group=1))+#,color = myDF$Year)) +
  geom_line()+
  geom_point()+
  labs(x="Months since Jan 2002", y="Rainfall (m)")+
  ggtitle("Monthy Rainfall in Michigan") #+ 
#scale_color_manual(breaks = c(2002, 2003, 2004),
#values=c("red", "blue", "green"))

#Minnesota
json_fileMN <- fromJSON("/home/leahy8/JOHN_DEERE_PROJECT/MinnesotaPrecipitation.json")
#Convert rhe JSON file to a dataframe
MinnesotaPrecipitation <- ldply (json_fileMN, data.frame)
#Check dataframe
MinnesotaPrecipitation
#Get monthly sums of precipitation
monthlySums_MN <- tapply(MinnesotaPrecipitation$value, MinnesotaPrecipitation$date,sum)

#Build dataframe to display
myDF_MN <- data.frame("Months" = 1:length(monthlySums_MN), "Rain" = monthlySums_MN)
myDF_MN$Year <- floor((1:length(monthlySums_MN) -1) / 12) + 2002

#Check results
myDF_MN$Months
myDF_MN$Year


#length(myDF$Color)
# Basic line plot with points
ggplot(data=myDF_MN, aes(x=myDF_MN$Months, y=myDF_MN$Rain/1000, group=1))+#,color = myDF$Year)) +
  geom_line()+
  geom_point()+
  labs(x="Months since Jan 2002", y="Rainfall (m)")+
  ggtitle("Monthy Rainfall in Minnesota") #+ 
#scale_color_manual(breaks = c(2002, 2003, 2004),
#values=c("red", "blue", "green"))

#Wisconsin
json_fileWI <- fromJSON("/home/leahy8/JOHN_DEERE_PROJECT/WisconsinPrecipitation.json")
#Convert rhe JSON file to a dataframe
WisconsinPrecipitation <- ldply (json_fileWI, data.frame)
#Check dataframe
WisconsinPrecipitation
#Get monthly sums of precipitation
monthlySums_WI <- tapply(WisconsinPrecipitation$value, WisconsinPrecipitation$date,sum)

#Build dataframe to display
myDF_WI <- data.frame("Months" = 1:length(monthlySums_WI), "Rain" = monthlySums_WI)
myDF_WI$Year <- floor((1:length(monthlySums_WI) -1) / 12) + 2002

#Check results
myDF_WI$Months
myDF_WI$Year


#length(myDF$Color)
# Basic line plot with points
ggplot(data=myDF_WI, aes(x=myDF_WI$Months, y=myDF_WI$Rain/1000, group=1))+#,color = myDF$Year)) +
  geom_line()+
  geom_point()+
  labs(x="Months since Jan 2002", y="Rainfall (m)")+
  ggtitle("Monthy Rainfall in Wisconsin") #+ 
#scale_color_manual(breaks = c(2002, 2003, 2004),
#values=c("red", "blue", "green"))
