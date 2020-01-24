require(RJSONIO)# Read JSON file
library(plyr) # mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)

regionYieldData <- read.csv("/home/lee3349/JOHN DEERE/Crop_Yield_County_NorthernMW_2002-12_modified.csv")

#Read JSON File
MichiganTMAX <- fromJSON("/home/lee3349/JOHN DEERE/Michigan_GSOM_TMAX.json")

#Convert the JSON file to a dataframe
MichiganTMAX <- ldply (MichiganTMAX, data.frame)

#Sum up crop yield data by year
MichiganYieldData <- subset(regionYieldData, State == "MICHIGAN") #IOWA entries only, same number reported each year
MichiganYieldData <- tapply(MichiganYieldData$Value, MichiganYieldData$Year, sum) #Iowa total crop yield per year
Michigan = data.frame(year=c(2002,2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012), cropyield=MichiganYieldData[[1]])
for (i in 1:11) {
  Michigan$cropyield[i] = MichiganYieldData[[i]]
}
pre = tapply(MichiganTMAX$value, MichiganTMAX$date, mean)

i = 4
k = 1
while (i < 132) {
  total = 0
  for (j in 1:7) {
    total = total + pre[[i]]
    i = i + 1
    j = j + 1
  }
  Michigan$TMAX[k] = total
  i = i + 5
  k = k + 1
}

ggplot(Michigan, aes(x=TMAX, y=cropyield)) + geom_point()
cor(Michigan$TMAX, Michigan$cropyield) # 0.3926




