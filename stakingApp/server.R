#Set the Server Variable 
server <- function(input, output, session) {
    ########################################################
    # Name: isochrone
    # Description: 
    #            Construct Isochrone variable from map click to send to the OSRM Server
    # Created: 06/03/2019
    # Author: John Lister - GIS Applications Developer
    # Adapted From Example: https://www.r-bloggers.com/shiny-app-drive-time-isochrones/
    # By: Thomas Roh
    
    isochrone <- eventReactive(input$map_click, {
        ## Get the click info from the map
        click <- input$map_click
        clat <- click$lat
        clng <- click$lng
        #shinyalert(c(clng, clat))
        withProgress(message = 'Sending Request',
                     isochrone <- osrmIsochrone(loc = c(clng,clat),
                                                breaks = sort(as.numeric(seq(10,35,5))),
                                                res = 90) %>%
                         st_as_sf()
        )
        isochrone
    })
    data <- reactive({
        x <- df
    })
    ##Generate Map display
    # I want to use our custom mapbox style
    #Found this example at https://rstudio.github.io/leaflet/choropleths.html:
    "
    addProviderTiles('MapBox', options = providerTileOptions(
    id = 'mapbox.light',
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
    "
    output$map <- renderLeaflet({
        df <- data()
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
        leaflet(data = df) %>%
            setView(-97.285944, 30.104740, 10) %>%
            addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
            addCircleMarkers(
                lng = ~Longitude,
                lat = ~Latitude,
                color = getColor(data),
                radius= getSize(data), stroke = FALSE, fillOpacity = 0.5,
                popup = paste("<h2>", df$jobnumber,"</h2>", "<br>",
                              "<b>Job Name:</b>", df$jobname, "<br>",
                              "<b>Pole Number:</b>",df$polenumber, "<br>",
                              "<b>Address:</b>", df$houseno," ",df$address," ", "<br>",
                              "<b>Meeting Location:</b>", df$meetinglocation, "<br>",
                              "<b>Appointment Time:</b>",df$appointmenttime, "<br>",
                              "<b>Staker:</b>", df$staker, "<br>",
                              "<b>Appointmet Date:</b>",df$appointmentdate, "<br>"))
    })
    
    #Wherever you click on the map will generate the drivetime Isochrones
    observeEvent(input$map_click , {
        ## Get the click info from the map
        click <- input$map_click
        clat <- click$lat
        clng <- click$lng
        
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
}