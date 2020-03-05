##BEFORE WORKING ON THE DATA
library(dplyr)

##Data download, save and unzip the files
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="assignment/data.zip")
unzip("~/R/RSTUDIO/Coursera Data Science/Modul3/assignment/data.zip",exdir="assignment/dataset", )

##Reading the datasets in Train and Test data("subject", "X" and "Y" ) as well as the "activity names" data and the "features" data which contains
##the columns(variables) names.
sub_test<-read.table("assignment/dataset/UCI HAR Dataset/test/subject_test.txt",col.names = ("id"))
x_test<-read.table("assignment/dataset/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("assignment/dataset/UCI HAR Dataset/test/y_test.txt",col.names=("Activity"))
sub_train<- read.table("assignment/dataset/UCI HAR Dataset/train/subject_train.txt")
x_train<-read.table("assignment/dataset/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("assignment/dataset/UCI HAR Dataset/train/y_train.txt")
act_name<- read.table("assignment/dataset/UCI HAR Dataset/activity_labels.txt")
features<- read.table("assignment/dataset/UCI HAR Dataset/features.txt")

##STEP 1
##Naming the subject data Column
names(sub_train)<-"Subject"
names(sub_test)<-"Subject"

##Naming features measures with the file from the MetaData
names(x_train)<-features$V2
names(x_test)<-features$V2


#Naming Column for activities
names(y_train)<-"Activity"
names(y_test)<-"Activity"

##Combining the Train files and the Test files
train<-cbind(sub_train, y_train, x_train)
test<-cbind(sub_test, y_test, x_test)

##Merging the Train and Test Datasets
data_new<-rbind(train, test)


##STEP 2
##Extracting only the measurements on the mean and standard deviation for each measurement.

##Creating a Vector of the feature names, as character
##Creating a vector of only the Mean and STD measure and using it to subset the data 
##into a new dataset
new_vector<-c("subject", "activity", as.character(features$V2))
MeanStdOnly<-grep("subject|activity|[Mm]ean()|std()", new_vector, value = FALSE)
data_mean_std<-data_new[ ,meanStdColumns]


##STEP 3
##Use descriptive activity names to name the activities in the data set

##Attributing the labels from the activity labels file to the column Activity 
##from the data set
data_mean_std$Activity<-act_name[data_mean_std$Activity, 2]


##STEP 4
##Appropriately labeling the data set with descriptive variable names

names(data_mean_std)<-gsub("Acc", "Accelerometer", names(data_mean_std))
names(data_mean_std)<-gsub("Gyro", "Gyroscope", names(data_mean_std))
names(data_mean_std)<-gsub("BodyBody", "Body", names(data_mean_std))
names(data_mean_std)<-gsub("Mag", "Magnitude", names(data_mean_std))
names(data_mean_std)<-gsub("^t", "Time", names(data_mean_std))
names(data_mean_std)<-gsub("^f", "Frequency", names(data_mean_std))
names(data_mean_std)<-gsub("tBody", "TimeBody", names(data_mean_std))
names(data_mean_std)<-gsub("-freq()", "Frequency", names(data_mean_std), ignore.case = TRUE)


##STEP 5
##From the data set in STEP 4, creates a second, independent tidy data set
##with the average of each variable for each activity and each subject

new_dataset<-data_mean_std %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean))
##Writting a csv file to the new dataset
write.csv(new_dataset, "new_dataset.csv", row.names=FALSE)

##writing table to upload in the work submission
write.table(new_dataset, "new_dataset.txt", row.names=FALSE)

