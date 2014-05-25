# Github: https://github.com/geraudster/datasciencecoursera/blob/master/exdata/courseproject2/plot2.R
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
    abline(lm(sumByYear ~ as.numeric(names(sumByYear))), lwd = 2, col = "red")
    legend("topright", lty = c(2,1), col = c("black", "red"), legend = c("Total Emission", "Trend"))
}

# Plot on screen
myPlot()

# Plot in png file
png("plot2.png")
myPlot()
dev.off()
