# Github: https://github.com/geraudster/datasciencecoursera/blob/master/exdata/courseproject2/plot6.R
# Comment out the two lines below to retrieve the data
#source("loadData.R")
#loadDataFile("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data/FNEI_data.zip")

## This test is for avoiding to reload data
if(!exists("NEI")) {
    print("Loading NEI data...")
    NEI <- readRDS("data/summarySCC_PM25.rds")
}
# Print size in memory
format(object.size(NEI), units="MB")

SCC <- readRDS("data/Source_Classification_Code.rds")
# Print size in memory
format(object.size(SCC), units="MB")

# Use packages
library(plyr)
library(ggplot2)

# Prepare data
motorVehicleSCC <- SCC[SCC$SCC.Level.One == "Mobile Sources", c("SCC", "Short.Name")]

## Extract and sum data
baltimoreLAData <- NEI[NEI$fips %in% c("24510", "06037") & NEI$SCC %in% motorVehicleSCC$SCC, c("year", "Emissions", "SCC", "fips")]
baltimoreLADataSum <- ddply(baltimoreLAData, .(year, fips), numcolwise(sum))

## Prepare the labels
baltimoreLADataSum$city[baltimoreLADataSum$fips == "24510"] <- "Baltimore"
baltimoreLADataSum$city[baltimoreLADataSum$fips == "06037"] <- "Los Angeles"

# Plotting function
myPlot <- function() {
    ggplot(baltimoreLADataSum, aes(year, Emissions)) +
        geom_point(aes(color=city)) +
        geom_line(aes(color=city), linetype=2) +
        stat_smooth(aes(color=city), method=lm, se=FALSE) +
        facet_grid(. ~ city) +
        xlab("Year") + ylab("Total Emissions (in tons)") +
        labs(title = "Comparison of Motor Vehicle Emissions \n Baltimore vs. Los Angeles")
}

# Plot in png file
png("plot6.png", width=600, height=480)
myPlot()
dev.off()

# Plot on screen
print(myPlot())
