source('loadData.R')

loadDataFile()

library('data.table')

# 1. Loading features
features <- fread('data/UCI HAR Dataset/features.txt')
setnames(features, c("colNum", "feature"))

# Loading and merging X values
## First read train and test file, and put the result in a list
allX <- lapply(c('data/UCI HAR Dataset/train/X_train.txt', 'data/UCI HAR Dataset/test/X_test.txt'),
              read.delim, header=FALSE, sep="")

## Bind all element in the list (here the train file and the test file)
allX_data <- rbindlist(allX)

## Configure column names with the loaded features
setnames(allX_data, features$feature)

# Loading the activities (Y values)
## Again, first read train and test file, and put the result in a list
allY <- lapply(c('data/UCI HAR Dataset/train/y_train.txt', 'data/UCI HAR Dataset/test/y_test.txt'),
               read.delim, header=FALSE, sep="")

## Bind all element in the list (here the train file and the test file)
allY_data <- rbindlist(allY)

# Loading the subjects
## Todo

# 2. Filter mean and std column
## Here we use 'grep' to extract columns with mean or std in their name
meanAndStdColumns <- grep("-mean[(]|-std[(]", features$feature, value=TRUE)

## Then we filter on the mean and std columns
allX_dataSubset <- subset(allX_data, select = names(allX_data) %in% meanAndStdColumns)

# 3. Load activity names (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
activity <- read.delim('data/UCI HAR Dataset/activity_labels.txt', sep="", header=FALSE)
allX_dataSubset$activityLabel <- factor(allY_data$V1, levels= activity$V1, labels=activity$V2)
