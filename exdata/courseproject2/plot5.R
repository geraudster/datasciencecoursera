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

baltimoreData <- NEI[NEI$fips == "24510" & NEI$SCC %in% motorVehicleSCC$SCC, c("year", "Emissions", "SCC")]
baltimoreDataSum <- ddply(baltimoreData, .(year), numcolwise(sum))

# Plotting function
myPlot <- function() {
    ggplot(baltimoreDataSum, aes(year, Emissions)) +
        geom_point() +
        geom_line(linetype=2) +
        stat_smooth(method=lm, se=FALSE) +
        xlab("Year") + ylab("Total Emissions (in tons)") +
        labs(title = "Evolution of Motor Vehicle Emissions in Baltimore")
}

# Plot in png file
png("plot5.png", width=600, height=300)
myPlot()
dev.off()

# Plot on screen
print(myPlot())
