source('loadData.R')

loadDataFile()

library('data.table')

# read and merge train & test dataset
# dataset should be X, Y or subject
readTrainAndTest <- function (dataset) {
    ## First read train and test file, and put the result in a list
    data.train <- read.delim(paste("data/UCI HAR Dataset/train/", dataset, "_train.txt", sep=""), header=FALSE, sep="")
    data.test <- read.delim(paste("data/UCI HAR Dataset/test/", dataset, "_test.txt", sep=""), header=FALSE, sep="")

    ## Bind all element in the list (here the train file and the test file)
    rbind(data.train, data.test)    
}

# 1. Loading features
features <- fread('data/UCI HAR Dataset/features.txt')
setnames(features, c("colNum", "feature"))

# Loading and merging X values
## Read X data
allX <- readTrainAndTest("X")
## Configure column names with the loaded features
setnames(allX, features$feature)

# Loading the activities (Y values)
## Read y data
allY <- readTrainAndTest("y")

# Loading the subjects
allSubject <- readTrainAndTest("subject")

# 2. Filter mean and std column
## Here we use 'grep' to extract columns with mean or std in their name
meanAndStdColumns <- grep("-mean[(]|-std[(]", features$feature, value=TRUE)

## Then we filter on the mean and std columns
allXSubset <- allX[,meanAndStdColumns]

## Let's rename the column to remove parenthesis, replace - with .
names(allXSubset) <- gsub("(.*)-(mean|std)[(][)]-?(.*)", "\\1.\\2.\\3",names(allXSubset))

# 3. Load activity names (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
activity <- read.delim('data/UCI HAR Dataset/activity_labels.txt', sep="", header=FALSE)

# 4. Add activity labels to all observations
allXSubset$activityLabel <- factor(allY$V1, levels= activity$V1, labels=activity$V2)

# 5. Summarize data by calculating the means by activity then by subject
allXSubset$subject <- allSubject$V1
tidyData <- ddply(allXSubset, .(activityLabel, subject), numcolwise(mean))

write.csv(tidyData, "tidyData.csv")
