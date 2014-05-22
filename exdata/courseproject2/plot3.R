# Comment out the two lines below to retrieve the data
#source("loadData.R")
#loadDataFile("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data/FNEI_data.zip")

NEI <- readRDS("data/summarySCC_PM25.rds")
# Print size in memory
format(object.size(NEI), units="MB")

SCC <- readRDS("data/Source_Classification_Code.rds")
# Print size in memory
format(object.size(SCC), units="MB")

# Prepare data
baltimoreData <- NEI[NEI$fips == "24510", c("year", "Emissions", "type")]
baltimoreData <- transform(baltimoreData, type=factor(type), year=factor(year))
str(baltimoreData)

library(ggplot2)
# Plotting function
myPlot <- function() {
    ggplot(baltimoreData, aes(year, Emissions)) +
    stat_summary(fun.y=sum, geom="bar", aes(color=type)) +
    facet_grid(. ~ type)
}

# Plot on screen
myPlot()

# Plot in png file
png("plot3.png", width=600, height=300)
myPlot()
dev.off()
