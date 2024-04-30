# ---- Script Settings and Resources ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(ggplot2)

# ---- Data Import and Cleaning ----
GRE_data <- read_csv("../data/GRE Filtered Major.csv")
## Faster and align with tidy format

# ---- Analysis ----

## ---- t-test ----
## Select Female and Male data separately for t-test
## Use dplyr functions for tidy format
GRE_Female <- GRE_data %>%
  filter(Sex == "Female") %>%
  select(Sex, GREVerbal, GREQuantitative)
GRE_Male <- GRE_data %>%
  filter(Sex == "Male") %>%
  select(Sex, GREVerbal, GREQuantitative)
  
## Quantitative Difference
t.test(GRE_Female$GREQuantitative, GRE_Male$GREQuantitative, alternative = "two.sided")

# Welch Two Sample t-test
# 
# data:  GRE_Female$GREQuantitative and GRE_Male$GREQuantitative
# t = -6.8421, df = 2827.9, p-value = 9.532e-12
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -1.833804 -1.016859
# sample estimates:
#   mean of x mean of y 
# 163.2690  164.6944 

## Verbal Difference
t.test(GRE_Female$GREVerbal, GRE_Male$GREVerbal, alternative = "two.sided")

# Welch Two Sample t-test
# 
# data:  GRE_Female$GREVerbal and GRE_Male$GREVerbal
# t = -4.0849, df = 3239.2, p-value = 4.516e-05
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -1.3368938 -0.4697379
# sample estimates:
#   mean of x mean of y 
# 154.5340  155.4373 


## ---- Boxplot ----
## Select GRE variables used to draw plot
GRE_Mean_Diff <- GRE_data %>%
  select(Sex, GREQuantitative, GREVerbal)
## Transfer data into longer format so it's easier to draw plot
RQ1_Plotdata <- pivot_longer(GRE_Mean_Diff, 
                             cols = c(GREQuantitative, GREVerbal), 
                             names_to = "variables", 
                             values_to = "value")

## Draw plot with ggplot rather than base-R plot so the plot is neat and can specify more customizations
RQ1_Plot <- ggplot(RQ1_Plotdata, aes(x = Sex, y = value, fill = variables)) +
  geom_boxplot() +
  labs(title = "Mean GRE Score Difference Across Sex",
       x = "Sex",
       y = "GRE Score") +
  facet_wrap(~ variables) 

## Show plot
RQ1_Plot 
## Save plot to figs to put in script later
ggsave("../figs/RQ1 Plot.png", RQ1_Plot,
       height = 6,width = 9,dpi=600)
