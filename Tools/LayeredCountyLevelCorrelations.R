require(RJSONIO)# Read JSON file
library(plyr) # mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)
library(RColorBrewer) #colors

parameterFile = "~/JohnDeere/John-Deere-Project/Data/Wisconsin_GSOM_PRCP.json"
parameterFile2 = "~/JohnDeere/John-Deere-Project/Data/Iowa_GSOM_PRCP.json"
parameterFile3 = "~/JohnDeere/John-Deere-Project/Data/Michigan_GSOM_PRCP.json"
parameterFile4 = "~/JohnDeere/John-Deere-Project/Data/Minnesota_GSOM_PRCP.json"
plotTitle = 'Yield vs. PRCP'
xlabel = "Total Monthly Precipitation (mm)"
ylabel = "Yield (bushels per acre)"
minMonth = 4 #April (inclusive)
maxMonth = 10 #October (inclusive)

#Read Yield CSV file
region_yield <- read.csv("~/JohnDeere/John-Deere-Project/Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv")
state_yield <- subset(region_yield, State == toupper('WISCONSIN'))
state_yield2 <- subset(region_yield, State == toupper('IOWA'))
state_yield3 <- subset(region_yield, State == toupper('MICHIGAN'))
state_yield4 <- subset(region_yield, State == toupper('MINNESOTA'))

#Get PRCP file and read into dataframe
paramJSON <- fromJSON(parameterFile)
paramJSON2 <- fromJSON(parameterFile2)
paramJSON3 <- fromJSON(parameterFile3)
paramJSON4 <- fromJSON(parameterFile4)
param <- ldply(paramJSON, data.frame, stringsAsFactors=F)
param2 <- ldply(paramJSON2, data.frame, stringsAsFactors=F)
param3 <- ldply(paramJSON3, data.frame, stringsAsFactors=F)
param4 <- ldply(paramJSON4, data.frame, stringsAsFactors=F)

#Get crop yield values for each county
myDF = data.frame(County = state_yield$County, Yield = state_yield$Value, Year = state_yield$Year, stringsAsFactors=F)
myDF2 = data.frame(County = state_yield2$County, Yield = state_yield2$Value, Year = state_yield2$Year, stringsAsFactors=F)
myDF3 = data.frame(County = state_yield3$County, Yield = state_yield3$Value, Year = state_yield3$Year, stringsAsFactors=F)
myDF4 = data.frame(County = state_yield4$County, Yield = state_yield4$Value, Year = state_yield4$Year, stringsAsFactors=F)

#Parse Date column into year and month column
param$year <- lapply(param$date, substr, 1, 4)
param$year <- lapply(param$year, as.numeric) #convert to number
param$year <- unlist(param$year, use.names=FALSE) #convert to vector
param$month <- lapply(param$date, substr, 6, 7)
param$month <- lapply(param$month, as.numeric) #convert to number
param$month <- unlist(param$month, use.names=FALSE) #convert to vector

param2$year <- lapply(param2$date, substr, 1, 4)
param2$year <- lapply(param2$year, as.numeric) #convert to number
param2$year <- unlist(param2$year, use.names=FALSE) #convert to vector
param2$month <- lapply(param2$date, substr, 6, 7)
param2$month <- lapply(param2$month, as.numeric) #convert to number
param2$month <- unlist(param2$month, use.names=FALSE) #convert to vector

param3$year <- lapply(param3$date, substr, 1, 4)
param3$year <- lapply(param3$year, as.numeric) #convert to number
param3$year <- unlist(param3$year, use.names=FALSE) #convert to vector
param3$month <- lapply(param3$date, substr, 6, 7)
param3$month <- lapply(param3$month, as.numeric) #convert to number
param3$month <- unlist(param3$month, use.names=FALSE) #convert to vector

param4$year <- lapply(param4$date, substr, 1, 4)
param4$year <- lapply(param4$year, as.numeric) #convert to number
param4$year <- unlist(param4$year, use.names=FALSE) #convert to vector
param4$month <- lapply(param4$date, substr, 6, 7)
param4$month <- lapply(param4$month, as.numeric) #convert to number
param4$month <- unlist(param4$month, use.names=FALSE) #convert to vector

