# psy8712-final
The current project is consisted of the final project material for PSY8712 class.

### Dataset Introduction
In the current project, I perform analysis based on a [pre-collected GRE dataset](https://www.openicpsr.org/openicpsr/project/155721/version/V1/view;jsessionid=CCA87775E2BAE63EE1B4FC92FF3AE409>). The dataset contains demographic information (sex, age, citizenship, major), GRE scores (GRE Verbal, Quant, and Writing), and other related outcomes (First Year GPA, etc.). 

### Project Description
The project focuses on answering three research questions with the above dataset:
1. Are there mean differences in GRE Verbal and GRE Quant scores between male and female?
2. For each major with a large cohort (N > 300), what is the correlation pattern between GPA and GRE (i.e., within-major correlations)?
3. How well can we predict 1st-year GPA with GRE scores and demographic information using maching learning models?

### Project Reproduce
To reproduce the current R project, one first download the "GRE IVY.sav" file from the above link and put it in the "data" folder.   
The "R" folder contains five R files.
1. Data Clean.R
  This file should be run first. It clean up the dataset, filter out missing data, and select variables of interest. After filtering out majors with more than 300 students, data are saved in the file "GRE Filtered Major.csv" in the data folder. This data is used for all future analysis. Another skinny dataset, "GRE shiny.csv", is also saved for shiny project (will discuss in later sessions).
2. Descriptive Analysis.R
   This file shows descriptive data for 1) overall GRE and GPA; 2) GRE and GPA under each categories (sex x age x citizenship x major interactions). Also, it shows a plot of GRE and GPA distribution and saved in "figs" folder.
3. 
