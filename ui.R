header <-  dashboardHeader(title = "Minnie Map")

sidebar <- dashboardSidebar(collapsed = TRUE,
                            
                            sidebarMenu(id = "tabs",
                                        
                                        menuItem("Interactive Map", 
                                                 tabName = "map_tab", 
                                                 icon = icon("map")),
                                        menuItem("About", 
                                                 tabName = "about_tab", 
                                                 icon = icon("question")
                                        ))
)

body <- dashboardBody(useShinyalert(), 
                      useShinyjs(),
                      tags$head(tags$style(HTML(custom_css))
                      ),
                      
                      tabItems(
                        tabItem(tabName = "map_tab",
                                
                                fluidRow(
                                  
                                  column(width = 9,
                                         
                                         leafletOutput("map")
                                  ),
                                  
                                  column(width = 3,
                                         
                                         h1("Create a map", id = "maptitle"),
                                         br(),
                                         helpText("Choose a category to search for. This search functions using Google Maps."),
                                         textInput("text", "Search for locations"),
                                         actionButton("search", label = "Search"),
                                         
                                         br(),br(),
                                         sliderInput("routes", "Number of routes", min = 3, max = 8, value = 3),
                                         actionButton("buildroutes", label = "Build Routes"),
                                         
                                         br(),br(),
                                         checkboxInput("mtroutes", "Show existing Metro Transit 
                                                       routes", FALSE),
                                         actionButton("centermap", "Recenter Map"),
                                         actionButton("clearmap", label = "Clear Map"),
                                         
                                         br(),br(),br(),
                                         textOutput("searched_for"),
                                         textOutput("locations_found")
                                  )
                                )
                        ),
                        
                        tabItem(tabName = "about_tab",
                                
                                fluidRow(
                                  
                                  column(width = 2),
                                  
                                  column(width = 6,
                                         
                                         h1("About", id = "abouttitle"),
                                         br(),
                                         helpText("The planning of public transport takes into account 
                                many different factors. We thought the way different 
                                businesses decide on locations to spread across a city might be 
                                similar in some ways to how transit stops are placed. None too
                                close together, more densely placed in downtown areas,
                                convenient to travel to, and so on."),
                                         br(),
                                         helpText("The app takes your search submission and identifies up
                                to 60 locations from the center of Minneapolis/St Paul in a
                                radius of about 10 miles. Search results are found using Google
                                Maps API. The system must pause in between Google Maps search
                                result pages, resulting in a loading time of about 10 to 12 seconds. 
                                Routes are built by calculating cluster centers among location 
                                coordinates. The number of routes is actually the number of 
                                clusters the route-finding algorithm takes as input."),
                                         br(),
                                         helpText("Minnie Map was created by Jimmy Kroll, Ryan Nelson, 
                                         Peter Roessler-Caram, Michael Schatzel, and Trevor
                                         Tracy.")
                                  )
                                )
                        )
                      )
)

ui <- dashboardPage(header, sidebar, body)