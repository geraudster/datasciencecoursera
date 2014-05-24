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
coalCombustionRow <- grep("Fuel Comb.*Coal", SCC$Short.Name, ignore.case=TRUE)
NEI <- transform(NEI, )
coalCombustionData <- NEI[NEI$SCC %in% SCC[coalCombustionRow, "SCC"], c("SCC", "Emissions", "year")]
library(sqldf)
coalEmissionSum <- sqldf("select SCC, year, sum(Emissions) as Emissions from coalCombustionData group by SCC, year")

library(ggplot2)
# Plotting function
myPlot <- function() {
    ggplot(coalEmissionSum, aes(year, Emissions)) +
        geom_point(aes(color=SCC)) +
        geom_line(aes(color=SCC), linetype=2) +
        stat_smooth(aes(color=SCC), method=lm, se=FALSE) +
        facet_wrap( ~ SCC, scales = "free_y", ncol=3)
}

# Plot in png file
png("plot4.png", width=800, height=600)
myPlot()
dev.off()

# Plot on screen
print(myPlot())
