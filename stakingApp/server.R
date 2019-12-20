# Set the Server Variable
server <- function(input, output, session) {
  
  #Define Data Frame with Staking Appointments
  data <- df
  #Retrieve the value selected from the day class, feeder, and staker filter
  #changed the filter to a reactive
  
  
  filtered_apts <- reactive({
    df %>%
      filter(data$business_days %in% input$dayClass &    
               data$staker %in% input$stakerFilter&    
               data$feeder %in% input$feederFilter
      )
  })
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
                             options = pathOptions(pane = "markers")) 
  )
  #when i run the app the filters are not working, all the points are appearing on the map but not changing when i select different options in the pickerinput.
  # Bluebonnet Electric Default Basemap
  bec_map <- "https://api.mapbox.com/styles/v1/gisjohnbb/cjmaudm2mha1e2splkup0tc3s/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2lzam9obmJiIiwiYSI6ImNqbHptM2g3YTBxcWozdm53bXJrOWxwcWwifQ.3zAsFMWc6_CrtYSvEyNl9w"
  map_attr <- 'John Lister - GIS Applications Developer | Brandon Mitschke - GIS Applications Student'
  
  #Render the Leaflet Map
  output$map <- renderLeaflet({
    data <- data
    leaflet(data = data) %>%    
      setView(-97.285944, 30.104740, 9) %>%
      #added two map panes for each layer
      addMapPane("iso", zIndex = 420) %>% 
      addMapPane("markers", zIndex = 430) %>% 
      #added another map pane for the appointment table click event 
      addMapPane("tblapts", zIndex = 440) %>%
      addTiles(urlTemplate = bec_map, attribution = map_attr) 
    
  })
  #-----------------------------------------------
  #Here is where the data table is started
  
  output$apttable = DT::renderDataTable({
    #added in the new table #sorted_apps
    datatable(sorted_Apps, rownames = TRUE, selection = list(mode= "single", selected= 0, target="cell"))
  })
  # Here is where we are filtering the map by the click event
  observe({
    selected_apt <- input$apttable_cell_clicked
  #  This should be filtering the map, but it isn't...
    filteredselected_apts <- data %>% filter(data$jobnumber == selected_apt$value)  
    if(selected_apt > 0){
  #Im getting the error "Error in : Result must have length 117, not 0"
  #im trying to get the program to only run a new proxy if the selected_apt value is greater than 0 (0 being nothing selected) 
  #i think i am close but i keep getting the same error, i know what that error means but i cant find where i can fix it    
    #Here is our leaflet Proxy that sets the map visual (May be a good idea to functionalize this somehow because we re-use it per map filter -\_(",)_/-)
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
                       options = pathOptions(pane = "tblapts"))
    }
    # If the selected_apt value is not greater than 0, nothing happens.\
    else{
      return()
    }
    #  Just for the Memes we are printing the Job Number of the Cell we are Selecting
    print(selected_apt$value)
     })
  

  
  
}