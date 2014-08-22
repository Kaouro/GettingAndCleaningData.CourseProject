# Data was loaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# and unzipped into the working directory

# Read general data
features <- read.table("UCI HAR Dataset/features.txt", sep = " ")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = " ")

# Read test set data 
# For x data omit the separator since white spaces appear at random
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = " ")
test.x <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
test.y <- read.table("UCI HAR Dataset/test/y_test.txt", sep = " ")

# Read trainin set data
# Same approach for x data as in test set
training.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = " ")
training.x <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
training.y <- read.table("UCI HAR Dataset/train/y_train.txt", sep = " ")

# Combine test set
test <- cbind(test.subject,test.y,test.x)
colnames(test)[1:2] <- c("Subject","ActivityClass")
# Combine training set
training <- cbind(training.subject, training.y, training.x)
colnames(training)[1:2] <- c("Subject","ActivityClass")

# Combine the two sets and add descriptive labels for Activities
completeSet <- rbind(test,training)
completeSet <- merge(x = completeSet, y = activity.labels, by.x = "ActivityClass", by.y = "V1", all.x=TRUE)
colnames(completeSet)[564] <- "Activity"

# Get all the index of all features that contain mean() or std()
indexReducedFeatures <- c(grep("mean()",features[,2]),grep("std()",features[,2]))
# Since 2 columns were added to the beginning of the set add 2 to each index
indexReducedFeatures <- indexReducedFeatures+2
# Get the set with reduced features
reducedFeatureSet <- completeSet[, c(1,2,indexReducedFeatures,564)]
reducedFeatureSet$ActivityClass <- reducedFeatureSet$Activity
reducedFeatureSet <- reducedFeatureSet[,1:81]


## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
agg <- aggregate(completeSet[,3:563], by = completeSet[,c(2,564)], FUN=mean)

