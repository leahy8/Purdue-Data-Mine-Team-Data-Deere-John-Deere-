require(RJSONIO)# Read JSON file
library(plyr) # mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame

regionYieldData <- read.csv("~/JohnDeere/John-Deere-Project/Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv")

#Read JSON File
stateDataJSON <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Iowa_GSOM_PRCP.json")

#Convert the JSON file to a dataframe
stateData <- ldply (stateDataJSON, data.frame)

#Sum up crop yield data by year
stateYieldData <- subset(regionYieldData, State == "IOWA") #IOWA entries only, same number reported each year
stateYieldData <- tapply(stateYieldData$Value, stateYieldData$Year, sum)

