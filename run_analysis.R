# File: run_analysis.R
# author: Colin Kegler

library("plyr")

#Preliminary: Download the zip archive file and extract its content, if zip and contents not present
if (!file.exists("UCI HAR Dataset.zip")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "UCI HAR Dataset.zip")
    
}


if (!file.exists("UCI HAR Dataset")) {
    unzip(zipfile="UCI HAR Dataset.zip", list=FALSE)   
}


#1a) Retrieve column names of the training and test sets from "features.txt"  
colFeatures <-  read.table("UCI HAR Dataset/features.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=c("ID", "Variable"))

#1b)  Load Training and Testing sets, identifying their columns titles by (1a)

# x_trainSet should contain 7352 observations, 561 variables
x_trainSet  <-  read.table("UCI HAR Dataset/train/X_train.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=colFeatures$Variable)


# x_testSet should contain 2947 observations, 561 variables
x_testSet   <-  read.table("UCI HAR Dataset/test/X_test.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=colFeatures$Variable)

# Now merge the training and test sets by rowbinding, based on the column names common to both datasets
#The merged dataset from above should have 10299 observations, 561 variables
mergedSet <- rbind(x_trainSet, x_testSet)


#Step 3) Working on Activity Labels as Step #3 in assignments
# extract the Activity Labels for the training sets
y_trainingActivity <- read.table("UCI HAR Dataset/train/y_train.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=c( "Activity"))

# extract the Activity Labels for the test sets
y_testActivity <- read.table("UCI HAR Dataset/test/y_test.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=c( "Activity"))


# combine the activity labels for the test and training data
mergedActivity <- rbind(y_trainingActivity, y_testActivity)

# Now insert a new column at the front of mergedSet to display the Activities. 
#The merged dataset from above should have 10299 observations, 562 variables i.e. no additional column for Activity
mergedSet <-  cbind(mergedActivity, mergedSet)



activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=c("ID", "ActivityLabel"))

mergedSet2 <-  merge(mergedSet,activityLabels, by.x="Activity" , by.y="ID", all=TRUE)

mergedSet2 <- mergedSet2[  , c(563, 1:562)  ] 

# For step (2), extract only columns with mean or standard deviation in column name
setMeanStds <- select( mergedSet2,  contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE))

write.table(setMeanStds, file="UCI_Means_Stds.txt", sep=" ", col.names=TRUE)
