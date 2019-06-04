ui <- fluidPage()
#Importing Source code for Shiny-Bus Template 
# Found this example here https://shiny.rstudio.com/gallery/bus-dashboard.html
library(shinydashboard)
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
           #################################################
           # Development Request from John Lister
           # Date: 06/04/2019
           # Description: This segment here is where I want to have a table showing the user the Appointments with a business_day value of 0
           # Table primary Row ID needs to be the staker, and the Column titles the Appointment Time, See example below
           #    |08:00 | 9:00| 10:00| 11:00| 12:00|
           # ABC|      |     |      |      |      |
           # DEF|      |     |      |      |      |
           # HIJ|      |     |      |      |      |
           #
           # You can build a table using the following example https://shiny.rstudio.com/reference/shiny/0.12.1/tableOutput.html
           # you will need to find where they feed the data to this ui object in server.R and replace with our laoded df data
           # The csv data is already loaded in the df variable and you can reference the values with a $ EG df$jobname brings in the jobname
           box(width = NULL,
               uiOutput("numVehiclesTable")
           )
    ),
    
    #################################################
    # Development Request from John Lister
    # Date: 06/04/2019
    # Description: This segment here is where I want the "Day Classification" Filter.
    #               We are going to substitute their values for the values we symbolize from.
    #               Reference values from df$day_class in getSize from server.R
    #               I Want this to be a drop down filter, this filter will basically turn the map points on and off
    #               You will probably need to do some work in the server.R file
    column(width = 3,
           box(width = NULL, status = "warning",
               #This is a ui function, you will need to see where this references in their server.R file
               uiOutput("routeSelect"),
               #they use a multiple choice checkbox, we want a multiple choice dropdown
               checkboxGroupInput("directions", "Show",
                                  choices = c(
                                    Northbound = 4,
                                    Southbound = 1,
                                    Eastbound = 2,
                                    Westbound = 3
                                  ),
                                  #Defaults what is selected
                                  selected = c(1, 2, 3, 4)
               ),
               p(
                 class = "text-muted",
                 paste("Note: a route number can have several different trips, each",
                       "with a different path. Only the most commonly-used path will",
                       "be displayed on the map."
                 )
               ),
               #Here is their action button that calls something from their server.R script, ideally I want ours to update on click
               # BUT I say just get it working before we add that type of event
               actionButton("zoomButton", "Zoom to fit buses")
           )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)