activity <- read.table("D:/Coursera/R programming/UCI HAR Dataset/activity_labels.txt")
features <- read.table("D:/Coursera/R programming/UCI HAR Dataset/features.txt")

subject_test <- read.table("D:/Coursera/R programming/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("D:/Coursera/R programming/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("D:/Coursera/R programming/UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("D:/Coursera/R programming/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("D:/Coursera/R programming/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("D:/Coursera/R programming/UCI HAR Dataset/train/y_train.txt")



#1. Merging the train and test data into a single table
x <- rbind(x_train, x_test)
  colnames(x) <- features[,2]
y <- rbind(y_train, y_test)
  names(y) <- c("code")
subject <- rbind(subject_train, subject_test) 
  names(subject) <- c("subject")

data <- cbind(subject, x, y)

#2. Extracting measurements on mean and stdandard deviation
#   The data contains duplicate columns which need to be avoided
extracted_data <- data[,!duplicated(colnames(data))] %>% 
                  select(subject, code, contains("mean"), contains("std"))

#3. Using descriptive activity name from the activity table
extracted_data$code <- activity[extracted_data$code, 2]

#4. Labling few variables to be more descriptive
names(extracted_data) <- gsub("code", "Activity", names(extracted_data))
names(extracted_data) <- gsub("Acc", "Accelerator", names(extracted_data))
names(extracted_data) <- gsub("Mag", "Magnitude", names(extracted_data))
names(extracted_data) <- gsub("Gyro", "Gyroscope", names(extracted_data))
names(extracted_data) <- gsub("^t", "time", names(extracted_data))
names(extracted_data) <- gsub("^f", "frequency", names(extracted_data))


#5. Creating tidy data 
#   Grouping by subject and activity 
tidy_data <- group_by(.data = extracted_data, subject, Activity)
final_data <- summarise_all(tidy_data, .funs = mean)

write.table(x = final_data, file = "final_tidy_data.txt", row.names = FALSE)              









