library(dplyr) 
featuresNames <- read.table("UCI HAR Dataset/features.txt")$V2

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featuresNames, check.names = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c('id'))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featuresNames, check.names = FALSE)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = c('id'))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c('id','name'))

united_x <- rbind(x_train, x_test)
united_y <- rbind(y_train, y_test)
united_subject <- rbind(subject_train, subject_test)

filteredFeaturesNames <- featuresNames[grepl('mean\\(\\)|std\\(\\)', featuresNames)]
filtered_x <- united_x[, filteredFeaturesNames]

united_y$activity <- activity_labels$name[united_y$id]

united <- cbind(filtered_x, united_y, united_subject)

tidyDataset <- data.frame(united %>% group_by(subject, activity) %>% summarise_all(funs(mean)))
write.table(tidyDataset, "tidy_dataset.txt", row.names=FALSE)
