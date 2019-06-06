# UI File contains Look & Layout for the application
header <- dashboardHeader(
              title = "Staking Appointments"
          )

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               #Embeding our map into the map tag
               #Key Note: John Lister 06/05/2019)
                  #Changed the map tag value to be "Map"
                  #This was the only way the Event Observation would work
               leafletOutput("map", height = 1000)
           ),
            box(width = NULL,
               uiOutput("UserAppointmentsTable")
            )
    ),

    column(width = 3,
           box(width = NULL, status = "warning",
     ############# First attempt##################################################         
               #Changed uioutput to "dayClassification"
           uiOutput("dayClassification"),
               #Changed from multiple choice checkbox to multiple choice dropdown
               #Added Today with a value of 0      
                   selectInput("dayClassification", "Days until Appointment",
                                   choices = c(
                                     "Today" = 0,
                                     "Next Buisness Day" = 1,
                                     "2 Buisness Days" = 2,
                                     "3 Buisness Days" = 3,
                                     "4 Buisness Days" = 4
                                  ),
                                 #Makes Today the one selected
                                  selected = 0
     
     
               ),
     ####################################################################################
     
               p(
                 class = "text-muted",
                 #removed the below paragraph for now"
                 paste("")
                 
               ),
               #Here is their action button that calls something from their server.R script, ideally I want ours to update on click
               # BUT I say just get it working before we add that type of event
               actionButton("zoomButton", "Zoom to fit buses")
           )
           
    )
  )
)

#Set the UI Parameter to receive the Constructed Dashboard Components
ui <- dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)