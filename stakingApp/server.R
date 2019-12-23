# Set the Server Variable 
server <- function(input, output, session) {
  ##############################################
  # Name: isochrone                                                                    
  # Description:                               
  # Construct Isochrone variable from map click to send to the OSRM Server                  
  # Created: 06/03/2019                                                                           
  # Author: John Lister - GIS Applications Developer                                                                         
  # Adapted From Example: https://www.r-bloggers.com/shiny-app-drive-time-isochrones/                                                 
  # By: Thomas Roh                                                                                      

  
  #Define Data Frame with Staking Appointments
<<<<<<< HEAD
  data <- df
  #Retrieve the value selected from the day class, feeder, and staker filter
  #changed the filter to a reactive
  bec_map <- "https://api.mapbox.com/styles/v1/gisjohnbb/cjmaudm2mha1e2splkup0tc3s/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2lzam9obmJiIiwiYSI6ImNqbHptM2g3YTBxcWozdm53bXJrOWxwcWwifQ.3zAsFMWc6_CrtYSvEyNl9w"
  map_attr <- 'John Lister - GIS Applications Developer | Brandon Mitschke - GIS Applications Student'
  
  #Render the Leaflet Map
  output$map <- renderLeaflet({
    data <- filtered_apts()     
    leaflet(data = data) %>%    
      setView(-97.285944, 30.104740, 9) %>%
      #added two map panes for each layer
      #  addMapPane("iso", zIndex = 420) %>% 
      #   addMapPane("markers", zIndex = 430) %>% 
      #added another map pane for the appointment table click event 
      #   addMapPane("tblapts", zIndex = 440) %>%
      addTiles(urlTemplate = bec_map, attribution = map_attr) 
    
  })
  
  filtered_apts <- reactive({
    data %>%
      filter( (data$business_days %in% input$dayClassFilter     
            #  data$staker %in% input$stakerFilter    
            #  data$feeder %in% input$feederFilter    
      ))
    print(input$dayClassFilter)
  })
  print(filtered_apts)
  # Setup a Lealfet Proxy to filter the Points
  #added observe right before the leafletproxy function
  observe(leafletProxy("map", data = filtered_apts()) %>%
            clearMarkers() %>%
            addCircleMarkers(lng = data$Longitude, # Research your Error Messages "Error in $: object of type 'closure' is not subsettable" 
                             lat = data$Latitude,  # We are sending the result Data Frame of filtered_apts() to data, you can't say filtered_apts()$Latitude because its going WTF This is a function not a Data Frame.
                             fillColor  = "blue",
                             color = "black",
                             radius = 14,
                             stroke = TRUE,
                             weight = 2,
                             fillOpacity = 0.5,
                             #added in pathOptions
                         #    options = pathOptions(pane = "markers")
                         ) 
  )
  #when i run the app the filters are not working, all the points are appearing on the map but not changing when i select different options in the pickerinput.
  # Bluebonnet Electric Default Basemap
 
=======
  data <- df   
  
  ##Generate Map display
  # I want to use our custom mapbox style
  bec_map <- "https://api.mapbox.com/styles/v1/gisjohnbb/cjmaudm2mha1e2splkup0tc3s/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2lzam9obmJiIiwiYSI6ImNqbHptM2g3YTBxcWozdm53bXJrOWxwcWwifQ.3zAsFMWc6_CrtYSvEyNl9w"
  
  map_attr <- 'John Lister - GIS Applications Developer | Brandon Mitschke - GIS Applications Student'
  output$map <- renderLeaflet({
    df <- data
    
    leaflet(data = df) %>%    
      setView(-97.285944, 30.104740, 9) %>%
      #added two map panes for each layer
      addMapPane("markers", zIndex = 430) %>% 
      #added another map pane for the appointment table click event 
      addTiles(urlTemplate = bec_map, attribution = map_attr) 
    
  })       
  ########################################################################
  # Here we are watching the Day classification, Feeder, and Staker filter
  # NOTE: When we add the Data Table Filter functionality we want to make sure
  #       - the Data Table is loaded before this observaion. IE Load it after output$map is declared
  observe({
    
    #Retrieve the value selected from the day class, feeder, and staker filter
    dayclass <- input$dayClass

    #Changed the == in the fiter to %in% 
    filtered_apts <- data %>% filter(
      data$business_days %in% dayclass
    )
    #Previewing Data in Console
    print(filtered_apts)
    
    # Setup a Lealfet Proxy to filter the Points
    leafletProxy("map") %>% clearMarkers() %>% 
      addCircleMarkers(lng = filtered_apts$Longitude,
                       lat = filtered_apts$Latitude,
                       fillColor  = "blue",
                       color = "black",
                       stroke = TRUE,
                       weight = 2,
                       fillOpacity = 0.5,
                       #added in pathOptions
                       options = pathOptions(pane = "markers"),
                       popup = paste("<h2>", df$jobnumber,"</h2>", "<br>",   
                                     "<b>Job Name:</b>", df$jobname, "<br>",   
                                     "<b>Pole Number:</b>",df$polenumber, "<br>",    
                                     "<b>Address:</b>", df$houseno," ",df$address," ", "<br>",   
                                     "<b>Meeting Location:</b>", df$meetinglocation, "<br>",   
                                     "<b>Appointment Time:</b>",df$appointmenttime, "<br>",   
                                     "<b>Staker:</b>", df$staker, "<br>",   
                                     "<b>Appointmet Date:</b>",df$appointmentdate, "<br>")) 
    
    
  })
>>>>>>> 4f40dd9ae442366649d163935534b09671525dc9
}