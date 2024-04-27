# ---- Script Settings and Resources ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(ggplot2)

# ---- Data Import and Cleaning ----
GRE_data <- read_csv("../data/GRE Filtered Major.csv")

# ---- Analysis ----
GRE_Mean_Diff <- GRE_data %>%
  mutate(Sex = factor(Sex)) 

vars <- c("GREQuantitative", "GREVerbal")

# Initialize a list to store results
anova_results <- list()

# Perform ANOVA
for (i in vars) {
  # Dynamically build the formula
  formula_str <- as.formula(paste(i, "~ Sex"))
  
  # Perform ANOVA
  model <- aov(formula_str, data = GRE_Mean_Diff)
  summary_model <- summary(model)
  
  # Store the results
  anova_results[[i]] <- summary_model
  
}

## ---- ANOVA results ----
## Function to build a dataframe to summary result
results_table <- do.call(rbind, lapply(anova_results, function(x) {
  data.frame(
    Df = x[[1]][["Df"]][1], ## extracted from ANOVA results for each separate model
    SumSq = x[[1]][["Sum Sq"]][1],
    MeanSq = x[[1]][["Mean Sq"]][1],
    FValue = x[[1]][["F value"]][1],
    PrF = x[[1]][["Pr(>F)"]][1]
  )
}))
rownames(results_table) <- vars

results_table
#                 Df     SumSq    MeanSq   FValue          PrF
# GREQuantitative  1 1741.0278 1741.0278 49.32353 2.591444e-12
# GREVerbal        1  699.2831  699.2831 16.35938 5.351482e-05

## ---- Boxplot ----
RQ1_Plotdata <- pivot_longer(GRE_Mean_Diff, 
                             cols = c(GREQuantitative, GREVerbal), 
                             names_to = "variables", 
                             values_to = "value")

RQ1_Plot <- ggplot(RQ1_Plotdata, aes(x = Sex, y = value, fill = variables)) +
  geom_boxplot() +
  labs(title = "Distribution of Measurements by Sex",
       x = "Sex",
       y = "Measurement Value") +
  facet_wrap(~ variables) 

RQ1_Plot
