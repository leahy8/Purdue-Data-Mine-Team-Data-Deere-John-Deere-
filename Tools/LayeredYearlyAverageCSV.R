library(ggplot2)

#Read the file
myDF <- read.csv("~/JohnDeere/John-Deere-Project/Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv")

#Get state subsets
MI <- subset(myDF, myDF$State=="MICHIGAN")
MN <- subset(myDF, myDF$State=="MINNESOTA")
IA <- subset(myDF, myDF$State=="IOWA")
WI <- subset(myDF, myDF$State=="WISCONSIN")

#Make a display DF for each state
display_MI <- data.frame(year = unique(MI$Year))
display_MI$yearAvg <- tapply(MI$Value, MI$Year, mean)

display_MN <- data.frame(year = unique(MN$Year))
display_MN$yearAvg <- tapply(MN$Value, MN$Year, mean)

display_IA <- data.frame(year = unique(IA$Year))
display_IA$yearAvg <- tapply(IA$Value, IA$Year, mean)

display_WI <- data.frame(year = unique(WI$Year))
display_WI$yearAvg <- tapply(WI$Value, WI$Year, mean)

# Add in a state column used for aesthetic grouping
display_MI$state <- "Wisconsin"
display_MN$state <- "Minnesota"
display_IA$state <- "Michigan"
display_WI$state <- "Iowa"


#No default; data explicitly specified for each geom
#http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/
ggplot(NULL, aes(x=year, y=yearAvg, group=state)) + 
  geom_point(data = display_WI, aes(color = "Wisconsin")) + 
  geom_line(data = display_WI, aes(year, yearAvg, color = "Wisconsin")) +
  
  geom_point(data = display_MN, aes(colour = "Minnesota")) + 
  geom_line(data = display_MN, aes(year, yearAvg, colour = "Minnesota")) + 
  
  geom_point(data = display_MI, aes(colour = "Michigan")) + 
  geom_line(data = display_MI, aes(year, yearAvg, colour = "Michigan")) + 
  
  geom_point(data = display_IA, aes(colour = "Iowa")) + 
  geom_line(data = display_IA, aes(year, yearAvg, colour = "Iowa")) +
  
  ggtitle("Yearly Average Crop Yield")+
  labs(x="Year", y="Crop Yield (Bushels per Acre)", color="Legend") +
  scale_x_continuous(breaks=display_WI$year)