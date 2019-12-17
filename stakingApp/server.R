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
      addMapPane("iso", zIndex = 420) %>%
      addMapPane("markers", zIndex = 430) %>%
      #added another map pane for the appointment table click event
      addMapPane("tblapts", zIndex = 440) %>%
      addTiles(urlTemplate = bec_map, attribution = map_attr)
    
  })      
 observe({
    
    #Retrieve the value selected from the day class, feeder, and staker filter
    dayclass <- input$dayClass
    ##print(dayclass)
    feederfilter <- input$feederFilter  
    ##print(feederfilter)
    stakerfilter<- input$stakerFilter  
    ##print(stakerfilter)
    #Changed the == in the fiter to %in%
    filtered_apts <- data %>% filter(
      data$business_days %in% dayclass &    
        data$staker %in% stakerfilter &    
        data$feeder %in% feederfilter
    )
    #** Output Shit **
    print(filtered_apts$jobnumber) #, filtered_apts$Longitude, filtered_apts$Latitude)
    print(filtered_apts$Longitude)
    
    # Setup a Lealfet Proxy to filter the Points
    leafletProxy("map") %>% clearMarkers() %>%
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
    
    
  
  #----------------------------------------------------------------

  })
  
 
}