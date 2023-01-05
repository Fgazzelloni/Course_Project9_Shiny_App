# Shiny Application for the 9th course of the JHU Data Science specialization
# author: FG

# Load libraries
library(shiny)
library(ggrepel)
library(shinycssloaders) 
library(shinythemes)
library(tidyverse)
library(maps)

# Load data 
source("data/tidydata.R")


######## ######## ######## ######## ######## ######## ######## ########

button_color_css <- "#Search{
/* Change the background color of the update button
to blue. */
background: pink;

/* Change the text size to 15 pixels. */
font-size: 15px;
}"

# Define UI
ui <- fluidPage(
  navbarPage("Measure infections", theme = shinytheme("lumen"),
    tabPanel("Pathogens and Infections", fluid = TRUE, icon = icon("viruses"),
             tags$style(button_color_css),
             sidebarLayout(
               sidebarPanel(
                 titlePanel("Pathogens finder"),
                 selectInput(inputId = "CountryFinder",
                             label = "Select Country:",
                             choices = levels(Country),
                             selected = "Italy",
                             width = "220px"
                 ),
                 helpText("Select a Country, a Measure and some Infectious Syndromes, then click Search."),
                 hr(),
                 titlePanel("Select a scenario"),
                 fluidRow(column(3,
                                 radioButtons(inputId = "measure_name",
                                              label = "Select Measure:",
                                              choices = c("Deaths" = "Deaths", "YLLs" = "YLLs"),
                                              selected = "Deaths")
                                 ),
                          column(6, offset = 2,
                                 # Select which infectious syndrome to plot
                                 checkboxGroupInput(inputId = "infectious_syndrome",
                                                    label = "Select Syndrome:",
                                                    choices = c("All infectious syndromes" ="All infectious syndromes",
                                                                "Bacterial" = "Bacterial infections of the skin and subcutaneous systems",
                                                                "Bloodstream" = "Bloodstream infections", 
                                                                "Diarrhoea" = "Diarrhoea", 
                                                                "Cardiac" = "Endocarditis and other cardiac infections", 
                                                                "Organs" = "Infections of bones, joints, and related organs",
                                                                "Lower respiratory" = "Lower respiratory infections and all related infections in the thorax",
                                                                "Central nervous system" = "Meningitis and other bacterial central nervous system infections",
                                                                "Intra-abdominal" = "Peritoneal and intra-abdominal infections",
                                                                "Infective fever" = "Typhoid fever, paratyphoid fever, and invasive non-typhoidal Salmonella",
                                                                "Urinary" = "Urinary tract infections and pyelonephritis"),
                                                    selected = "Bloodstream infections")
                          )
                   
                 ),
                 actionButton(inputId = "Search", label = "Search"),
               ),
               mainPanel(
                 withSpinner(plotOutput(outputId = "mapplotFinder")),
                 withSpinner(plotOutput(outputId = "barplotFinder"))
                 ),
             )
      
    ),
    navbarMenu("More", icon = icon("info-circle"),
               tabPanel(
                 "About", fluid = TRUE,
                 fluidRow(
                   column(6,
                          #br(),
                          h4(p("About the App")),
                          h5(p("This is officially the final project for the 9th course of the JHU Data Science specialization: Shiny Application and Reproducible Pitch.")),
                          br(),
                          h5(p("This App is intended to facilitate useful comparisons between pathogens found in specific Infectious Syndrome, at specific location, and provide health information at age standardized level.")),
                          br(),
                          h5(p("Data for making this app is from the ", a("IHME website",href = "https://ghdx.healthdata.org/"), "at:", a("https://ghdx.healthdata.org/record/ihme-data/global-mortality-33-bacterial-pathogens-estimates-2019",href = "https://ghdx.healthdata.org/record/ihme-data/global-mortality-33-bacterial-pathogens-estimates-2019"))),
                          h5(p("Researchers at IHME and the University of Oxford produced estimates of deaths and years of life lost (YLLs) associated with bacterial infections caused by 33 pathogens across 204 locations in 2019.")),
                          br(),
                          h5(p("Further information: ", a("fede.gazzelloni@gmail.com",href ="fede.gazzelloni@gmail.com"),"."),
                             p("The source code and the presentation for this Shiny app is available ", a("on github", href = "https://github.com/fgazzelloni/Course_Project9_Shiny_App"), "."),
                             )
                          
                          #hr(),
                          
                   ),
                   column(6,
                          h4(p("About the Author")),
                          h5(p("Federica Gazzelloni is a Statistician and an Actuary. She is the author of the", a("oregonfrogs package", href = "https://github.com/fgazzelloni/oregonfrogs"), "made for modeling with spatial and categorical data in the R environment."),
                             p("For more info about Federica's work as ", a("Data Scientist", href = 'https://federicagazzelloni.netlify.app'), "."),
                          ),
                          HTML('<img src="profile_pic.png", height="200px"'),
                          br()
                   )
                 )
               )
               )
  )
)
