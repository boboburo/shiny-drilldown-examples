shinyUI(dashboardPage(
  dashboardHeader(title = "Flights Dashboard",
                  titleWidth = 200),
  dashboardSidebar(
    selectInput(
      inputId = "airline",
      label = "Airline:", 
      choices = airline_list, 
      selectize = FALSE),
    sidebarMenu(
      selectInput(
        "month",
        "Month:", 
        list(
          "All Year" = 99,
          "January" = 1,
          "February" = 2,
          "March" = 3,
          "April" = 4,
          "May" = 5,
          "June" = 6,
          "July" = 7,
          "August" = 8,
          "September" = 9,
          "October" = 10,
          "November" = 11,
          "December" = 12
        ) , 
        selected =  "All Year", 
        selectize = FALSE),
      actionLink("remove", "Remove detail tabs")
    )
  ),
  dashboardBody(      
    tabsetPanel(id = "tabs",
                tabPanel(
                  title = "Main Dashboard",
                  value = "page1",
                  fluidRow(
                    valueBoxOutput("total_flights"),
                    valueBoxOutput("per_day"),
                    valueBoxOutput("percent_delayed")
                  ),
                  fluidRow(
                    
                    
                  ),
                  fluidRow(
                    column(width = 7,
                           p(textOutput("monthly")),
                           highchartOutput("group_totals")),
                    column(width = 5,
                           p("Click on an airport in the plot to see the details"),
                           highchartOutput("top_airports"))
                  )
                )
    )
  )
)
)