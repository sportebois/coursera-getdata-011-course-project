# Curated version of Human Activity Recognition Using Smartphones Data Set 

## File descriptions


### Raw data source

The raw data have been downloaded from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`. This repository contains their exact copy as of  Feb, 08th 2015, 14:00:39.

The folder `raw-data`contains the downloaded zip, as well as the unzipped files, unaltered.


### Tidy data set

The `tidy-data` folder contain the ready to be used curated data set.


### Cleaning and synthesis process

The `codebook.md` file describe:

- the tidy data set variables
- the step-by-step process to reproduce this tidy data set from the raw data.
- the study design: how was the raw data set collected.


The `run_analysis.R` file is the actual instruction list, the code-recipe that parse, analyse and digest the raw data sets to produce the tidy data, as described in the codebook.
