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
  isochrone <- eventReactive(c(input$map_click, input$map_shape_click), {
    if(is.null(input$map_shape_click)){
      ## Get the click info from the map
      click <- input$map_click
      clat <- click$lat
      clng <- click$lng
    }
    else if(is.null(input$map_click)){
      ## Get the click info from the map
      click <- input$map_shape_click
      clat <- click$lat
      clng <- click$lng    
    }
    #shinyalert(c(clng, clat))
    withProgress(message = 'Sending Request',
                 isochrone <- osrmIsochrone(loc = c(clng,clat),
                                            breaks = sort(as.numeric(seq(10,35,5))),
                                            res = 40) %>%
                   st_as_sf()
    )
    isochrone
  })
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
  ########################################################
  # Name: getColor
  # Description: Read loaded day_class value and produce a marker colour variable
  # Created: 06/03/2019
  # Author: John Lister - GIS Applications Developer
  getColor <- function(day_class) {
    sapply(df$day_class, function(type_) {
      if(type_ == 'Today') {
        "blue"
      } else if(type_ == 'Next Business Day') {
        "teal"
      } else if(type_ == '2 Business Days') {
        "green"  
      } else if(type_ == '3 Business Days') {
        "yellow"  
      } else if(type_ == '4 Business Days') {
        "orange"  
      } else if(type_ == '5 Business Days') {
        "red"  
      } else if(type_ == 'More than 5 business days') {
        "grey"  
      }else {
        "purple"
      } })
  }
  ########################################################
  # Name: getSize
  # Description: Read day_class dataframe value and produce a marker size variable
  # Created: 06/03/2019
  # Author: John Lister - GIS Applications Developer
  getSize <- function(day_class) {
    sapply(df$day_class, function(type_) {
      if(type_ == 'Today') {
        14
      } else if(type_ == 'Next Business Day') {
        11
      } else if(type_ == '2 Business Days') {
        9  
      } else if(type_ == '3 Business Days') {
        7  
      } else if(type_ == '4 Business Days') {
        6
      } else if(type_ == '5 Business Days') {
        4  
      } else if(type_ == 'More than 5 business days') {
        2  
      }else {
        2
      } })
  }
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
                       color = getColor(filtered_apts$buisness_days),
                       radius= getSize(filtered_apts$buisness_days),
                       stroke = FALSE,
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
 #Wherever you click on the map will generate the drivetime Isochrones
 observeEvent(c(input$map_click, input$map_shape_click) , {
   #Validate which event is happening
   if(is.null(input$map_shape_click)){
     ## Get the click info from the map
     click <- input$map_click
     clat <- click$lat
     clng <- click$lng
   }
   else if(is.null(input$map_click)){
     ## Get the click info from the map
     click <- input$map_shape_click
     clat <- click$lat
     clng <- click$lng    
   }
   
   #Build the Isochrone Steps
   steps <- sort(as.numeric(seq(10,35,5)))
   #shinyalert(steps)
   isochrone <- cbind(steps = steps[isochrone()[['id']]], isochrone())
   pal <- colorFactor(viridis::viridis(nrow(isochrone), direction = -1),
                      isochrone$steps)
   leafletProxy("map") %>%
     clearShapes() %>%
     #clearMarkers() %>%
     clearControls() %>%
     addPolygons(data = isochrone,
                 weight = .5,
                 color = ~pal(steps)) %>%
     addLegend(data = isochrone,
               pal = pal,
               values = ~steps,
               title = 'Drive Time (min.)',
               opacity = 1) %>%
     #addMarkers(lng = clng, clat) %>%
     setView(clng, clat, zoom = 9)
 })
 # Isochrone Clear Event
 observe({
   if(input$cleariso==0)
     return()
   else
     leafletProxy("map") %>%
     clearShapes() %>%
     clearControls()
 })  
}