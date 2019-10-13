#To begin, we read in the crop yield data.
CropYieldData <- read.csv('/home/leahy8/Downloads/Crop_Yield_County_NorthernMW_2002-12.csv')
#From here, we can use the tapply function to sort the data.
#The following line of code gives the average yield of each state over the entire period.
tapply(CropYieldData$Value, CropYieldData$State, mean)
#The Average corn yield of each state between 2002-2012 was the following:
# IOWA      MICHIGAN  MINNESOTA WISCONSIN 
# 162.3723  123.5847  147.3693  132.6208 
#
#To look at the data by state, we can use the subset function.
#The following line of code creates a data set for just Iowa.
IowaData <- subset(CropYieldData, CropYieldData$State == 'IOWA')
#The same command can be used to create subsets of each state.
MinnesotaData <- subset(CropYieldData, CropYieldData$State == 'MINNESOTA')
MichiganData <- subset(CropYieldData, CropYieldData$State == 'MICHIGAN')
WisconsinData <- subset(CropYieldData, CropYieldData$State == 'WISCONSIN')
#Now, we sort through these data sets to find all kinds of trends in the data.
#For example, we can look at the county in Iowa with the highest yield in 2002.
Iowa2002 <- subset(IowaData, IowaData$Year == '2002')
sort(tapply(Iowa2002$Value, Iowa2002$County, sum))
#Based on this, Scott County had the largest corn yield in Iowa in 2002 with 195.3 bushels per acre.
#From here, we need to figure out how to map the locations of counties in R (need some sort of coordinates)
#as well as a way to map these based on their variation of successful yield (sorting by rank).
