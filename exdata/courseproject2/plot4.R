# Github: https://github.com/geraudster/datasciencecoursera/blob/master/exdata/courseproject2/plot4.R
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
library(sqldf)
library(plyr)
library(ggplot2)

# Prepare data

## Function for displaying long labels
shortenString <- function(str, n = 40) {
    withoutPrefix <- gsub("Stationary Fuel Comb /", "", str)
    if(nchar(withoutPrefix) < n) {
        # nothing to do
        withoutPrefix
    } else {
        gsub(paste("^(.{", n-3, "}).*$", sep=""), "\\1...", withoutPrefix)
    }
}

## Retrieve SCC code corresponding to "Fuel Comb something Coal"
coalCombustionLogical <- grep("Fuel Comb.*Coal", SCC$Short.Name, ignore.case=TRUE)
coalCombustionData <- NEI[NEI$SCC %in% SCC[coalCombustionLogical, "SCC"], c("SCC", "Emissions", "year")]

## Play with sqldf to sum by year
coalEmissionSum <- sqldf("select Short_Name, year, sum(Emissions) as Emissions
                         from coalCombustionData join SCC on coalCombustionData.SCC = SCC.SCC
                         group by SCC.SCC, year")

## Prepare labels to show in the graph:
## SCCLabelFactor contains full labels for the legend
SCCLabelFactor <- factor(coalEmissionSum$Short_Name)
## SCCLabelFactorShort contains short labels for the facet titles
SCCLabelFactorShort <- factor(coalEmissionSum$Short_Name, labels = sapply(levels(SCCLabelFactor), function(x) shortenString(x,n=40)))

## Shorten the labels in the final data.frame
coalEmissionSum <- transform(coalEmissionSum, Short_Name = SCCLabelFactorShort )

# Plotting function
## Here we use a facet_wrap, as we have only 9 Fuel Comb/Coal sources,
## it will make a nice graph :)
myPlot <- function() {
    ggplot(coalEmissionSum, aes(year, Emissions)) +
        geom_point(aes(color=Short_Name)) +
        geom_line(aes(color=Short_Name), linetype=2) +
        stat_smooth(aes(color=Short_Name), method=lm, se=FALSE) +
        facet_wrap( ~ Short_Name, scales = "free_y", ncol=3) +
        scale_colour_discrete(name  ="Source type",
                              breaks=levels(SCCLabelFactorShort),
                              labels=levels(SCCLabelFactor)) +
        ggtitle("Detailed Evolution of Emissions of Coal Combustion across United States") +
        xlab("Year") + ylab("Total Emissions (in tons)")
}

# Plot in png file
png("plot4.png", width=1200, height=600)
myPlot()
dev.off()

# Plot on screen
print(myPlot())
