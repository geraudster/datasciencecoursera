# Comment out the two lines below to retrieve the data
#source("loadData.R")
#loadDataFile("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data/FNEI_data.zip")

NEI <- readRDS("data/summarySCC_PM25.rds")
# Print size in memory
format(object.size(NEI), units="MB")

SCC <- readRDS("data/Source_Classification_Code.rds")
# Print size in memory
format(object.size(SCC), units="MB")

NEISplit <- split(NEI$Emissions, factor(NEI$year))
sumByYear <- sapply(NEISplit, sum)
plot(names(sumByYear), sumByYear, xlab="Year", ylab="Total emission", main="Total Emission from 1999 to 2008")
