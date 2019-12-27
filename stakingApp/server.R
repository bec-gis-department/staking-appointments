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
      addMapPane("markers", zIndex = 430) %>% 
      #added another map pane for the appointment table click event
      addMapPane("tblapts", zIndex = 440 ) %>%
      addTiles(urlTemplate = bec_map, attribution = map_attr) 
    
  })
  #Here is where the data table is started
  output$apttable = DT::renderDataTable({
    datatable(at, rownames = TRUE, selection = list(mode= "single", target="cell"))
  })
  ########################################################################
  # Here we are watching the Day classification, Feeder, and Staker filter
  # NOTE: When we add the Data Table Filter functionality we want to make sure
  #       - the Data Table is loaded before this observaion. IE Load it after output$map is declared
  observe({
    
    #Retrieve the value selected from the day class, feeder, and staker filter
    dayclass <- input$dayClass
    feederfilter <- input$feederFilter
    stakerfilter <- input$stakerFilter
    

    #Changed the == in the fiter to %in% 
    filtered_apts <- data %>% filter(
      data$business_days %in% dayclass &
        data$feeder %in% feederfilter &
        data$staker %in% stakerfilter)
    #Previewing Data in Console
    print(dayclass)
    print(feederfilter)
    print(stakerfilter)
    
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
  #Here is where we are filtering the map by the click event
 observe({ 
    
   selected_apt <- input$apttable_cell_clicked
   # Just for the Memes we are printing the Job Number of the Cell we are Selecting
   print(selected_apt$value)
   # We only want to filter the map if a cell is clicked, if no cell is clicked, we want the map to load all points
   # this if statement is looking if the value is NULL, if its NULL it does nothing, if else it runs the proxy
   if (is.null(selected_apt$value)){
    return()
   } else {
    # This is to filter the map based on the cell clicked in the data table
    filteredselected_apts <- data %>% filter(data$jobnumber %in% selected_apt$value)
    leafletProxy("map") %>%  clearMarkers() %>%
      addCircleMarkers(lng = filteredselected_apts$Longitude,
                       lat = filteredselected_apts$Latitude,
                       fillColor =  "blue",
                       color = "black",
                       radius = 14,
                       stroke = TRUE,
                       weight = 2,
                       fillOpacity = 0.7,
                       #added in pathOptions
                       options = pathOptions(pane = "tblapts"),
                       popup = paste("<h2>", df$jobnumber,"</h2>", "<br>",  
                                     "<b>Job Name:</b>", df$jobname, "<br>",  
                                     "<b>Pole Number:</b>",df$polenumber, "<br>",    
                                     "<b>Address:</b>", df$houseno," ",df$address," ", "<br>",  
                                     "<b>Meeting Location:</b>", df$meetinglocation, "<br>",  
                                     "<b>Appointment Time:</b>",df$appointmenttime, "<br>",  
                                     "<b>Staker:</b>", df$staker, "<br>",  
                                     "<b>Appointmet Date:</b>",df$appointmentdate, "<br>"))    }
    
  
})   
    
}