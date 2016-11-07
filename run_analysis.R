# ## Project Description
# 
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
# 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
#   * Merges the training and the test sets to create one data set.
# 
#   * Extracts only the measurements on the mean and standard deviation for each measurement.
# 
#   * Uses descriptive activity names to name the activities in the data set
# 
#   * Appropriately labels the data set with descriptive variable names.
# 
#   * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# 
#

## I. Get the data
#1. Download the file and put the file in the `data` folder
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destf1 <- "./data/Dataset.zip"
download.file(fileUrl, destfile = destf1, method='curl')

#2. Unzip the file
unzip(zipfile=destf1, exdir='./data')

#3. List out the files
path_to_file <- file.path("./data", "UCI HAR Dataset")
fs <- list.files(path_to_file, recursive = TRUE)
fs

# ```
# The following table depicts the structure of the data frame that will be used in the project.
# 
#   ----------------  ------------------------------------------------
#   variable names    | features    |     subject       | activity
#   ----------------  -------------- ------------------- -------------
#   
#   Data              | X_train.txt | subject_train.txt | y_train.txt
#                     |             |                   |
#                     | X_test.txt  | subject_test.txt  | y_test.txt 
#                     |             |                   |
#   ------------------------------------------------------------------
#   Table: Data Frame used in this project.
#   
#   1. Values of variable "activity" consist of data from "Y_train.txt" and "Y_test.txt"
#   2. Values of variable "features" consist of data from "X_train.txt" and "X_test.txt"
#   3. Values of variable "subject" consist of data from "subject_train.txt" and "subject_test.txt"
#   4. Names of variable "features" come from "features.txt"
#   5. Levels of variable "activity" come from "activity_labels.txt"
#   
#   We will use "activity", "subject", and "features" as part of descriptive variable names for the data frame. 
#   
# ```


##II. Read Data Files

#**0. A checkPercentage function** 
checkPercentage <- function(test, train) {
  # a fucntion to compute the percentage of rows in test w.r.t. the sum of 
  # the row in test and tain set. return -1 if error
  # 
  # Note: use it intelligently 
  #
  ans <- -1
  if (is.data.frame(test) & is.data.frame(train)) {
    nrow.test <- nrow(test)
    nrow.train <- nrow(train)
    total_row <- nrow.test + nrow.train
    ans <- nrow.test / total_row
  }
  return (ans)
}


#**1. Read the Activity file **
act_train_file <- file.path(path_to_file, "train", "y_train.txt")
data_Act_train <- read.table(act_train_file, header=FALSE) 

act_test_file <- file.path(path_to_file, "test", "y_test.txt")
data_Act_test <- read.table(act_test_file, header=FALSE) # use data_Act_test

#- 1.1 Check for "activity" data
percent_test <- checkPercentage(data_Act_test, data_Act_train) # it is roughly 0.3
percent_train <- checkPercentage(data_Act_train, data_Act_test) # it is roughly 0.7
print.noquote(paste("For Activities: percent_train=[", round(percent_train, digits = 4), "], percent_test=[", round(percent_test, digits =4) , "], total=[", (percent_test+percent_train), "].", sep=''))

#- 1.2 Look at the variables in data frame: **data_Act_train** (activity train set)
str(data_Act_train)

#- 1.3 Look at the varialbles in data frame: **data_Act_test** (activity test set)
str(data_Act_test)


#**2. Read the "subjects" file**
sub_train_file <- file.path(path_to_file, "train", "subject_train.txt")
data_Subject_train <- read.table(sub_train_file, header=FALSE) # use data_Subject_train

sub_test_file <- file.path(path_to_file, "test", "subject_test.txt")
data_Subject_test <- read.table(sub_test_file, header=FALSE) # use data_Subject_test

#- 2.1 Check for "subjects" data"
percent_train <- checkPercentage(data_Subject_train, data_Subject_test)
percent_test <- checkPercentage(data_Subject_test, data_Subject_train)
print.noquote(paste("For Subjects: percent_train=[", round(percent_train, digits = 4), "], percent_test=[", round(percent_test, digits =4) , "], total=[", (percent_test+percent_train), "].", sep=''))

