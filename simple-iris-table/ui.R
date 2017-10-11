## ui.R ##
shinyUI(
  fluidPage(
  dataTableOutput("summary")
  , dataTableOutput("drilldown")
)
)