# psy8712-final
The current project is consisted of the final project material for PSY8712 class.

### Dataset Introduction
In the current project, I perform analysis based on a [pre-collected GRE dataset](https://www.openicpsr.org/openicpsr/project/155721/version/V1/view;jsessionid=CCA87775E2BAE63EE1B4FC92FF3AE409>). The dataset contains demographic information (sex, age, citizenship, major), GRE scores (GRE Verbal, Quant, and Writing), and other related outcomes (First Year GPA, etc.). 

### Project Description
The project focuses on answering three hypothesis / research questions with the above dataset:
H1. Is there a significant sex difference on GRE Verbal / Quantitative score?
RQ1. What are the correlations between GRE Verbal / Quantitative score with GPA across sex?
RQ2. How well can I predict 1st-Year GPA with GRE and demographic information using machine learning models? 


### Project Reproduce
* To reproduce the current R project, one can first download the "GRE IVY.sav" file from the above link and put it in the "data" folder.  
* The "R" folder contains five R files.
  1. Data Clean.R  
  This file should be run first. It clean up the dataset, filter out missing data, and select variables of interest. After filtering out majors with more than 300 students, data are saved in the file "GRE Filtered Major.csv" in the data folder (which is published in the "data" folder). This data is used for all future analysis. Another skinny dataset, "GRE shiny.csv", is also saved for shiny project (will discuss in later sessions).
  2. Descriptive Analysis.R  
   This file shows descriptive data (i.e., mean and standard deviation) for 1) overall GRE and GPA; 2) GRE (Verbal adn Quant) and GPA for interactions of demographic groups. Also, it shows histogram plots of GRE (Verbal adn Quant) and GPA distribution and saved in "figs" folder ("Descriptive Plot").
  3. H1 - Mean Differences.R    
   This file answers the 1st research question, running a t-test showing the mean differences of GRE (Verbal adn Quant) scores between sex, together with a plot "H1 Plot" save in the "figs" folder.
  4. RQ1 - Correlation Analysis.R   
   This file answers the 1st research question, producing correlation table between GRE (Verbal adn Quant) and GPA for each sex.
  5. RQ2 - predicting GPA.R    
   This file answers the 2nd research question, predict GPA with all selected variables using for ML models: OLS, glmnet, random forest, and xgboost.   
* The "shiny" folder contains a shinyapp "GREShinyAPP".
  1. The app contains "app.R" showing the script of a shiny app, and "data.rds" used to produce the shiny app. The shiny app can be found [here](https://purplefishlovespig.shinyapps.io/greshinyapp/).
  2. The app was created as an extension of RQ1, with interacting plots showing correlations based on different demographic groups. Specifically, allows user to choose from five options: Sex, Citizenship,  Major (Graduate Field Program), whether student finished program (Stay), and GRE (GRE Verbal, Quantitative, or Sum score). Based on the user’s choice, the app returns 1) a scatter plot showing the correlations between the selected GRE and GPA, with a linear predicting line and 2) a line of text output the correlation. 



### Binder
* A binder is an online code repository contains code and contents, together with configuration files to create a project from the scratch. When saving an R project in a binder, it saves the R version being used to create the project to avoid possible confusions in future replications.  Therefore, I create a binder for the current project with mybinder.org, which is an online service to build and share binders. The binder for the current project can be found here
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/Lindsey-R/psy8712-final/HEAD?urlpath=rstudio). Clicking this link will automatically open an R studio session built under R 4.2.3 (the version I use to run the project) with corresponding codes and data. 


