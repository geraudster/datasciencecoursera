download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', 'puma.csv', method='curl')
downloaded <- date()

puma <- read.table('puma.csv', sep=',', header=TRUE)
head(puma)

head(puma$VAL)

# Q1
sum(!is.na(puma$VAL) & puma$VAL==24) # 24 = $1000000+

# Q2
head(puma$FES)

# Q3
install.packages("xlsx")
library(xlsx)
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx', 'DATA.gov_NGAP.xlsx', method= 'curl')
xlsxdownloaded <- date()

#datagov <- read.xlsx('DATA.gov_NGAP.xlsx', sheetIndex=1, header=TRUE, startRow=2)
dat <- read.xlsx('DATA.gov_NGAP.xlsx', sheetIndex=1, rowIndex=18:23, colIndex=7:15)
sum(dat$Zip*dat$Ext,na.rm=T) 

# Q4
install.packages("XML")
library(XML)
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml', 'restaurants.xml', method='curl')
restaurantDownloaded <- date()
doc <- xmlTreeParse('restaurants.xml', useInternalNodes=TRUE)

