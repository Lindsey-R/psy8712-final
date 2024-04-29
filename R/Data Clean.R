# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(haven) # Read sav
library(tidyverse)
library(writexl)

# Data Import and Cleaning
## Read in sav
GRE_IVY <- read_sav("../data/GRE IVY.sav")

## Rename 1styrGPA
## so it's easier to type GPA rather than @1styrGPA in future reference
GRE_IVY$GPA <- GRE_IVY$`@1styrGPA`

## Remove missing data and select variables
## Use dplyr functions so the code is more clean than baseR
GRE_Clean <- GRE_IVY %>%
  filter(gre_score == 1, !is.na(GPA)) %>%  # keep those who have GRE_score, remove those who have no GPA score 
  filter(!is.na(stay)) %>% # Remove those who have no information for stay or not
  select(StudyID, Sex, Citizenship, GREQuantitative, GREVerbal, GREWriting, GraduateFieldProgram, GPA,stay) %>% # Select variables for the current study
  mutate(Citizenship = recode(Citizenship,
                          "US Citizen/Permanent Resident" = "US",
                          "International" = "International")) # Recode so the names are simple


## Save finalized data
## write_csv(GRE_Clean, "../data/GRE Clean Data.csv")
## Did not use write.csv b/c write_csv is more stable and keep the tidy format

## Select majors of interest - keep majors with > 300 observations
GRE_Large_Major <- GRE_Clean %>%
  group_by(GraduateFieldProgram) %>%
  filter(n() > 300) %>%
  filter(GPA != 0) %>% # Remove those whose GPA scores are 0 
  mutate(GRESum = GREQuantitative + GREVerbal) # Calculate GRESum for shiny app
## write_csv(GRE_Large_Major, "../data/GRE Filtered Major.csv")

## Clean data for shiny app
GRE_shiny <- GRE_Large_Major %>%
  select(-StudyID) %>% # deselect un-used variable
  mutate(stay = recode(stay,`1` = "yes", `0` = "no")) # recode stay so it's easier to choose in shiny

## saveRDS(GRE_shiny, "../shiny/GREShinyApp/data.rds")

