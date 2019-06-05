#UI R file, contains the dashboard Layout
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