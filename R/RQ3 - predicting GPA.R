# ---- Script Settings and Resources ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(caret)
set.seed(12138)

# ---- Data Import and Cleaning ----
GRE_data <- read_csv("../data/GRE Filtered Major.csv")

# ---- Analysis ----
## Split Datasets
### Randomly sort row numbers
random_sample <- sample(nrow(gss_tbl))
### Shuffle dataset
gss_shuffle_tbl <- gss_tbl[random_sample, ]
### Find the 75% index
index <- round(nrow(gss_tbl) * 0.75)
### Create train data
gss_train_tbl <- gss_shuffle_tbl[1:index, ]
### Create test data
gss_test_tbl <- gss_shuffle_tbl[(index+1):nrow(gss_tbl), ]
### Create index for 10 foldes
fold_indices <- createFolds(gss_train_tbl$`work hours`, 10) ## Important to specify to `work hours` here, otherwise model won't run
## Set up train control
myControl <- trainControl(method = "cv", # Cross-Validation
                          indexOut = fold_indices, 
                          number = 10,  #10 folds
                          verboseIter = TRUE) ## Printing training log
