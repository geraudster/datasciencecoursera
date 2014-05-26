if(!file.exists("data")) { dir.create("data")}

# Q1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
filename <- "data/ss06hid.csv"
download.file(url, filename, method="curl")
data <- read.csv(filename)
strsplit(names(data), "wgtp")[123]

# Q2
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
removeComma <- function (x) gsub(",", "", x)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url, "data/GDP.csv", method = "curl")
data <- read.table("data/GDP.csv", sep=",", skip=5, nrows=190, quote="\"", fileEncoding="latin1")
countryData <- data[,c(1,2,4,5)]
colnames(countryData) <- c("countryId", "rank", "countryName", "GDP")
countryData$GPDInt <- as.integer(removeComma(trim(countryData$GDP)))
mean(countryData$GPDInt)

# Q3
grep("^United",countryData$countryName)

# Q4
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url, "data/country.csv", method = "curl")
country <- read.csv("data/country.csv")

str(data)
str(country)

dataMerge <- merge(country, countryData, by.x="CountryCode", by.y="countryId", all=TRUE)
length(grep("^Fiscal year end: June", dataMerge$Special.Notes))

# Q5
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

install.packages("lubridate")
library(lubridate)
sampleTimesDate = ymd(sampleTimes)
samplesYear2012 = year(sampleTimesDate) == 2012
sum(samplesYear2012)
sum(wday(sampleTimesDate[samplesYear2012], label=TRUE) == "Mon")
