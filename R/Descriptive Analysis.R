# ---- Script Settings and Resources ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(psych)
library(ggplot2)

# ---- Data Import and Cleaning ----
GRE_data <- read_csv("../data/GRE Filtered Major.csv")

# ---- Analysis ----
## ---- Descriptive Analysis - Mean and SD ----

## Overal Mean, SDs
GRE_data %>%
  select(-Sex, -Citizenship, -StudyID, -GraduateFieldProgram) %>%
  describe()
#                       vars    n   mean   sd median trimmed  mad min   max range  skew kurtosis   se
# GREQuantitative          1 3594 164.08 5.97  166.0  165.04 4.45 132 170.0  38.0 -1.50     2.49 0.10
# GREVerbal                2 3594 155.10 6.59  155.0  155.08 5.93 130 170.0  40.0 -0.03    -0.02 0.11
# GREWriting               3 3594   3.68 0.70    3.5    3.61 0.74   1   6.0   5.0  0.72     0.25 0.01
# GPA                      5 3594   3.61 0.56    3.7    3.68 0.31   0   4.3   4.3 -4.37    25.40 0.01
# stay                     6 3594   0.97 0.16    1.0    1.00 0.00   0   1.0   1.0 -5.80    31.68 0.00

## Mean, SDs for different categories
GRE_data_descriptive <- GRE_data %>%
  mutate(Sex = factor(Sex),
         Citizenship = factor(Citizenship),
         GraduateFieldProgram = factor(GraduateFieldProgram)) %>% # Convert chr to factors
  group_by(Sex, Citizenship, GraduateFieldProgram) %>% ## Group by different groups
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

## ---- Descriptive Plot ----
## I decide to draw plot for GRE scores and GPA for overall population

GRE_plot <- pivot_longer(GRE_data, 
                         cols = c(GREVerbal, GREQuantitative, GPA), 
                         names_to = "variable", values_to = "value")

# Draw plot
plot <- ggplot(GRE_plot, aes(x = value)) +
  geom_histogram(fill = "steelblue", color = "black", bins = 20) +
  facet_wrap(~variable, scales = "free_x") +
  labs(title = "Distribution of GRE Scores and GPA", x = "Score", y = "Frequency") +
  theme_minimal() 

plot


