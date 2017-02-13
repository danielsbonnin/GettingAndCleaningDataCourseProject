## read in feature labels file
## return row of unique feature labels
readLabels <- function (features) {
  require(dplyr)
  ## Read newline delimited text file of feature names
  read.table(features, stringsAsFactors = FALSE) %>%
  
  ## Convert to plyr table
  tbl_df() %>%
  
  ## Combine index column with label column to ensure uniqueness
  mutate(newName = paste(as.character(V1), V2)) %>%
  
  ## Retain only the new, combined column
  select(3) %>%
  
  ## Transpose table to be a row vs a column
  t()
}

## Read in data from test or training set, and apply labels
formatActivityData <- function(x, names, activity_labels, subject_labels) {
  require(dplyr)
  names <- readLabels(names)
  theData <- read.table(x)
  
  ## Get activity and subject labels
  activity <- read.table(activity_labels)
  subject <- read.table(subject_labels)
  
  ## Add column headers to activity and subject columns
  colnames(activity) <- "activity"
  colnames(subject) <- "subject"
  
  ## Add column headers to all features
  colnames(theData) <- names
  
  ## Bind into 1 table
  bound <- cbind(theData, activity, subject)
  
  ## Return tbl_df
  tbl_df(bound)
}

## Bind formatted tables from training and test sets
combine_AR_tables <- function(features, test, train, activities_test, activities_train, subjects_test, subjects_train) {
  require(dplyr)
  names <- readLabels(features)
  
  test <- formatActivityData(test, features, activities_test, subjects_test)
  train <- formatActivityData(train, features, activities_train, subjects_train)
  rbind(test, train)
}

## Convert raw gyroscope and accelerometer data into a tidy data set.
tidy_ar_tables <- function(features, activities, test, train, activities_test, activities_train, subjects_test, subjects_train) {
  require(dplyr)
  ## Read in list of activity labels
  activities_tbl <- tbl_df(read.table(activities))
  
  ## Bind test and training sets, along with activity and subject columns
  combined <- combine_AR_tables(features, test, train, activities_test, activities_train, subjects_test, subjects_train)
  
  ## Remove all but mean and standard deviation data. 
  select(combined, grep("mean\\(\\)$|std\\(\\)$|activity|subject", colnames(combined))) %>%
    
  ## Replace numeric activity key with word labels
  merge(activities_tbl, by.x = "activity", by.y = "V1") %>%
  mutate(activity = V2) %>%
  select(-V2) -> summarized
  
  ## Clean up column headers for readability
  colnames(summarized) <- gsub("^[0-9]+ ", "", colnames(summarized))
  colnames(summarized) <- gsub("tBody", "time_body", colnames(summarized))
  colnames(summarized) <- gsub("tGravity", "time_gravity", colnames(summarized))
  colnames(summarized) <- gsub("fBody", "fourier_body", colnames(summarized))
  colnames(summarized) <- gsub("fGravity", "fourier_gravity", colnames(summarized))
  colnames(summarized) <- gsub("yGyro", "y_gyroscope", colnames(summarized))
  colnames(summarized) <- gsub("yAcc", "y_accelerometer", colnames(summarized))
  colnames(summarized) <- gsub("bodyBody", "body", colnames(summarized))
  colnames(summarized) <- gsub("rJerk", "r_jerk", colnames(summarized))
  colnames(summarized) <- gsub("eJerk", "e_jerk", colnames(summarized))
  colnames(summarized) <- gsub("rMag", "r_magnitude", colnames(summarized))
  colnames(summarized) <- gsub("eMag", "e_magnitude", colnames(summarized))
  colnames(summarized) <- gsub("kMag", "k_magnitude", colnames(summarized))
  colnames(summarized) <- gsub("-mean\\(\\)", "_mean", colnames(summarized))
  colnames(summarized) <- gsub("-std\\(\\)", "_std", colnames(summarized))
  summarized
}

## Calculate the mean of each column, grouped by activity and subject
summarize_AR_data <- function(arData) {
  require(dplyr)
  group_by(arData, activity, subject) %>%
  summarize_each(funs(mean))
} 
