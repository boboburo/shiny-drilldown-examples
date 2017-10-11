#R version 3.3.0 (2016-05-03)
#https://stackoverflow.com/questions/43263879/creating-drill-down-report-in-r-shiny

library("dplyr")
library("shiny")
library("DT")


##### data #####
# create a summary table
summary_iris <- group_by(iris, Species) %>%
  summarise(Count = n())


