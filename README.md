# cleaningdata
course project for the JHU 'getting and cleaning data' coursera course

This is a script that processes the Human Activity Recognition Using Smartphones Data Set (url = http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The data contains records of an experiment in which 30 subjects were asked to perform a series of activities with a smartphone in their pocket, and accelerometer and gyroscope data from the smartphone were recoreded. 

This script does the following:
1. load the data from a subdirectory of the working directory (assumed to be called "UCI HAR Dataset")
2. combine measurements, activity labels, and subject labels for each of the training and test datasets, then append those two into one complete dataset for the experiment
3. adds descriptive variable names for the 561 measure variables
4. extracts the measurement variables that contain means or standard deviations of a measure
5. adds descriptive names for the activity categories
6. creates a separate table with the means of each of the selected measurement variables, grouped by subject and activity (30 subjects, 6 activities each)

The tidyverse package is required to run this script
