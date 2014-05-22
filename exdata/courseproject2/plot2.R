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
baltimoreData <- NEI[NEI$fips == "24510", c("year", "Emissions")]
NEISplit <- split(baltimoreData$Emissions, factor(baltimoreData$year))
sumByYear <- sapply(NEISplit, sum)

# Plotting function
myPlot <- function() {
    plot(names(sumByYear), sumByYear, 
         xlab="Year",
         ylab="Total emissions (in tons)",
         main="Evolution of Total Emissions from 1999 to 2008 in Baltimore", 
         type="b", pch=19, lty=2)
}

# Plot on screen
myPlot()

# Plot in png file
png("plot2.png")
myPlot()
dev.off()
