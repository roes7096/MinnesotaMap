library(geosphere)
library(googleway)
library(leaflet)
library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyjs)
library(tidyverse)
library(tidyr)

#Load in the functions we created for this app
source("functions/build_routes.R")
source("functions/search_locations.R")

#Load in the data for 8 (most used) existing Metro Transit routes
greenline <- read.csv("data/greenline.csv")
blueline <- read.csv("data/blueline.csv")
nsline <- read.csv("data/nsline.csv")
aline <- read.csv("data/aline.csv")
redline <- read.csv("data/redline.csv")
route5 <- read.csv("data/route5.csv")
route21 <- read.csv("data/route21.csv")
route18 <- read.csv("data/route18.csv")
route6 <- read.csv("data/route6.csv")

#Combine the individual routes into a list
mtroutes <- list(greenline, blueline, nsline, aline, redline, route5, route21, route18, route6)

#Initialize some other things. 'location_points' will be used in different sessions of the app, 
#and it's important whether it's NULL or not. 'colorpal' puts together a color palette for maps

location_points <- NULL
colorpal <- c("red", "blue", "lime", "cyan", "magenta", "darkorange", "olive", "maroon")

#Some custom CSS for the appearance of the app
custom_css <- "
.main-header .logo {
  font-family: 'Avenir Next' !important; 
  font-weight: bold;
  font-size: 28px;
  color: white;
  background-color: rgba(58,128,167);
}
#maptitle {
  font-weight: bold;
  font-size: 30px;
  letter-spacing: -1px;
}
#map {
  height: calc(100vh - 80px) !important;
}
#searched_for {
  color: rgba(58,128,167);
}
#locations_found {
  color: rgba(58,128,167);
}
.irs-grid-pol.small {
  height: 0px;
}
"