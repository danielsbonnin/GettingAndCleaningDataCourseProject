Getting and Cleaning Data Course Project
Author: Daniel Bonnin
Data source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The file run_analysis.R contains functions to aggregate and summarize sensor 
data from 8 text files. 

==================
Usage Instructions
==================
* run_analysis.R requires the dplyr library

To obtain a tidy data set, containing the mean and standard deviation features
from the UCI HAR dataset, you will need to collect the following files:
    -features.txt
    -activity_labels.txt
    -X_test.txt
    -X_train.txt
    -y_test.txt
    -t_train.txt
    -subject_test.txt
    -subject_train.txt

The following script will obtain the data set: 

    tidied <- tidy_ar_tables("features.txt", "activity_labels.txt", "X_test.txt", "X_train.txt", "y_test.txt", "y_train.txt", "subject_test.txt", "subject_train.txt")

The following script will obtain the mean of each feature by activity and subject:
    summarized <- summarize_AR_data(tidied)

============================
Functions in run_analysis.R: 
============================

readLabels:
    Parameters:
        -features:  newline-delimited text file of feature names
    Returns: 
        -a row of feature names with numeric indices to ensure uniqueness

formatActivityData:
    Parameters:
        -x:     
            Text file containing table of sensor data. Rows delimited by newline,
            columns delimited by spaces
        -names:
            newline-delimited text file of feature names
        -activity_labels: 
            newline-delimited text file of activity names
        -subject_labels: 
            newline-delimited column of numeric subject labels
    Returns:
        -a table containing the sensor data, along with activity and subject labels

combine_AR_tables:
    Parameters:
        -features:  
            newline-delimited text file of feature names
        -activities: 
            newline-delimited text file of activity names
        -test:
            Text file containing test set table of sensor data. Rows delimited by newline,
            columns delimited by spaces
        -train:
            Text file containing training set table of sensor data. Rows delimited by newline,
            columns delimited by spaces
        -activities_test:
            Text file containing numeric activity labels for the test set. 
        -activities_train:
            Text file containing numeric activity labels for the training set. 
        -subjects_test:
            Text file containing numeric subject labels for the test set. 
        -subjects_train
            Text file containing numeric subject labels for the training set. 
    Returns: 
        -a table containing the combined sensor data, activity labels, and subject
            labels from the training and test data sets.

tidy_ar_tables:
    Parameters:
        -features:  
            newline-delimited text file of feature names
        -activities: 
            newline-delimited text file of activity names
        -test:
            Text file containing test set table of sensor data. Rows delimited by newline,
            columns delimited by spaces
        -train:
            Text file containing training set table of sensor data. Rows delimited by newline,
            columns delimited by spaces
        -activities_test:
            Text file containing numeric activity labels for the test set. 
        -activities_train:
            Text file containing numeric activity labels for the training set. 
        -subjects_test:
            Text file containing numeric subject labels for the test set. 
        -subjects_train
            Text file containing numeric subject labels for the training set. 
    Returns:
        -a tidy data set containing mean and standard deviation features. Column
            header names are human-readable.
            
summarize_AR_data:
    Parameters:
        -arData:
            Tidy data set able to be grouped by activity and subject.
    Returns:
        -table, grouped by activity, then subject. Contains the mean of every 
            column by activity and subject.             