# Set the Server Variable
server <- function(input, output, session) {
  
  #Define Data Frame with Staking Appointments
  data <- df
  #Retrieve the value selected from the day class, feeder, and staker filter
  #changed the filter to a reactive
  
  
  filtered_apts <- reactive({
    df %>%
      filter(data$business_days %in% input$dayClass,    
               data$staker %in% input$stakerFilter,    
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
    datatable(sorted_Apps, rownames = TRUE, selection = list(mode= "single", selected = 0, target="cell"))
  })
}