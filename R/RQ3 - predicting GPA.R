# ---- Script Settings and Resources ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(caret)
library(parallel)
library(doParallel) # to do parallel
set.seed(12138)

# ---- Data Import and Cleaning ----
GRE_data <- read_csv("../data/GRE Filtered Major.csv")
GRE_ML <- GRE_data %>%
  select(-StudyID, -GRESum) %>% # Deselect GPA and GRESum b/c GPA is directly related to Recode_GPA, GRE sum is simply the sum of GREV and GREQ
  mutate(Sex = factor(Sex),
         Citizenship = factor(Citizenship),
         GraduateFieldProgram = factor(GraduateFieldProgram)) ## Recode chracter data into variables

 
# ---- Analysis ----
## Split Datasets
### Randomly sort row numbers
random_sample <- sample(nrow(GRE_ML))
### Shuffle dataset
GRE_shuffle_tbl <- GRE_ML[random_sample, ]
### Find the 75% index
index <- round(nrow(GRE_ML) * 0.75)
### Create train data
GRE_train_tbl <- GRE_shuffle_tbl[1:index, ]
### Create test data
GRE_test_tbl <- GRE_shuffle_tbl[(index+1):nrow(GRE_ML), ]
### Create index for 10 foldes
fold_indices <- createFolds(GRE_train_tbl$`GPA`, 10) 
## Set up train control
myControl <- trainControl(method = "cv", # Cross-Validation
                          indexOut = fold_indices, 
                          number = 10,  #10 folds
                          verboseIter = TRUE) ## Printing training log


## Analysis with parallel
local_cluster <- makeCluster(detectCores() - 2) # specify the number of cores to use
registerDoParallel(local_cluster)

## OLS model
model_ols <- train(`GPA` ~ ., 
                   GRE_train_tbl,
                   method = "lm", 
                   trControl = myControl)
ols_predict <- predict(model_ols, GRE_test_tbl, na.action = na.pass)

## elasticnet model
model_elastic <- train(`GPA` ~ ., 
                       data = GRE_train_tbl,
                       method = "glmnet", # Did not impute because data is complete 
                       trControl = myControl)
elastic_predict <- predict(model_elastic, GRE_test_tbl)
### Fitting alpha = 0.55, lambda = 0.00141 on full training set

## xgbLinear Model
model_xgb <- train(`GPA` ~ ., 
                   data = GRE_train_tbl,
                   method = "xgbLinear",
                   trControl = myControl)
## Fitting nrounds = 150, lambda = 1e-04, alpha = 1e-04, eta = 0.3 on full training set
xgb_predict <- predict(model_xgb, GRE_test_tbl)

## Random Forest Model
model_rf <- train(`GPA` ~ ., 
                  data = GRE_train_tbl,
                  method = "ranger",  
                  trControl = myControl)
## Fitting mtry = 13, splitrule = variance, min.node.size = 5 on full training set
rf_predict <- predict(model_rf, GRE_test_tbl)

stopCluster(local_cluster)
registerDoSEQ() ## STOP parallelization


# Publication
R2_ols <- cor(ols_predict, GRE_test_tbl$`GPA`)^2 |> round(2)
R2_elastic <- cor(elastic_predict, GRE_test_tbl$`GPA`)^2 |> round(2)
R2_rf <- cor(rf_predict, GRE_test_tbl$`GPA`) ^2 |> round(2)
R2_xgb <- cor(xgb_predict, GRE_test_tbl$`GPA`) ^2 |> round(2)

results <- tibble(
  algo = c("OLS regression","Elastic Net", "Random Forest", "XGB"),
  cv_rsq = c(round(max(model_ols$results$Rsquared),2),
             round(max(model_elastic$results$Rsquared),2),
             round(max(model_rf$results$Rsquared),2),
             round(max(model_xgb$results$Rsquared),2)),
  ho_rsq = c(R2_ols,
             R2_elastic,
             R2_rf,
             R2_xgb))

