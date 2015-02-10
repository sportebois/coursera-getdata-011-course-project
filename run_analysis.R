
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


library(dplyr)

# Part 0: cleanup ---------------------------------------------------------
# Cleanup the tidy data set and initalize the environment

# Make sure the output folder exists
if (!file.exists('tidy-data')) {
    dir.create('tidy-data')
}

# Make sure the output folder is empty
for (aFile in list.files('tidy-data/')) {
    file.remove(file.path('tidy-data', aFile))
}


# Part 1: dataset merge (train+test) --------------------------------------


# Prepare the references hat we will merge to put useful names: abilities names
# and features names
# Read the ability table
dtAbilityList <- read.table(file = 'raw-data/UCI HAR Dataset/activity_labels.txt',
                            header = FALSE, sep = " ",
                            col.names = c("abilityID", "ability"),
                            colClasses = c("integer", "factor"))
# Read the features observations names
dtFeaturesNames <- read.table(file = 'raw-data/UCI HAR Dataset/features.txt',
                              header = FALSE, sep = " ",
                              col.names = c("featureID", "feature"),
                              colClasses = c("integer", "character"))

getDataSet <- function(subject.file, X.file, y.file) {
    # This function is used to merge the data for a given set of file
    # (test and train data sets are organized in the same way).
    # The 'Inertial Signals' folder will be ignored, as the data it contains
    # will be removed anyway from the tidy data set, as described in the
    # forum thread "David's Course Project FAQ"
    # (https://class.coursera.org/getdata-011/forum/thread?thread_id=69),
    # section "Do we need the inertial folder"
    #
    # Args:
    #  subject.file: path to the "subject_{test,train}.txt" file,
    #    containing 1 observation: the id of the subject
    #  X.file: path to the "X_{test,train}.txt" file,
    #    containing 562 features observations
    #  y.file: path to the "X_{test,train}.txt" file,
    #    containing 562 features observations
    #
    # Returns:
    #  the merged dataframe with observation names added


    dtSubjects <- read.table(file = subject.file,
                             header = FALSE, sep = " ",
                             col.names = c("subjectID"), colClasses = c("integer"))

    # Read it fast with scan, produce a single vector with all the values
    dtFeaturesMeasures <- scan(file = X.file)
    # Create a data.frame by assigning columns.
    # Warning: little trick, as the alues will be assigned by columns then by rows,
    # whereas scan() as read by lines, We invert the desired row/cols,
    # then we transpose the data.frame, so that the columns become the rows (and vice-versa)
    dim(dtFeaturesMeasures) <- c(561, nrow(dtSubjects))
    dtFeaturesMeasures <- t(dtFeaturesMeasures)

    # Put appropriate labels to set descriptive variable names.
    colnames(dtFeaturesMeasures) <- dtFeaturesNames$feature

    # Extracts only the measurements on the mean and standard deviation
    # for each measurement. Make sure to filter features names with 'std()' and
    # 'mean()', to avoid 'meanFreq()' which is not a standard mean.
    dtFeaturesMeasures <- dtFeaturesMeasures[,grepl("(mean\\(\\)|std\\(\\))", colnames(dtFeaturesMeasures))]

    dtLabels <- read.table(file = y.file,
                           header = FALSE, sep = " ",
                           col.names = c("abilityID"),
                           colClasses = c("integer"))

    dtData <- dtSubjects %>%
        bind_cols(dtLabels) %>% # Add the activity ID on the tight of the subject ID
        left_join(dtAbilityList, by="abilityID") %>%  # Apply the Activity label that matches the activity IID
        bind_cols(as.data.frame(dtFeaturesMeasures)) # Add the feature measures on the right
    # The left_join(dtAbilityList..) set descriptive activity names to name
    # the activities in the data set.

    dtData$ability <- factor(dtData$ability) # Make the activity type a factor (was automatically converted to character with the bind operations)

    dtData # return the merged dataframe
}

# Part 1a - Merge all the test data together
dtTest <- getDataSet(subject.file = "raw-data/UCI HAR Dataset/test/subject_test.txt",
                     X.file = "raw-data/UCI HAR Dataset/test/X_test.txt",
                     y.file = "raw-data/UCI HAR Dataset/test/y_test.txt")
# Part 1b - Merge all the train data together
dtTrain <- getDataSet(subject.file = "raw-data/UCI HAR Dataset/train/subject_train.txt",
                     X.file = "raw-data/UCI HAR Dataset/train/X_train.txt",
                     y.file = "raw-data/UCI HAR Dataset/train/y_train.txt")

# Part 1c - Merge test and train consolated dataset in a single one
dtMerged <- bind_rows(dtTest, dtTrain)
# Free up memory
remove(list = c("dtTest", "dtTrain"))


# Save the tidy data to a file
write.table(dtMerged, file = "tidy-data/uci-har-data.txt", row.names = FALSE)


# Create an independent tidy data set (from the one created before ) with the
# average of each variable for each activity and each subject
dtAverage <- dtMerged %>%
    group_by(subjectID, ability)  %>%
    summarise_each(funs(mean))

write.table(dtAverage, file = "tidy-data/uci-har-data-average.txt", row.names = FALSE)
