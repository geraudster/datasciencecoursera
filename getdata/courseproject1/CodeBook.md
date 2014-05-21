# Code Book

This document describes the tidy dataset generated with the run_analysis command.

# File format

Tidy dataset is a CSV file with header. String fields are surrounded by quotes (").

The file can be loaded in R, with the following command:

    tidyData <- read.csv("tidyData.csv")

The dataset contains 180 observations (6 activities x 30 subjects), and 68 fields by observations.

# Fields description

| Field | Description | Origin |
| ----- | ----------- | ------ |
| activityLabel | the label of the activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) | Taken from a join between y_{train,test}.txt and activity_labels.txt |
| subject | the subject identifier | Taken from the subject_{train,test}.txt and merged with observations |


Then the next values are the means by activity and subject of the mean and std variables from the X_{train,test}.txt files:

| Field | Description |
| ----- | ----------- |
| tBodyAcc / fBodyAcc (mean and std for X,Y,Z) | Body Acceleration (time and frequency) |
| tGravityAcc (mean and std for X,Y,Z) | Gravity Acceleration (time only) |
| tBodyAccJerk / fBodyAccJerk (mean and std for X,Y,Z) | Body Acceleration Jerk (time and frequency) |
| tBodyGyro / fBodyGyro (mean and std for X,Y,Z) | Body Gyroscope (time and frequency) |
| tBodyGyroJerk / fBodyGyroJerk  (mean and std for X,Y,Z) | Body Gyroscope Jerk (time and frequency) |
| tBodyAccMag / fBodyAccMag (mean and std) | Body Acceleration Magnitude (time and frequency) |
| tGravityAccMag (mean and std) | Gravity Acceleration Magnitude (time only) |
| tBodyAccJerkMag / fBodyAccJerkMag (mean and std) | Body Acceleration Jerk Magnitude (time and frequency) |
| tBodyGyroMag / fBodyGyroMag (mean and std) | Body Gyroscope Magnitude (time and frequency) |
| tBodyGyroJerkMag / fBodyGyroJerkMag (mean and std) | Body Gyroscope Jerk Magnitude (time and frequency) |

