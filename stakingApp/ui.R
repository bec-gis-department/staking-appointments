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
                   selectInput("dayClassification", "Days until Appointment:",
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
            #Filter by feeder, we'll load unique feeder values here
           uiOutput("feederFilter"),
             selectInput("feederFilter", "Select Feeder(s):",
                         choices = c(
                           "Load Feeder Info Here" = 0
                         ),
                         #Makes Today the one selected
                         selected = 0
                         
                         
             ),
            #We'll load unique staker values here
           uiOutput("stakerFilter"),
             selectInput("stakerFilter", "Select Staker:",
                         choices = c(
                           "Load Staker Info Here" = 0
                         ),
                         #Makes Today the one selected
                         selected = 0
                       
                       
           ),
     ####################################################################################
     
               p(
                 class = "text-muted",
                 paste("Here we will have filters allowing you to sort by staker, feeder and day classification")
                 
               ),
            #We can probably use this action here to apply the filters
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
