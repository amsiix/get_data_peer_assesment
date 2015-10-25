# get_data_peer_assesment
Peer Assesment Repo for the Getting and Cleaning data course project

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

This project includes a dataset produced by my code, as well as a code book that describes the variabls, the data, and any transformations perforemed to created the data. 

The code is in the run_analysis.R file. As per the project instructions, it 
  1. Merges the training and the test sets to create one data set.
    * the datasets are collcted from the `test` and `train` subdirectories contained in the `UCI HAR Dataset` dataset.
    * Each of these subdirectories contains the files:
      * Subject files, containin the `subject_id` values
      * Activity labels file
      * Features file
    * The code joins the test and train datasets
    * The appropriate variable names are also set in this step
    
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    * I select the variable names from the feaures that contain `mean` and `std` in their descriptions, and then only use these columns in a new data frame
  3. Uses descriptive activity names to name the activities in the data set
    * I load the `activity_labels.txt` file 
    * I capitalize the activities so that they are easier to read.
  4. Appropriately labels the data set with descriptive variable names. 
    * I join the activity dataset with the selected dataset, so that it is easier to undrstand.
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    * I melt and cast the data, so that the variables are averaged for each subject and activity.
