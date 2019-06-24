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
               #Changed the map tag value to be "map"
               #This was the only way the Event Observation would work
               leafletOutput("map", height = 700)
           ),
           box(width = NULL,
               DT::dataTableOutput("apttable")
           )
    ),
    ######################Start of Filters################################    
    column(width = 3,
           box(width = NULL, status = "warning",
               #Changed uioutput to "dayClass
               uiOutput("dayClassification"),
               #Changed from multiple choice checkbox to multiple choice dropdown
               #Added Today with a value of 0 
               
               selectInput(inputId = "dayClass", "Days until Appointment:",
                           choices = c( 
                             "Today" = 0,
                             "Next Business Day" = 1,
                             "2 Business Days" = 2,
                             "3 Business Days" = 3,
                             "4 Business Days" = 4,
                             "5 Business Days" = 5,
                             "More than 5..."  > 5
                         
                           ),
               ),
               #Filter by feeder, we'll load unique feeder values here
               #sorted the feeder values randomly
               uiOutput("feederFilter"),
               selectInput("feederFilter", "Select Feeder(s):",
                           choices = sort(unique(df$feeder))
                           
               ),
               
               #We'll load unique staker values here
               #sorted the staker values randomly
               uiOutput("stakerFilter"),
               selectInput("stakerFilter", "Select Staker:",
                           choices = sort(unique(df$staker))
               ),
               ####################################################################################
               p(
                 class = "text-muted",
                 paste("Here we have filters allowing you to sort by staker, feeder and day classification")
                 
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
