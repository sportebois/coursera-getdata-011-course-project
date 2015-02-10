# Curated version of Human Activity Recognition Using Smartphones Data Set 

## File descriptions


### Raw data source

The raw data have been downloaded from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`. This repository contains their exact copy as of  Feb, 08th 2015, 14:00:39.

The folder `raw-data`contains the downloaded zip, as well as the unzipped files, unaltered.


### Tidy data set

The `tidy-data` folder contain the ready to be used curated data set.

- `tidy-data/uci-har-data.txt` is the data set with merged test and train set, with meaningful labels and names, and keeping only the measurements on the mean and standard deviation for each measurement. 
- `tidy-data/uci-har-data-average.txt` is a second data set, containing the average of each variable, grouped by each subject and each activity.

Please read the `codebook.md` file for more details about the tidy data.


### Codebook

The `codebook.md` file describe:

- the tidy data set variables
- the step-by-step process to reproduce this tidy data set from the raw data.
- the study design: how was the raw data set collected.


## Cleaning and synthesis process

### Information about the instruction list to go from the raw data to the tidy data set

The `run_analysis.R` file is the actual instruction list, the code-recipe that parse, analyse and digest the raw data sets to produce the tidy data, as described in the codebook. This script has been commented in details.
It requires a few dependency: only the `dplyr` package is required, everything else comes with standard R.
In order to run it correctly, you should se your working directory to this folder (containing the `run_analysis.R` script and this readme), and the raw data must be in the `raw-data/UCI HAR Dataset/` folder, exactly like on the Github repo.


Here's an extract of the run_analysis script (please refer to the script for more details):


- Cleanup the tidy data set and initalize the environment
   In order to make sure the tidy data set is always recreated from scratch, the operation starts by deleting anything in the output folder.

- Read the abilities list and the features names
   Both test and train raw data use theses IDs. So we load them to be able to use it in later processing.

- Prepare a dataset submerge, that will be used for both test and train data. Both test and train data are organized in the same way. This function will load the subject file, the X file (with all the features measures) and the 'y' file with the activities
This function  binds the columns to add the ability used with the measures, as well as the subject. It also use the reference data loaded before (activities names and features names) to give meaningful labels to the observations.

- This function also filter the features measure by their names, to keep onky the ones relevant for mean or standard deviation.

- this utility function is called on the test data set, then on the train data set. This two submerge are then merged together to get the tidy daata set.
- This first result is saved to 'tidy-data/uci-har-data.txt'
- This merged data set is grouped by subject and by ability, and the mean is applied on all this groups to summarize the data (with the help of dplyr)
- This last result is saved to 'tidy-data/uci-har-data-average.txt'
