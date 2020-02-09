require(RJSONIO)# Read JSON file
library(plyr) # mropa's answer   https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
library(ggplot2)

state = "Michigan" #First letter must be uppercase
parameterFile = "~/JohnDeere/John-Deere-Project/Data/Michigan_GSOM_PRCP.json"
plotTitle = 'Michigan Crop Yield vs. PRCP'
xlabel = "Average GSOM per County Precipitation (mm)"
ylabel = "Yield (bushels per acre"
minMonth = 4 #March (inclusive)
maxMonth = 10 #October (inclusive)



#April through October


#Read Yield CSV file
region_yield <- read.csv("~/JohnDeere/John-Deere-Project/Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv")
state_yield <- subset(region_yield, State == toupper(state))

#Get PRCP file and read into dataframe
paramJSON <- fromJSON(parameterFile)
param <- ldply(paramJSON, data.frame, stringsAsFactors=F)

#Get crop yield values for each county
myDF = data.frame(County = state_yield$County, Yield = state_yield$Value, Year = state_yield$Year, stringsAsFactors=F)

#Parse Date column into year and month column
param$year <- lapply(param$date, substr, 1, 4)
param$year <- lapply(param$year, as.numeric) #convert to number
param$year <- unlist(param$year, use.names=FALSE) #convert to vector
param$month <- lapply(param$date, substr, 6, 7)
param$month <- lapply(param$month, as.numeric) #convert to number
param$month <- unlist(param$month, use.names=FALSE) #convert to vector

#Average PRCP readings for each station in a county
param <- subset(param, month >= minMonth & month <= maxMonth) #Keep only the entries for which month is between April and October
param <- param[!(param$county == ""),] #Remove empty counties
param <- aggregate(param$value,by=list(param$year,param$county), FUN=mean) #Tapply values for which the year and county is the same #https://stackoverflow.com/questions/5216015/tapply-function-dependent-on-multiple-columns-in-r
#Mean of Average Monthly precipitation for county year combo
#Failed Below
#myDF$Precipitation <- tapply(prcp$value, prcp$county, mean) #Only does by county, need to account for year as well
#res <- aggregate(value ~ year+county, data = prcp, mean) #Incorrect usage?

names(param) <- c('Year', 'County', 'Parameter') #Rename columns
param$County <- sapply(param$County, toupper) #Rewrite county column to match that in myDF
param$County = substr(param$County,1,nchar(param$County) - 7)

#Add to main dataset (tapply for when COUNTY AND YEAR ARE SAME)
myDF2 <- merge(myDF, param, by=c("County", "Year"), all.x=TRUE)
#myDF2 <- subset(myDF2, select=c("County", "Yield", "Year", "Precipitation")) # NOT NEEDED ANYMORE #Keep only important columns
corVal <- cor(na.omit(myDF2)$Parameter, na.omit(myDF2)$Yield) #Get correlation
newTitle <- paste(plotTitle, '   R=', round(corVal, digits=3))

#Plot Data
ggplot(myDF2, aes(x=Parameter, y=Yield)) + geom_point() + ggtitle(newTitle) + xlab(xlabel) + ylab(ylabel)

  #legend(x='bottomright', legend='test') #paste('Cor =',corVal))


