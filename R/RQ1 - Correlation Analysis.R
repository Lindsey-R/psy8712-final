# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(psych)
library(diffcor) # For fisher's z transformation

# Data Import and Cleaning
GRE_data <- read_csv("../data/GRE Filtered Major.csv")

# Gerenaral Correlation between GPA and GRE
cor(GRE_data$GREVerbal, GRE_data$GPA) ## 0.16
cor(GRE_data$GREQuantitative, GRE_data$GPA) ## 0.23

# Calculate Correlation table
GRE_data_correlation <- GRE_data %>%
  mutate(Sex = factor(Sex)) %>% # Convert Sex to factors
  group_by(Sex) %>% ## Group by sex
  summarise(
    Cor_QG = cor(GREQuantitative, GPA) |> round(2), ## Put round 2 here so the code is more neat
    Cor_VG = cor(GREVerbal, GPA) |>round(2),
    Cor_QV = cor(GREQuantitative, GREVerbal)|>round(2),
    .groups = 'drop'  # drops the grouping
  )

 