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
    ###################### Start of Filters #################################    
    column(width = 3,
           box(width = NULL, status = "warning",
               
               #Changed uioutput to "dayClass
               uiOutput("dayClassification"),
               #Changed from multiple choice checkbox to multiple choice dropdown
               #Added Today with a value of 0 
               #chnaged the selectInput to a pickerInput
               pickerInput(
                 inputId = "dayClass",
                 label = "Days until Appointment",
                 choices = c("Today" = 0, "Next Buisness Day" = 1, "2 Buinsess Days" = 2,
                             "3 Buisness Days" = 3, "4 Buisness Days" = 4, "5 Buisness Days" = 5),
                 selected = c(0,1,2,3,4,5),
                 options = list(
                   'actions-box' = TRUE,
                   size = 5,
                   'selected-text-format' = "count > 3"
                 ),
                 multiple = TRUE
               ),     
               #Filter by feeder, we'll load unique feeder values here
               #sorted the feeder values randomly
               uiOutput("feederFilter"),
               pickerInput(
                 inputId = "feederFilter",
                 label = "Select Feeder(s):",
                 choices = sort(as.character(unique(df$feeder))),
                 selected = df$feeder,
                 options = list(
                   'actions-box' = TRUE,
                   size = 5,
                   'selected-text-format' = "count > 3"
                 ),
                 multiple = TRUE 
                 
               ),
               
               #We'll load unique staker values here
               #sorted the staker values randomly
               uiOutput("stakerFilter"),
               pickerInput(
                 inputId = "stakerFilter",
                 label = "Select Staker(s)",
                 choices = sort(as.character(unique(df$staker))),
                 selected = df$staker,
                 options = list(
                   'actions-box' = TRUE,
                   size = 5,
                   'selected-text-format' = "count > 3"
                 ),
                 multiple = TRUE
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
