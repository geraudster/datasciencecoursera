# Github: https://github.com/geraudster/datasciencecoursera/blob/master/exdata/courseproject2/plot3.R
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

# Prepare data
baltimoreData <- NEI[NEI$fips == "24510", c("year", "Emissions", "type")]
baltimoreData <- transform(baltimoreData, type=factor(type))
baltimoreDataSum <- ddply(baltimoreData, .(type, year), numcolwise(sum))

library(ggplot2)
# Plotting function
myPlot <- function() {
    ggplot(baltimoreDataSum, aes(year, Emissions)) +
        geom_point(aes(color=type)) +
        geom_line(aes(color=type), linetype=2) +
        stat_smooth(aes(color=type), method=lm, se=FALSE) +
        facet_grid(. ~ type) +
        xlab("Year") + ylab("Total Emissions (in tons)") +
        labs(title = "Evolution of Total Emissions By Type")
}

# Plot in png file
png("plot3.png", width=600, height=300)
myPlot()
dev.off()

# Plot on screen
print(myPlot())