#Average PRCP readings for each station in a county
param <- subset(param, month >= minMonth & month <= maxMonth) #Keep only the entries for which month is between April and October
param <- param[!(param$county == ""),] #Remove empty counties
param <- aggregate(param$value,by=list(param$year,param$county), FUN=mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r
param2 <- subset(param2, month >= minMonth & month <= maxMonth) #Keep only the entries for which month is between April and October
param2 <- param2[!(param2$county == ""),] #Remove empty counties
param2 <- aggregate(param2$value,by=list(param2$year,param2$county), FUN=mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r
param3 <- subset(param3, month >= minMonth & month <= maxMonth) #Keep only the entries for which month is between April and October
param3 <- param3[!(param3$county == ""),] #Remove empty counties
param3 <- aggregate(param3$value,by=list(param3$year,param3$county), FUN=mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r
param4 <- subset(param4, month >= minMonth & month <= maxMonth) #Keep only the entries for which month is between April and October
param4 <- param4[!(param4$county == ""),] #Remove empty counties
param4 <- aggregate(param4$value,by=list(param4$year,param4$county), FUN=mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r

names(param) <- c('Year', 'County', 'Parameter') #Rename columns
param$County <- sapply(param$County, toupper) #Rewrite county column to match that in myDF
param$County = substr(param$County,1,nchar(param$County) - 7)
names(param2) <- c('Year', 'County', 'Parameter') #Rename columns
param2$County <- sapply(param2$County, toupper) #Rewrite county column to match that in myDF
param2$County = substr(param2$County,1,nchar(param2$County) - 7)
names(param3) <- c('Year', 'County', 'Parameter') #Rename columns
param3$County <- sapply(param3$County, toupper) #Rewrite county column to match that in myDF
param3$County = substr(param3$County,1,nchar(param3$County) - 7)
names(param4) <- c('Year', 'County', 'Parameter') #Rename columns
param4$County <- sapply(param4$County, toupper) #Rewrite county column to match that in myDF
param4$County = substr(param4$County,1,nchar(param4$County) - 7)

#Add to main dataset (tapply for when COUNTY AND YEAR ARE SAME)
myDFF <- merge(myDF, param, by=c("County", "Year"), all.x=TRUE)
myDF2F <- merge(myDF2, param2, by=c("County", "Year"), all.x=TRUE)
myDF3F <- merge(myDF3, param3, by=c("County", "Year"), all.x=TRUE)
myDF4F <- merge(myDF4, param4, by=c("County", "Year"), all.x=TRUE)

myDFF <- na.omit(myDFF) #remove empty rows
myDF2F <- na.omit(myDF2F)
myDF3F <- na.omit(myDF3F)
myDF4F <- na.omit(myDF4F)

megaDF <- data.frame(Parameter = c(myDFF$Parameter, myDF2F$Parameter, myDF3F$Parameter, myDF4F$Parameter),
                     Yield = c(myDFF$Yield, myDF2F$Yield, myDF3F$Yield, myDF4F$Yield))
corVal <- cor(na.omit(megaDF)$Parameter, na.omit(megaDF)$Yield) #Get correlation
newTitle <- paste(plotTitle, '   R=', round(corVal, digits=3))

myDFF$state <- "Wisconsin"
myDF2F$state <- "Iowa"
myDF3F$state <- "Michigan"
myDF4F$state <- "Minnesota"


#Plot Data
ggplot(NULL, aes(x=Parameter, y=Yield, group=state)) + 
  geom_point(data = myDFF, aes(color = "Wisconsin")) + 
  
  geom_point(data = myDF2F, aes(colour = "Minnesota")) + 
  
  geom_point(data = myDF3F, aes(colour = "Michigan")) + 
  
  geom_point(data = myDF4F, aes(colour = "Iowa")) + 
  
  ggtitle(newTitle)+
  labs(x=xlabel, y=ylabel, color="Legend")+
  theme(legend.position = "none")
 