#- 2.2 Look at the variables in data frame: **data_Subject_train** (subjects train set)
str(data_Subject_train)

#- 2.3 Look at the variables in data frame: **data_Subject_test** (subjects test set)
str(data_Subject_test)

#**3. Read the Features files**

features_train_file <- file.path(path_to_file, "train", "X_train.txt")
data_Features_train <- read.table(features_train_file, header=FALSE)

features_test_file <- file.path(path_to_file, "test", "X_test.txt")
data_Features_test <- read.table(features_test_file, header=FALSE)

#- 3.1 Check for "features" data

percent_train <- checkPercentage(data_Features_train, data_Features_test)
percent_test <- checkPercentage(data_Features_test, data_Features_train)
print.noquote(paste("For Features: percent_train=[", round(percent_train, digits = 4), "], percent_test=[", round(percent_test, digits =4) , "], total=[", (percent_test+percent_train), "].", sep=''))

#- 3.2 Look at the variables in data frame: **data_Features_train** (features train set)
str(data_Features_train)

#- 3.3 Look at the variables in data frame: **data_Features_test** (features test set)
str(data_Features_test)


##Q1: Merges the training and the test sets into `Data` data.frame

#1. use rbind to concatenate rows in "activity", "subject" and "features" data frame
data_Activity <- rbind(data_Act_train, data_Act_test)
data_Subject <- rbind(data_Subject_train, data_Subject_test)
data_Features <- rbind(data_Features_train, data_Features_test)


#2. set names to variables 
names(data_Activity) <- c("activity")
names(data_Subject) <- c("subject")


#3. read features names from features.txt file
featureNames <- read.table(file.path(path_to_file, "features.txt"), header=FALSE)$V2
names(data_Features) <- featureNames


#4. merge columns together to get the data frame "Data" for all data
Data <- cbind(data_Features, cbind(data_Subject, data_Activity))


#5. check out the Data: 
str(Data)


##Q2: Extracts only the measurements on the mean and standard deviation for each measurement.

#1. Subset Name of Features by measurements on the mean and standard deviation.
#
#   Use: regex for mean or standard deviation is mean\\\\(\\\\) | std\\\\(\\\\)
sub_FeaturesNames <- featureNames[grep("mean\\(\\)|std\\(\\)", featureNames)]


#2. Subset the data.frame Data by selected names of Features
selected_sub_FeaturesNames_subj_act <- c(as.character(sub_FeaturesNames), "subject", "activity")
Data <- subset(Data, select=selected_sub_FeaturesNames_subj_act)


#3. Check the data frame Data
str(Data)


##Q3: Uses descriptive activity names to name the activities in the data set

#1. Read descriptive activity names from "activity_labels.txt"
labels_file <- file.path(path_to_file, "activity_labels.txt")
actLabels <- read.table(labels_file, header=FALSE)


#2. Factorize variable "activity" in the data frame **Data** using descriptive activity names
Data$activity <- factor(Data$activity)
# use of factor with labels 
Data$activity <- factor(Data$activity, labels=as.character(actLabels$V2))


#3. check Data$activity
head(Data$activity, 30)


##Q4: Appropriately labels the data set with descriptive variable names.

#1. Replace Features using descriptive variable names
    # - replace prefix "t" by "time"
    # - replace prefix "f" by "frequency"
    # - replace "Acc" with "Accelerometer"
    # - replace "Gyro" with "Gyroscope"
    # - replace "Mag" with "Magnitude"
    # - replace "BodyBody" with "Body"

names(Data) <- gsub("^t", "time", names(Data))           # replace ^t with "time"
names(Data) <- gsub("^f", "frequency", names(Data))      # replace ^f with "frequency"
names(Data) <- gsub("Acc", "Accelerometer", names(Data)) # replace Acc with Accelerometer
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))    # replace Gyro with Gyroscope
names(Data) <- gsub("Mag", "Magnitude", names(Data))     # replace Mag with Magnitude
names(Data) <- gsub("BodyBody", "Body", names(Data))     # replace BodyBody with Body


#1.1 check names(Data)
names(Data)


##Q5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject, Data2$activity), ]
write.table(Data2, file="tidydata.txt", row.name=FALSE)


