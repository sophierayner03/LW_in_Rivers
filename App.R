
#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      14/11/2025                             ##
##                  Creating a ShinyApp                        ##
##                         App.R                               ##
##                                                             ##
#################################################################


#please install these packages and set working directory before running
#install.packages("shiny")
#install.packages("leaflet")
#install.packages("sf")
#install.packages("raster")
#install.packages("ggplot2")
#install.packages("RColorBrewer")
#install.packages("terra")
#install.packages("leafem")
#install.packages("geojsonio")


# Load packages ----
library(shiny)
library(leaflet)
library(sf)
library(raster)
library(ggplot2)
library(RColorBrewer)
library(terra)
library(leafem)
library(geojsonio)

options(shiny.maxRequestSize = 1000 * 1024^2)


# Run global script containing all your relevant data ----
source("Global.R")

# Define UI for visualisation ----
source("UI.R")

ui <- navbarPage("Instream large wood on the River Torridge", id = 'nav',
                 tabPanel("Map", 
                          div(class="outer",
                              leafletOutput("map", height = "calc(100vh - 70px)")
                          )
                 )
)

# Define the server that performs all necessary operations ----
server <- function(input, output, session){
  source("Server.R", local = TRUE)
}

#run the application 
shinyApp(ui, server)
