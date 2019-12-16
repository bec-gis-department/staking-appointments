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
                                            res = 20) %>%                       
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
      addMapPane("iso", zIndex = 420) %>% 
      addMapPane("markers", zIndex = 430) %>% 
      #added another map pane for the appointment table click event 
      addMapPane("tblapts", zIndex = 440) %>%
      addTiles(urlTemplate = bec_map, attribution = map_attr) 
    
  })       
  ########################################################################
  # Here we are watching the Day classification, Feeder, and Staker filter
  observe({
    ########################################################
    # Name: getColor
    # Description: Read loaded day_class value and produce a marker colour variable
    # Created: 06/03/2019
    # Author: John Lister - GIS Applications Developer
    getColor <- function(day_class) {
      sapply(day_class, function(type_) {
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
      sapply(day_class, function(type_) {
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
                       fillColor  = getColor(filtered_apts$day_class),
                       color = "black",
                       radius = getSize(filtered_apts$day_class), 
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
  #Here is where the data table is started
  #**** Data Table is currently bringing in the main df format***
  
  output$apttable = DT::renderDataTable({
    datatable(at, rownames = TRUE, selection = list(mode= "single",target="cell"))
  })
  observe({
    #Appointment table click event 
    selected_apt <- input$apttable_cell_clicked 
    
    #**Preview 
    print(selected_apt$value)
  
    #filter map based on cell selected
    
    filteredselected_apts <- data %>% filter(data$jobnumber %in% selected_apt$value)

    leafletProxy("map") %>% clearMarkers() %>% 
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
                                     "<b>Appointmet Date:</b>",df$appointmentdate, "<br>"))
   })
   
  ##########################################################################################
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
                  #added in pathOptions
                  options = pathOptions(pane = "iso"),
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
   observe({
     if(input$cleariso==0)
       return()
     else
       leafletProxy("map") %>%
       clearShapes() %>%
       clearControls()
   })
}