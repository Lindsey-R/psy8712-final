# ---- Script Settings and Resources ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(psych)
library(ggplot2)
library(knitr)

# ---- Data Import and Cleaning ----
GRE_data <- read_csv("../data/GRE Filtered Major.csv") 
## Rather than read.csv b/c read_csv is faster and keep the tidy format

# ---- Analysis ----
## ---- Descriptive Analysis - Mean and SD for continuous variables ----

## Descriptive data showing overal Mean, SDs 
GRE_descriptive <- GRE_data %>%
  # de-select categorical variables
  select(-Sex, -Citizenship, -StudyID, -GraduateFieldProgram, -stay, -GRESum) %>% ## Deselect categorical variables and GRESum
  describe() %>% # psych function to obtain descriptive data
  select(n, mean, sd) %>% # get mean and sd
  mutate(mean = round(mean,2), # round to 2 decimals
         sd = round(sd,2))
## This table is copy paste in word to create apa style table
 
## Mean, SDs for different categories
## First, code categorical variables as factors; 
## then, calculate mean and sd for each continuous variable under each categorical variable combination
GRE_data_descriptive <- GRE_data %>%
  mutate(Sex = factor(Sex),
         Citizenship = factor(Citizenship),
         GraduateFieldProgram = factor(GraduateFieldProgram)) %>% # Convert chr to factors
  group_by(Sex, Citizenship, GraduateFieldProgram) %>% ## Group by categorical variables
  summarise( 
    N = n(), ## Count the total sample
    M_GREQ = mean(GREQuantitative) |>round(2), ## Mean round to 2 decimals
    SD_GREQ = sd(GREQuantitative) |>round(2), ## SD round to 2 decimals
    M_GREV = mean(GREVerbal) |>round(2),
    SD_GREV = sd(GREVerbal) |>round(2),
    M_GREW = mean(GREWriting) |>round(2),
    SD_GREW = sd(GREWriting) |>round(2),
    M_GPA = mean(GPA) |>round(2),
    SD_GPA = sd(GPA) |>round(2),
    .groups = 'drop') ## Calculate Summarize statistics and drop groups afterwards
## I did not put round at last because there are categorical variables and cannot be round
## These data will be used to create table in the report

## Save this descriptive data to output
# write_csv(GRE_data_descriptive, "../out/Descriptive Data by Demographic Groups.csv")

## ---- Descriptive Plot ----
## I decide to draw plot for GRE scores and GPA for overall population

## Put the data in longer format so it is eaiser to draw graph
GRE_plot <- pivot_longer(GRE_data, 
                         cols = c(GREVerbal, GREQuantitative, GPA), 
                         names_to = "variable", values_to = "value")

# Draw plot
plot <- ggplot(GRE_plot, aes(x = value)) +
  geom_histogram(fill = "steelblue", color = "black", bins = 20) + ## fill colors for columns in histogram
  facet_wrap(~variable, scales = "free_x") +
  labs(title = "Distribution of GRE Scores and GPA", x = "Score", y = "Frequency") 

## Show Plot
plot
## Save Plot to figs
ggsave("../figs/Descriptive Plot.png", plot,
       height = 3,width = 9,dpi=600)

