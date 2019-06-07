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
               leafletOutput("map", height = 700)
           ),
            box(width = NULL,
                DT::dataTableOutput("apttable")
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
                                     "Next Business Day" = 1,
                                     "2 Business Days" = 2,
                                     "3 Business Days" = 3,
                                     "4 Business Days" = 4,
                                     "5 Business Days" = 5,
                                     "More than 5..."  > 5
                                  ),
                                 #Makes Today the one selected
                                  selected = 0
     
     
               ),
     ####################################################################################
     
               p(
                 class = "text-muted",
                 #removed the below paragraph for now"
                 paste("Here we will have filters allowing you to sort by staker, feeder and day classification")
                 
               ),
               #Here is their action button that calls something from their server.R script, ideally I want ours to update on click
               # BUT I say just get it working before we add that type of event
               actionButton("applyFilters", "Apply Filters")
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
