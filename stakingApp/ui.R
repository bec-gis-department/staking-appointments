ui <- fluidPage(
    #Importing Source code for Shiny-Bus Template    
)library(shinydashboard)
library(leaflet)
header <- dashboardHeader(
  #Changing Title to "Staking Appointments"
  title = "Staking Appointments"
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               #Embeding our map into the map tag
               leafletOutput("mymap", height = 1000)
           ),
           box(width = NULL,
               uiOutput("numVehiclesTable")
           )
    ),
    column(width = 3,
           box(width = NULL, status = "warning",
               uiOutput("routeSelect"),
               checkboxGroupInput("directions", "Show",
                                  choices = c(
                                    Northbound = 4,
                                    Southbound = 1,
                                    Eastbound = 2,
                                    Westbound = 3
                                  ),
                                  selected = c(1, 2, 3, 4)
               ),
               p(
                 class = "text-muted",
                 paste("Note: a route number can have several different trips, each",
                       "with a different path. Only the most commonly-used path will",
                       "be displayed on the map."
                 )
               ),
               actionButton("zoomButton", "Zoom to fit buses")
           ),
           box(width = NULL, status = "warning",
               selectInput("interval", "Refresh interval",
                           choices = c(
                             "30 seconds" = 30,
                             "1 minute" = 60,
                             "2 minutes" = 120,
                             "5 minutes" = 300,
                             "10 minutes" = 600
                           ),
                           selected = "60"
               ),
               uiOutput("timeSinceLastUpdate"),
               actionButton("refresh", "Refresh now"),
               p(class = "text-muted",
                 br(),
                 "Source data updates every 30 seconds."
               )
           )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)