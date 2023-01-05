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


# Define server
server <- function(input, output, session) {
  
  # searching set
  sel_infectious_syndrome <- reactive({
    req(input$CountryFinder)
    req(input$measure_name)
    req(input$infectious_syndrome)
    filter(centroids_full, location_name %in% input$CountryFinder) %>%
      filter(measure_name %in% input$measure_name) %>%
      filter(infectious_syndrome %in% input$infectious_syndrome) %>%
      group_by(location_name,pathogen) %>%
      mutate(n=n(),pathogen=as.factor(pathogen)) %>%
      mutate(max=max(n))%>%
      ungroup()%>%
      mutate(pathogen=reorder(pathogen,-val))
  })
  
  sel_country <- reactive({
    req(input$CountryFinder)
    filter(world, region %in% input$CountryFinder)
  })
  
  lab_country <- reactive({
    req(input$CountryFinder)
    filter(centroids_full, location_name %in% input$CountryFinder)  %>%
      select(location_name,long,lat) %>%unique()
  })
  
  
  output$mapplotFinder <- renderPlot({
    input$Search
    input$measure_name
    input$CountryFinder
    isolate({
      ggplot() +
        geom_polygon(data = sel_country(), 
                     aes(x = long, y = lat, group = group), 
                     color = "pink",fill="grey") +
        geom_point(data = lab_country(), aes(x = long, y = lat)) +
        geom_text_repel(data = lab_country(), aes(x = long, y = lat, 
                                                  label = as.character(location_name))) +
        coord_quickmap() +
        theme_void() 
      
    })
  })
  
  output$barplotFinder <- renderPlot({
    input$Search
    input$measure_name
    input$CountryFinder
    isolate({
      ggplot(data = sel_infectious_syndrome(),
             aes(x=1/val,y=fct_reorder(pathogen,max)))+
        {if(input$measure_name == "Deaths") geom_col(aes(fill=infectious_syndrome))} +
        {if(input$measure_name == "YLLs") geom_boxplot(aes(color=infectious_syndrome))} +
        scale_x_log10()+
        scale_fill_manual(values =RColorBrewer::brewer.pal(12,"Set3"))+
        scale_color_manual(values =RColorBrewer::brewer.pal(12,"Set3"))+
        labs(title="Pathogens by Infectious Syndromes",
             fill="Infectious Syndrome",color="Infectious Syndrome",
             x="Rate Values (log tranf)",y="Pathogens")
    })
  })
  
  
}              


# Run the application
# shinyApp(ui = ui, server = server)
