## Q1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
if(!file.exists('data')) {
  dir.create('data')
}
download.file(url, "data/quiz3.csv", method="curl")
data <- read.csv("data/quiz3.csv")
str(data)

# Acre = ACR, 10+ = 3
# Sales = AGS, 10000+ = 6
logiData <- data$ACR == 3 & data$AGS == 6

which(logiData)[1:3]

## Q2
#install.packages("jpeg")
library(jpeg)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url, "data/jeff.jpg", method="curl")
img <- readJPEG("data/jeff.jpg", native=TRUE)
quantile(img, probs=c(0.3, 0.8, NA))

## Q3
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
removeComma <- function (x) gsub(",", "", x)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url, "data/GDP.csv", method = "curl")
data <- read.table("data/GDP.csv", sep=",", skip=5, nrows=190, quote="\"")
countryData <- data[,c(1,2,4,5)]
colnames(countryData) <- c("countryId", "rank", "countryName", "GDP")
countryData$GPDInt <- as.integer(removeComma(trim(countryData$GDP)))


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url, "data/country.csv", method = "curl")
country <- read.csv("data/country.csv")

str(data)
str(country)

length(intersect(countryData$countryId, country$CountryCode))
dataMerge <- merge(country, countryData, by.x="CountryCode", by.y="countryId", all=TRUE)
top13 <- dataMerge[order(dataMerge$GPDInt, decreasing=TRUE),][13,]

## Q4
mean(dataMerge[dataMerge$Income.Group %in% c("High income: OECD"), "rank"], na.rm=TRUE)
mean(dataMerge[dataMerge$Income.Group %in% c("High income: nonOECD"), "rank"], na.rm=TRUE)

## Q5
#install.packages("Hmisc")
library(Hmisc)
dataMerge$rankGroup = cut2(dataMerge$rank,g=5)
#transform(dataMerge, rankGroup = factor(dataMerge$rankGroup, levels=c("High income: nonOECD", "High income: OECD", "Upper middle income", "Lower middle income", "Low income"), ordered=TRUE))
table(dataMerge$rankGroup, dataMerge$Income.Group)
