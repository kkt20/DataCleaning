#load packages
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

#set directory
setwd("C:/Users/welcome/Desktop/Coursera") #for windows system
path <- getwd()

#extract data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Dataset.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f))

## Load and reshape data for analysis; then print a calculated dataset
#download data and unzip the file
#set the new path
setwd("C:/Users/welcome/Desktop/Coursera/Dataset/UCI HAR Dataset")
path <- getwd()

## Part 1
# Get feature names and subset to only those features of mean or std measures
feature.names <- read.table("features.txt")
desired.features <- grep("std|mean", feature.names$V2)

## Part 2
# Get the train and test feature sets and subset only the desired features
train.features <- read.table("train/X_train.txt")
desired.train.features <- train.features[,desired.features]

test.features <- read.table("test/X_test.txt")
desired.test.features <- test.features[,desired.features]

## Part 3
# Combine the two datasets into 1
total.features <- rbind(desired.train.features, desired.test.features)

## Part 4
# Attach column names to features
colnames(total.features) <- feature.names[desired.features, 2]

# Part 5
## Read and combine the train and test activity codes
train.activities <- read.table("train/y_train.txt")
test.activities <- read.table("test/y_test.txt")
total.activities <- rbind(train.activities, test.activities)

# Part 6
## Get activity labels and attach to activity codes
activity.labels <- read.table("activity_labels.txt")
total.activities$activity <- factor(total.activities$V1, levels = activity.labels$V1, labels = activity.labels$V2)

# Part 7
# Get and combine the train and test subject ids
train.subjects <- read.table("train/subject_train.txt")
test.subjects <- read.table("test/subject_test.txt")
total.subjects <- rbind(train.subjects, test.subjects)


# Part 8
## Combine and name subjects and activity names
subjects.and.activities <- cbind(total.subjects, total.activities$activity)
colnames(subjects.and.activities) <- c("subject.id", "activity")

# Part 9
# Combine with measures of interest for finished desired data frame
activity.frame <- cbind(subjects.and.activities, total.features)

# Output
# From the set produced for analysis, compute and report means of 
# all measures, grouped by subject_id and by activity.
result.frame <- aggregate(activity.frame[,3:81], by = list(activity.frame$subject.id, activity.frame$activity), FUN = mean)
colnames(result.frame)[1:2] <- c("subject.id", "activity")
write.table(result.frame, file="mean_measures.txt", row.names = FALSE)
