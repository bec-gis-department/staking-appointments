
# UI File contains Look & Layout for the application
title <- tags$img(src="whitelogo.png",
                  height = '50',width = '50', ' ',
                  'Staking Appointments')

header <- dashboardHeader(
  
  title = title, titleWidth = 300)
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
               p(
                 class= "text-muted",
                 paste("Here we have filters allowing you to sort by Day Classification, Feeder, and Staker")
                 
               ),
               
               #Changed uioutput to "dayClass
               uiOutput("dayClass"),
               #Changed from multiple choice checkbox to multiple choice dropdown
               #Added Today with a value of 0 
               #chnaged the selectInput to a pickerInput
               pickerInput(
                 inputId = "dayClass",
                 label = "Days until Appointment",
                 choices = c("Today" = 0, "Next Business Day" = 1, "2 Business Days" = 2,
                             "3 Business Days" = 3, "4 Business Days" = 4, "5 Business Days" = 5, "9999 Year"=6),
                 selected = c(0,1,2,3,4,5,6),
                 options = list(
                   'actions-box' = TRUE,
                   size = 5,
                   'selected-text-format' = "count > 3"
                 ),
                 multiple = TRUE
               ),
               #filter by feeder
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
               #filter by staker
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
               #############################################################
               p(
                 class= "text-muted",
                 paste("Click below to clear the isochrones from the map")
                 
               ),
               
               #We use this actionbutton to clear isochrones
               actionButton("cleariso", "Clear Isochrones")
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