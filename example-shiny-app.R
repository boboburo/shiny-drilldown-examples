ibrary("shiny")
library("highcharter")

data(citytemp)

ui <- fluidPage(
  h1("Highcharter EXAMPLE"),
  fluidRow(
    column(width = 8,
           highchartOutput("hcontainer",height = "500px")
    ),
    selectInput("option", label = "",  width = "100%",
                choices = c("Tokyo", "NY"))
  )
)

server <- function(input, output) {
  data <- citytemp[,c("month","tokyo","new_york")]
  data = data[data$month%in%c("Dec","Jan","Feb","Mar"),]
  choose_Option <- reactive({
    sort_option <- input$option
    if(sort_option=="Tokyo"){
      data = data[order(data$tokyo),]
    }
    else{
      data = data[order(data$new_york),]
    }
    return(data)
  })
  output$hcontainer <- renderHighchart({
    data = choose_Option()
    data = data[1:3,] 
    colors_for_categories <- c()
    
    colors_fun <- function(month){
      if(month=="Dec"){return (c("#1B1858"))}
      if(month=="Jan"){return (c("#00A1DE"))}
      if(month=="Feb"){return (c("#2E28AB"))}
      if(month=="Mar"){return (c("#0D653C"))} 
    }
    
    colors_for_categories  <- colors_fun(data$month[[1]])
    for(m in 2:3){
      colors_for_categories  <- append(colors_for_categories ,colors_fun(data$month[[m]]))
    }
    chart <-  highchart() %>% 
      hc_chart(type = "bar") %>% 
      hc_title(text = "Monthly Average Temperature for main cities") %>% 
      hc_subtitle(text = "Source: WorldClimate.com") %>% 
      hc_xAxis(categories = data$month) %>% 
      hc_yAxis(title = list(text = "Temperature (C)")) 
    
    hc <- chart %>% hc_add_series(yAxis=0,name="Tokyo",data = data$tokyo,colorByPoint=TRUE,colors=colors_for_categories )
    hc <- hc %>% hc_add_series(yAxis=0,name="NY",data = data$new_york,colorByPoint=TRUE,colors=colors_for_categories )    
    
    return(hc)
  })
} 

shinyApp(ui = ui, server = server)