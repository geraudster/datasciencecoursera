# Introduction

This repository contains the implementation of the course project for the MOOC GetData on Coursera.
The purpose is to create a tidy dataset from another (less tidy) dataset.

The dataset is used for Human Activity Recognition Using Smartphones. It contains data on experiments where
people moves where recorded with the sensor signal (accelerometer, gyroscope) of a Samsung Galaxy S.

The dataset is splitted across several files:

| File    | Content |
| ------- | ------- |
| activity_labels.txt | Contains the activities labels (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) |


# Generate the tidy dataset

Clone this repository, then open the script with R:
    source('run_analysis.R')

You might need to install the following packages first: data.table