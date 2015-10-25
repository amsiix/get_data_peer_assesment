#### run_analysis.R
    library(Hmisc)    
    library(dplyr)
    library(reshape2)

    ## Set environment
    oldwd <- getwd()
    
    setwd("/home/vagrant/datascience/getdata/course_project")
    
## Getting the data
    if (!dir.exists("data")) 
        dir.create("data")
    
    setwd("./data")
    
    if (!file.exists("har_dataset.zip")) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url,destfile="har_dataset.zip", method="curl", mode ="b")
    }
    unzip("har_dataset.zip")
    
    setwd("./UCI HAR Dataset")


## 1. Merges the training and the test sets to create one data set.

    ## Read the Feature column names
    featuresList <- read.table("features.txt")
    colnames( featuresList ) <- c("id","feature_name")

    colNames <- c( "subject_id", "activity_id", as.character( featuresList$feature_name ))
    
    ## read the test features table, and set the features column names
    testFeatures <- read.table("test/X_test.txt")
    testLabels <- read.table("test/y_test.txt")
    testSubjects <- read.table("test/subject_test.txt")

    
    testData <- data.frame( subjects=testSubjects, labels=testLabels, set=testFeatures )
    colnames( testData ) <- colNames
    
    ## read the test features table, and set the features column names
    trainFeatures <- read.table("train/X_train.txt")
    trainLabels <- read.table("train/y_train.txt")
    trainSubjects <- read.table("train/subject_train.txt")

    trainData <- data.frame( subjects=testSubjects, labels=testLabels, feaures=testFeatures )
    colnames( trainData ) <- colNames

    data <- rbind( testData, trainData )

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    
    # Find the features that represent mean or standard deviation calculations
    selectedFeatureIndexes <- grep( "(mean|std)",colNames)
    
    # We want the subject_id (column 1) and label_id (column 2) in addition to
    # the selected feature columns
    colIndexes <- c(1,2, selectedFeatureIndexes )
    
    selectedData <- data[, colIndexes]
    
## 3. Uses descriptive activity names to name the activities in the data set
    activityLabels <- read.table("activity_labels.txt")
    colnames( activityLabels ) <- c("activity_id","activity")
    
    # Capitalize the activity labels
    activityLabels$activity <- unlist(
        lapply( tolower( gsub("_"," ",activityLabels$activity)), 
                function (x) { 
                    s<-capitalize(strsplit(x, " ")[[1]]); 
                    paste(s,sep="",collapse=' ') 
                }
                ))

## 4. Appropriately label the data set with descriptive variable names. 
    
    labeledSelectedData <- inner_join( activityLabels, selectedData) %>%
        select( -activity_id ) %>% # drop the activity id
        select( subject_id, activity, everything() ) # reorder the remaining columns

    write.table( labeledSelectedData, "../labeled_selected_data.txt", row.names = FALSE)
    
## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
    
    meltedData <- labeledSelectedData %>% melt(id=c("subject_id","activity"))
    averagedData <- meltedData %>% dcast(subject_id + activity ~ variable, mean )
    
    variableNames <- tail(names(averagedData),n=79)

    
    averagedDataColNames <- c("subject_id","activity",paste(c("mean of"), variableNames ))
    
    colnames( averagedData ) <- averagedDataColNames
    
    write.table(averagedData, "../averaged_data.txt", row.names = FALSE)
    # reset environment
    setwd( oldwd )
    