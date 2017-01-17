setwd("~/")

features = read.table("Desktop/UCI HAR Dataset/features.txt", sep = " ", header = FALSE)

X_test = read.table("Desktop/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE, col.names = features$V2)
y_test = read.table("Desktop/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test = read.table("Desktop/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X_test$lables = y_test$V1
X_test$subject = subject_test$V1

X_train = read.table("Desktop/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE, col.names = features$V2)
y_train = read.table("Desktop/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train = read.table("Desktop/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
X_train$lables = y_train$V1
X_train$subject = subject_train$V1

merged_data = rbind(X_test, X_train)

merged_data$lables = as.character(merged_data$lables)
library(gsubfn)
merged_data$lables = gsubfn(".", list("1"="WALKING", "2"="WALKING_UPSTAIRS", "3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING"), merged_data$lables)

subset_number = grep('\\bmean()\\b|\\bstd()\\b', features$V2)
feature_subset = features[subset_number,]
merged_data_subset = merged_data[, feature_subset$V1]
merged_data_subset = cbind(merged_data_subset, merged_data$lables, merged_data$subject)
merged_data_subset = merged_data_subset[, c(68, 67, 1:66)]

library(dplyr)
library(purrr)
merged_data_subset = merged_data_subset %>% group_by(merged_data$subject, merged_data$lables) %>% dmap(mean)

write.table(merged_data_subset, file = "Desktop/result_data.txt")
