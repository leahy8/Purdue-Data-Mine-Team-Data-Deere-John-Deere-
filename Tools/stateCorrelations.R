require(RJSONIO)# Read JSON file
library(plyr) # mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)

regionYieldData <- read.csv("~/John Deere/Crop_Yield_County_NorthernMW_2002-12_modified.csv")

#Read JSON File
IowaPRCPJSON <- fromJSON("~/John Deere/Iowa_GSOM_PRCP.json")

#Convert the JSON file to a dataframe
IowaPRCP <- ldply (IowaPRCPJSON, data.frame)

#Sum up crop yield data by year
IowaYieldData <- subset(regionYieldData, State == "IOWA") #IOWA entries only, same number reported each year
IowaYieldData <- tapply(IowaYieldData$Value, IowaYieldData$Year, sum) #Iowa total crop yield per year
iowa = data.frame(year=c(2002,2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012), cropyield=IowaYieldData[[1]])
for (i in 1:11) {
  iowa$cropyield[i] = IowaYieldData[[i]]
}
pre = tapply(IowaPRCP$value, IowaPRCP$date, mean)

i = 4
k = 1
while (i < 132) {
  total = 0
  for (j in 1:7) {
    total = total + pre[[i]]
    i = i + 1
    j = j + 1
  }
  iowa$prcp[k] = total
  i = i + 5
  k = k + 1
}

ggplot(iowa, aes(x=prcp, y=cropyield)) + geom_point() + ggtitle('Iowa Crop Yield vs. PRCP')
cor(iowa$prcp, iowa$cropyield) # 0.3926




