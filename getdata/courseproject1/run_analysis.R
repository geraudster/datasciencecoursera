source('loadData.R')

loadDataFile()

library('data.table')

## Loading features
features <- fread('data/UCI HAR Dataset/features.txt')
setnames(features, c("colNum", "feature"))

## Loading X values
allX <- lapply(c('data/UCI HAR Dataset/train/X_train.txt', 'data/UCI HAR Dataset/test/X_test.txt'),
              read.delim, header=FALSE, sep="")
allX_data <- rbindlist(allX)
setnames(allX_data, features$feature)

## Loading Y values
allY <- lapply(c('data/UCI HAR Dataset/train/y_train.txt', 'data/UCI HAR Dataset/test/y_test.txt'),
               read.delim, header=FALSE, sep="")
allY_data <- rbindlist(allY)

## Filter mean and std column
meanAndStdColumns <- grep("mean[(]|std[(]", features$feature, value=TRUE)
allX_dataSubset <- subset(allX_data, select = names(allX_data) %in% meanAndStdColumns)

## Load activity names
activity <- read.delim('data/UCI HAR Dataset/activity_labels.txt', sep="", header=FALSE)
allX_dataSubset$activityLabel <- factor(allY_data$V1, levels= activity$V1, labels=activity$V2)
