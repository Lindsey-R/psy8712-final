# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(haven)
library(tidyverse)
library(writexl)

# Data Import and Cleaning
GRE_IVY <- read_sav("../data/GRE IVY.sav")

## Rename 1styrGPA
GRE_IVY$GPA <- GRE_IVY$`@1styrGPA`

## Remove missing data and select variables
GRE_Clean <- GRE_IVY %>%
  filter(gre_score == 1, !is.na(GPA)) %>% 
  filter(!is.na(stay)) %>%
  select(StudyID, Sex, Citizenship, GREQuantitative, GREVerbal, GREWriting, GraduateFieldProgram, GPA,stay) %>%
  mutate(Citizenship = recode(Citizenship,
                          "US Citizen/Permanent Resident" = "US",
                          "International" = "International")) ## Recode so the names are simple


## Save finalized data
# write_csv(GRE_Clean, "../data/GRE Clean Data.csv")

## Select majors of interest - keep majors with > 300 observations
GRE_Large_Major <- GRE_Clean %>%
  group_by(GraduateFieldProgram) %>%
  filter(n() > 300) %>%
  filter(GPA != 0) %>%
  mutate(GRESum = GREQuantitative + GREVerbal)## Remove those who have no GPA 
# write_csv(GRE_Large_Major, "../data/GRE Filtered Major.csv")

## Clean data for shiny app
GRE_shiny <- GRE_Large_Major %>%
  select(-StudyID) %>%
  mutate(stay = recode(stay,`1` = "yes", `0` = "no"))

## saveRDS(GRE_shiny, "../shiny/GREShinyApp/data.rds")
