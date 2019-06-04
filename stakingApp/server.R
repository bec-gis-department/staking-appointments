server <- function(input,output, session){
    
    data <- reactive({
        x <- df
    })
    
    ########################################################
    # Name:
    # Description:
    # Created:
    # Author:
    output$mymap <- renderLeaflet({
        df <- data()
        
        #Isochrone Functions
        isoCoords <- reactive({
            coords <- c(lat = input$lat,
                        lon = input$lon)
            coords
        })
        
        isochrone <- eventReactive(input$submit, {
            shinyalert(c(isoCoords()[['lon']], isoCoords()[['lat']]))
            withProgress(message = 'Sending Request',
                         isochrone <- osrmIsochrone(loc = c(isoCoords()[['lon']],
                                                            isoCoords()[['lat']]),
                                                    breaks = sort(as.numeric(seq(10,35,5))),
                                                    res = 20) %>%
                             st_as_sf()
            )
            isochrone
        })
        
        ########################################################
        # Name:
        # Description:
        # Created:
        # Author: 
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
        # Name:
        # Description:
        # Created:
        # Author:
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
        m <- leaflet(data = df) %>%
            addTiles() %>%
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
        m
    })
    
    ########################################################################################################
    #-------------------------------------------Click Event------------------------------------------------
    observeEvent(input$submit , {
        steps <- sort(as.numeric(seq(10,35,5)))
        #shinyalert(steps)
        isochrone <- cbind(steps = steps[isochrone()[['id']]], isochrone())
        pal <- colorFactor(viridis::viridis(nrow(isochrone), direction = -1), 
                           isochrone$steps)
        leafletProxy("map") %>%
            clearShapes() %>%
            #I think if I remove the clear marker part it won't flush my staking markers
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
            # Surely i don't need to add a marker for this one?
            #addMarkers(lng = input$lon, input$lat) %>%
            setView(isoCoords()[['lon']], isoCoords()[['lat']], zoom = 9)
    })
}