require(RJSONIO)# Read JSON file
library(plyr) # mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)

#April through October
#change prcp to "stat"

#state = 'MICHIGAN' #Add in state

#Read Yield CSV file
region_yield <- read.csv("~/JohnDeere/John-Deere-Project/Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv")
state_yield <- subset(region_yield, State == 'MICHIGAN')

#Get PRCP file and read into dataframe
prcpJSON <- fromJSON("~/JohnDeere/John-Deere-Project/Data/Michigan_GSOM_PRCP.json")
prcp <- ldply (prcpJSON, data.frame, stringsAsFactors=F)

#Get crop yield values for each county
myDF = data.frame(County = state_yield$County, Yield = state_yield$Value, Year = state_yield$Year, stringsAsFactors=F)

#Parse Date column into year and month column
prcp$year <- lapply(prcp$date, substr, 1, 4)
prcp$year <- lapply(prcp$year, as.numeric) #convert to number
prcp$year <- unlist(prcp$year, use.names=FALSE) #convert to vector
prcp$month <- lapply(prcp$date, substr, 6, 7)
prcp$month <- lapply(prcp$month, as.numeric) #convert to number
prcp$month <- unlist(prcp$month, use.names=FALSE) #convert to vector

#Average PRCP readings for each station in a county
prcp <- subset(prcp, month > 3 & month < 11) #Keep only the entries for which month is between April and October
prcp <- prcp[!(prcp$county == ""),] #Remove empty counties
prcp <- aggregate(prcp$value,by=list(prcp$year,prcp$county), FUN=mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r
#Mean of Average Monthly precipitation for county year combo
#Failed Below
#myDF$Precipitation <- tapply(prcp$value, prcp$county, mean) #Only does by county, need to account for year as well
#res <- aggregate(value ~ year+county, data = prcp, mean) #Incorrect usage?

names(prcp) <- c('Year', 'County', 'Precipitation') #Rename columns
prcp$County <- sapply(prcp$County, toupper) #Rewrite county column to match that in myDF
prcp$County = substr(prcp$County,1,nchar(prcp$County) - 7)

#Add to main dataset (tapply for when COUNTY AND YEAR ARE SAME)
myDF2 <- merge(myDF, prcp, by=c("County", "Year"), all.x=TRUE)
#myDF2 <- subset(myDF2, select=c("County", "Yield", "Year", "Precipitation")) # NOT NEEDED ANYMORE #Keep only important columns

head(myDF2, n=10)
myDF2

length(myDF2$Year)

#Plot Data
ggplot(myDF2, aes(x=Precipitation, y=Yield)) + geom_point() + ggtitle('Michigan Crop Yield vs. PRCP')
cor(na.omit(myDF2)$Precipitation, na.omit(myDF2)$Yield) # 0.3926
