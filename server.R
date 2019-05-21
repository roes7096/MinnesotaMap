server <- function(input, output) {
  
  #Create an alert upon opening the app, introduction and give an example of search options
  shinyalert(title = "Welcome to Minnie Map", 
             text = "What if public transportation routes in the Twin Cities area were planned based on the location of McDonald's? Gas stations?
             
Build a transit map for the Twin Cities area by choosing what locations will determine the routes. Customize the map by changing the number of routes.")
  
  #Output a blank leaflet map on the main page, centered to the Twin Cities area.
  output$map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>%
      setView(lng = -93.2696761, lat = 44.97566, zoom = 11.45) 
  })
  
  #When a user clicks the Search' button, search for locations using 'search_locations' function.
  #Show a loading screen and text output of the search results. Make incremental change to the 
  #leaflet map showing any locations found from search results
  observeEvent(input$search, {
    
    shinyalert(title = "Loading", 
               showConfirmButton = FALSE, 
               imageUrl = "https://israelinstitute.nz/wp-content/uploads/2018/01/loader.gif")
    
    hide(id = "searched_for")
    hide(id = "locations_found")
    
    location_points <<- search_locations(user_location = input$text)
    number_locations <- nrow(location_points)
    
    if(!number_locations){
      shinyalert(title = "No Locations Found", 
                 showConfirmButton = TRUE,
                 text = "Please check your spelling or try another search",
                 type = "error"
                 )
      
      leafletProxy("map") %>%
        addTiles() %>%
        clearGroup(group = "location_points") %>%
        clearGroup(group = "user_routes")
      
      output$searched_for <- renderText({
        input$search
        paste0("Searched for: ", isolate(input$text))
      })
      
      output$locations_found <- renderText({
        input$search
        paste0("Locations found: ", isolate(number_locations))
      })
      
      show("searched_for")
      show("locations_found")
      
      location_points <<- NULL
    }
    else{
      leafletProxy("map") %>%
      addTiles() %>%
      clearGroup(group = "location_points") %>%
      clearGroup(group = "user_routes") %>% 
      addCircleMarkers(data = location_points, 
                       lat = ~lat, 
                       lng = ~lng-90, 
                       radius = 4, 
                       weight = 1, 
                       color = "white", 
                       opacity = 1, 
                       fillColor = "darkblue", 
                       fillOpacity = 1, 
                       group = "location_points")
      
      output$searched_for <- renderText({
        input$search
        paste0("Searched for: ", isolate(input$text))
      })
      
      output$locations_found <- renderText({
        input$search
        paste0("Locations found: ", isolate(number_locations))
      })
      
      show("searched_for")
      show("locations_found")
      closeAlert()
    }
    

  })
  
  #When the user clicks the 'Build Routes' button, run the 'build_routes' function. It uses input
  #from the 'location_points' object and the value from the inputSlider. The function finds 
  #routes using clustering of these points. Make incremental change to leaflet map showing the 
  #routes. If location_points is NULL, do nothing.
  observeEvent(input$buildroutes,{
    
    if(is.null(location_points)){
      
      shinyalert("Error", 
                 "Locations are required to build routes",
                 type = "error")
    }
    else{
      
      shinyalert(title = "Loading", 
                 showConfirmButton = FALSE, 
                 imageUrl = "https://israelinstitute.nz/wp-content/uploads/2018/01/loader.gif")
      
      proxy <- leafletProxy("map") %>% 
        clearGroup(group = "user_routes")
      
      user_routes <- build_routes(location_points, input$routes)
      
      if(is.character(user_routes)) {
        shinyalert("Error", 
                   "Number of routes cannot exceed the number of locations found",
                   type = "error")
      }
      else {
      
      for(i in 1:input$routes){
        proxy <- addPolylines(proxy, 
                              data = user_routes[[i]], 
                              lat = ~lat, 
                              lng = ~lon, 
                              color = colorpal[i], 
                              weight = 6, 
                              fillOpacity = .99, 
                              group = "user_routes")
      }
      
      closeAlert()
      }
    }
  })
  
  #When user checks or unchecks checkbox 'Show existing Metro Transit routes' make incremental
  #change to leaflet map. Either add the lines in or remove them
  observe({
    
    if (input$mtroutes) {
      
      proxy <- leafletProxy("map")
      
      for(i in 1:9){
        proxy <- addPolylines(proxy, 
                              data = mtroutes[[i]], 
                              lat = ~lat, 
                              lng = ~lon, 
                              color = "black", 
                              weight = 3, 
                              dashArray = "20, 10", 
                              group = "mtroutes")
      }
    }
    else {
      proxy <- leafletProxy("map") %>% 
        clearGroup(group = "mtroutes")
    }
  })
  
  #When user clicks 'Recenter Map' button, set view of the leaflet map to the original center.
  observe({
    
    if (input$centermap) {
      leafletProxy("map") %>% 
        setView(lng = -93.2696761, lat = 44.97566, zoom = 11.45)
    }
  })
  
  #When user clicks button 'Clear Map' clear any searched locations or user built routes.
  #Also, reset location_points to NULL. If user clicks 'Build Routes' now, nothing will happen
  #until they search for points again. Hide text output from previous search.
  observe({
    
    if (input$clearmap) {
      leafletProxy("map") %>% 
        clearGroup(group = "location_points") %>% 
        clearGroup(group = "user_routes")
    }
    
    location_points <<- NULL
    hide(id = "searched_for")
    hide(id = "locations_found")
  })
}