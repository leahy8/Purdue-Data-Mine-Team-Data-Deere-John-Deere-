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
aggregate(value ~ year+county, data = prcp, mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r
#myDF$Precipitation <- tapply(prcp$value, prcp$county, mean) #Only does by county, need to account for year as well
prcp$county <- sapply(prcp$county, toupper) #Rewrite county column to match that in myDF
prcp$county = substr(prcp$county,1,nchar(prcp$county) - 7)
names(prcp)[names(prcp) == 'county'] <- 'County' #Rename to prep for merge, https://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame
names(prcp)[names(prcp) == 'year'] <- 'Year'
names(prcp)[names(prcp) == 'value'] <- 'Precipitation'

#Add to main dataset (tapply for when COUNTY AND YEAR ARE SAME)
myDF2 <- merge(myDF, prcp, by=c("County", "Year"), all.x=TRUE)
myDF2 <- subset(myDF2, select=c("County", "Yield", "Year", "Precipitation")) #Keep only important columns

#Plot Data
ggplot(myDF2, aes(x=Precipitation, y=Yield)) + geom_point() + ggtitle('Michigan Crop Yield vs. PRCP')
cor(iowa$prcp, iowa$cropyield) # 0.3926
