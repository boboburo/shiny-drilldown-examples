#R version 3.3.0 (2016-05-03)
#https://gist.github.com/edgararuiz/89e771b5d1b82adaa0033c0928d1846d

library(shinydashboard)
library(dplyr)
library(dbplyr)
library(purrr)
library(shiny)
library(highcharter)
library(DT)
library(htmltools)
library(nycflights13)


#Use purrr's split() and map() function to create the list
# needed to display the name of the airline but pass its
# Carrier code as the value

airline_list <- airlines %>%
collect()  %>%
split(.$name) %>%
map(~.$carrier)
