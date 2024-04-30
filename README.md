# psy8712-final
The current project is consisted of the final project material for PSY8712 class.

### Dataset Introduction
In the current project, I perform analysis based on a [pre-collected GRE dataset](https://www.openicpsr.org/openicpsr/project/155721/version/V1/view;jsessionid=CCA87775E2BAE63EE1B4FC92FF3AE409>). The dataset contains demographic information (sex, age, citizenship, major), GRE scores (GRE Verbal, Quant, and Writing), and other related outcomes (First Year GPA, etc.). 

### Project Description
The project focuses on answering three research questions with the above dataset:
1. Is there a significant sex difference on GRE Verbal / Quantitative score?
2. What are the correlations between GRE Verbal / Quantitative score with GPA across different demographic groups (separated by sex, age, citizenship, and major)?
3. How well can I predict 1st-Year GPA with GRE and demographic information using machine learning models? 


### Project Reproduce
* To reproduce the current R project, one can first download the "GRE IVY.sav" file from the above link and put it in the "data" folder.  
* The "R" folder contains five R files.
  1. Data Clean.R  
  This file should be run first. It clean up the dataset, filter out missing data, and select variables of interest. After filtering out majors with more than 300 students, data are saved in the file "GRE Filtered Major.csv" in the data folder (which is published in the "data" folder). This data is used for all future analysis. Another skinny dataset, "GRE shiny.csv", is also saved for shiny project (will discuss in later sessions).
  2. Descriptive Analysis.R  
   This file shows descriptive data (i.e., mean and standard deviation) for 1) overall GRE and GPA; 2) GRE (Verbal adn Quant) and GPA for interactions of demographic groups. Also, it shows histogram plots of GRE (Verbal adn Quant) and GPA distribution and saved in "figs" folder ("Descriptive Plot").
  3. RQ1 - Mean Differences.R    
   This file answers the 1st research question, running a t-test showing the mean differences of GRE (Verbal adn Quant) scores between sex, together with a plot "RQ1 Plot" save in the "figs" folder.
  4. RQ2 - Correlation Analysis.R   
   This file answers the 2nd research question, producing correlation table between GRE (Verbal adn Quant) and GPA under each demographic group.
  5. RQ3 - predicting GPA.R    
   This file answers the 3rd research question, predict GPA with all selected variables using for ML models: OLS, glmnet, random forest, and xgboost.   
* The "shiny" folder contains a shinyapp "GREShinyAPP". It contains "app.R" showing the script of a shiny app, and "data.rds" used to produce the shiny app. The shiny app can be found [here](https://purplefishlovespig.shinyapps.io/greshinyapp/).
