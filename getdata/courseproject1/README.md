# Introduction

This repository contains the implementation of the course project for the MOOC GetData on Coursera.
The purpose is to create a tidy dataset from another (less tidy) dataset.

The dataset is used for Human Activity Recognition Using Smartphones. It contains data on experiments where
people moves where recorded with the sensor signal (accelerometer, gyroscope) of a Samsung Galaxy S.

The dataset is split across several files:

| File    | Content |
| ------- | ------- |
| activity_labels.txt | Contains the activities labels (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) |
| features_info.txt | Feature description, how they are calculated... |
| features.txt | List of all features. It will be used to extract column names |

Then there are two dataset (train and test), and foreach:

| File    | Content |
| ------- | ------- |
| subject_{train,test}.txt | List of subject by observation |
| X_{train,test}.txt | The observation with as many features as described in the features.txt file |
| y_{train,test}.txt | The observed activities |

subject_{train,test}.txt, X_{train,test}.txt and y_{train,test}.txt have the same length.

# Extracted values

Variables are described in the [CodeBook](./CodeBook.md). The main objective was to extract variables that
match only the mean() or std(), so we can focus on means and standard deviation.
Then variables were slightly renamed to remove parenthesis and replace '-' by '.'.

At last, the tidy data set contains means for each of those extracted variables for each activity then by each subject.

# Generate the tidy dataset

Clone this repository, then open the script with R:
    source('run_analysis.R')

You might need to install the following packages first: data.table, plyr.

The data is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, and unzip'ed in the `data/` directory.

The run_analysis writes the result in a file tidyData.csv in the current working directory. Format of this file is 
described in the [CodeBook](./CodeBook.md) file.