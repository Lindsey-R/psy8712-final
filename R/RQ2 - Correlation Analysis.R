# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(psych)
library(diffcor) # For fisher's z transformation

# Data Import and Cleaning
GRE_data <- read_csv("../data/GRE Filtered Major.csv")

GRE_data_correlation <- GRE_data %>%
  mutate(Sex = factor(Sex),
         Citizenship = factor(Citizenship),
         GraduateFieldProgram = factor(GraduateFieldProgram)) %>% # Convert chr to factors
  group_by(Sex, Citizenship, GraduateFieldProgram) %>% ## Group by different groups
  summarise(
    Cor_QG = cor(GREQuantitative, GPA) |> round(2),
    Cor_VG = cor(GREVerbal, GPA) |>round(2),
    Cor_QV = cor(GREQuantitative, GREVerbal)|>round(2),
    .groups = 'drop'  # drops the grouping
  )


