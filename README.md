# CleaningData
Project for Cousera "Getting and Cleaning Data


In the script, run_analysis.R, I :

#Preliminary: Download the zip archive file and extract its content, if zip and contents not present


1a) Retrieve column names of the training and test sets from "features.txt"  

1b)  Load Training and Testing sets, identifying their columns titles by (1a)

# x_trainSet should contain 7352 observations, 561 variables
x_trainSet  <-  read.table("UCI HAR Dataset/train/X_train.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=colFeatures$Variable)


# x_testSet should contain 2947 observations, 561 variables
x_testSet   <-  read.table("UCI HAR Dataset/test/X_test.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=colFeatures$Variable)

# Now merge the training and test sets by rowbinding, based on the column names common to both datasets
#The merged dataset from above should have 10299 observations, 561 variables
mergedSet <- rbind(x_trainSet, x_testSet)


#For Step 3)  Extractedthe Activity Labels for the training and test sets
#and then combined the activity labels for the test and training data
mergedActivity <- rbind(y_trainingActivity, y_testActivity)

# For step 4) I inserted a new column at the front of mergedSet to display the Activities for each subject by SubjectID. 
#The merged dataset from above should have 10299 observations, 562 variables i.e. no additional column for Activity
mergedSet <-  cbind(mergedActivity, mergedSet)

# For step (2), extract only columns with mean or standard deviation in column name
setMeanStds <- select( mergedSet2,  contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE))

write.table(setMeanStds, file="UCI_Means_Stds.txt", sep=" ", col.names=TRUE)


# For step 5
# extract the subject IDs for the training sets
trainingSubjectIds <- read.table("UCI HAR Dataset/train/subject_train.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=c( "Subject"))

# extract the subject IDs for the test sets
testSubjectIds <- read.table("UCI HAR Dataset/test/subject_test.txt",sep = "", strip.white=TRUE, header=FALSE, col.names=c( "Subject"))


# combine the activity labels for the test and training data
mergedSubjectIds <- rbind(trainingSubjectIds, testSubjectIds)


mergedSet2 <-  cbind(mergedSubjectIds, mergedSet2)
#Melt the mergedSet2 dataset to identify the average of each variable by subject and activity
