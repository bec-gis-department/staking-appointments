# Set the Server Variable
server <- function(input, output, session) {
  
  #Define Data Frame with Staking Appointments
  data <- df
  #Retrieve the value selected from the day class, feeder, and staker filter
  #changed the filter to a reactive
  #deleted the "dayclass <- input$dayClass" like expressions. 
  filtered_apts <- reactive({
    df %>%
      filter(data$business_days %in% input$dayClass &    
               data$staker %in% input$stakerFilter &    
               data$feeder %in% input$feederFilter
      )
  })
  # Setup a Lealfet Proxy to filter the Points
  #added observe right before the leafletproxy function
  observe(leafletProxy("map", data = filtered_apts()) %>%
            clearMarkers() %>%
            addCircleMarkers(lng = filtered_apts$Longitude,
                             lat = filtered_apts$Latitude,
                             fillColor  = "blue",
                             color = "black",
                             radius = 14,
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
          
  # got error : Error in $: object of type 'closure' is not subsettable        
  )
  
  ##Generate Map display
  # I want to use our custom mapbox style
  bec_map <- "https://api.mapbox.com/styles/v1/gisjohnbb/cjmaudm2mha1e2splkup0tc3s/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2lzam9obmJiIiwiYSI6ImNqbHptM2g3YTBxcWozdm53bXJrOWxwcWwifQ.3zAsFMWc6_CrtYSvEyNl9w"
  
  map_attr <- 'John Lister - GIS Applications Developer | Brandon Mitschke - GIS Applications Student'
  output$map <- renderLeaflet({
    df <- data
    
    leaflet(data = df) %>%    
      setView(-97.285944, 30.104740, 9) %>%
      #added two map panes for each layer
      addMapPane("iso", zIndex = 420) %>%
      addMapPane("markers", zIndex = 430) %>%
      #added another map pane for the appointment table click event
      addMapPane("tblapts", zIndex = 440) %>%
      addTiles(urlTemplate = bec_map, attribution = map_attr)
    
  })      
    
    
    #** Output Shit **
   # print(filtered_apts$jobnumber) #, filtered_apts$Longitude, filtered_apts$Latitude)
   # print(filtered_apts$Longitude)
    
  
    #----------------------------------------------------------------
    
  
  
  
}