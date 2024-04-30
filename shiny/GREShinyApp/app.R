library(shiny)
library(tidyverse)


## For choosing majors in selectInput 
majors <- list("All" = "All",
               "Biomedical Engineering" = "Biomedical Engineering",
               "Chemical Engineering" = "Chemical Engineering",
               "Civil and Environmental Engineering" = "Civil and Environmental Engineering",
               "Computer Science" = "Computer Science",
               "Electrical and Computer Engineering" = "Electrical and Computer Engineering",
               "Operations Research and Information Engineering" = "Operations Research and Information Engineering",
               "Public Affairs" = "Public Affairs",
               "Statistics" = "Statistics") 

# Define UI for application that draws a histogram
ui <- fluidPage(
  
    ## Change Font of the entire page
    tags$head(tags$style(HTML('* {font-family: "Times New Roman"};'))),
    ## Change theme
    theme = bslib::bs_theme(bootswatch="flatly"),
    # Application title
    titlePanel("Scatter Plot Between GRE and First-year GPA"),

    # Sidebar with radioButtons / selecInput 
    sidebarLayout(
      sidebarPanel(
        radioButtons("sex", "Sex:", choices = c("Male", "Female", "All"), selected = "Male"),
        radioButtons("citizen", "Citizenship:", choices = c("US", "International", "All"), selected = "US"),
        selectInput("major", "Major", choices = majors, selected = "All"),
        radioButtons("stay", "Students Finished Program?", choices = c("yes", "no", "All"), selected = "yes"),
        radioButtons("gre", "Which GRE plot to draw?", choices = c("GRE Verbal", "GRE Quant", "GRE Total"), selected = "GRE Verbal")
      ),

        # Show a plot of the correlation
        mainPanel(
          plotOutput("plot"), # plot output
          textOutput("text") # text output
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  shiny_data <- readRDS(file = "./data.rds")

  output$plot <- renderPlot({
    
    ## If not select all sex, filter on sex
    if(input$sex != "All") {
      shiny_data <- shiny_data %>%
        filter(Sex == input$sex)
    }
    
    ## If not select all citizenship, filter on citizen
    if(input$citizen != "All") {
      shiny_data <- shiny_data %>%
        filter(Citizenship == input$citizen)
    }
    
    ## Similar logic as above
    if(input$major != "All") {
      shiny_data <- shiny_data %>%
        filter(GraduateFieldProgram == input$major)
    } 
    
    ## Similar logic as above
    if(input$stay != "All") {
      shiny_data <- shiny_data %>%
        filter(stay == input$stay)
    } 
    
    ## If select Verbal/Quant data, create a column called "GRE" as GREVerbal/GREQuantitative Data
    if(input$gre == "GRE Verbal") {
      shiny_data <- shiny_data %>%
        mutate(GRE = GREVerbal)
    } else if (input$gre == "GRE Quant"){
      shiny_data <- shiny_data %>%
        mutate(GRE = GREQuantitative)
    } else {
    ## If select all data, create a column as the sum of GRE data
      shiny_data <- shiny_data %>%
        mutate(GRE = GRESum)
     }
    
    # Plot output based on the selected results
    ggplot(shiny_data, aes(x = GRE, y = GPA)) + 
      # Scatter Plot
      geom_point() +
      # Draw a prediction line
      geom_smooth(method = "lm") +
      # Specify plot labs
      labs(x = "GRE Score", y = "First Year GPA")
    
    
  })
  
  output$text <- renderText({
    
    ## Similar procedure as in plot outputs
    if(input$sex != "All") {
      shiny_data <- shiny_data %>%
        filter(Sex == input$sex)
    }
    
    if(input$citizen != "All") {
      shiny_data <- shiny_data %>%
        filter(Citizenship == input$citizen)
    }
    
    if(input$major != "All") {
      shiny_data <- shiny_data %>%
        filter(GraduateFieldProgram == input$major)
    } 
    
    if(input$stay != "All") {
      shiny_data <- shiny_data %>%
        filter(stay == input$stay)
    } 
    
    if(input$gre == "GRE Verbal") {
      shiny_data <- shiny_data %>%
        mutate(GRE = GREVerbal)
    } else if (input$gre == "GRE Quant"){
      shiny_data <- shiny_data %>%
        mutate(GRE = GREQuantitative)
    } else {
      shiny_data <- shiny_data %>%
        mutate(GRE = GRESum)
    }
    
    # Generate text showing the correlation
    text <-  paste0("The Correlation between GRE and GPA under the selected condition is ", 
                    round(cor(shiny_data$GRE, shiny_data$GPA),2), "." )
    text
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)


#deployApp("../shiny/GREShinyApp")
#https://purplefishlovespig.shinyapps.io/greshinyapp/