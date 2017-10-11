# Create the airlines with airline as row and months as columns


#Use purrr's split() and map() function to create the list
# needed to display the name of the airline but pass its
# Carrier code as the value

airline_list <- airlines %>%
  collect()  %>%
  split(.$name) %>%
  map(~.$carrier)

# Preparing the data by pre-joining flights to other
# tables and doing some name clean-up
db_flights <- flights %>%
  left_join(airlines, by = "carrier") %>%
  rename(airline = name) %>%
  left_join(airports, by = c("origin" = "faa")) %>%
  rename(origin_name = name) %>%
  select(-lat, -lon, -alt, -tz, -dst) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  rename(dest_name = name) 

#Bar chart

result <- db_flights %>%
  filter(carrier == "AA") %>%
  group_by(dest_name) %>%
  tally() %>%
  filter(!is.na(dest_name)) %>%
  arrange(desc(n)) %>%
  collect() %>% #may not need this
  head(10)

highchart() %>%
  hc_add_series(
    data = result$n, 
    type = "bar",
    name = paste("No. of Flights")) %>%
  hc_xAxis(
    categories = result$dest_name,
    tickmarkPlacement="on")


result <- db_flights %>%
    group_by(carrier, month) %>%
    tally() %>%
    collect() %>%
  spread(carrier, n)

names(result) <- c("carrier",months.of.year)

hc <- highchart() %>% 
  hc_xAxis(categories = result$month) %>% 
  hc_add_series(name = "AA", data = result$AA) %>% 
  hc_add_series(name = "AS", data = result$AS) %>% 
  hc_colors(colsB) %>%
  hc_add_series(name = "DL",data = result$DL) %>%
  hc_colors(colsA)

library("viridisLite")
colsA <- viridis(1)
colsB <- viridis(3)[3]

cols <- substr(cols, 0, 7)
highcharts_demo() %>%
  hc_colors(cols)
  

months.of.year = c("Jan","Feb","Mar","April","May","Jun","Jul","Aug","Sep",
                   "Oct","Nov","Dec")

hc_add_series_df(highchart(), data = result, type = "line", 
                 x = month, y = n, group  = carrier, color = colour) %>%
  hc_xAxis(categories = months.of.year)

highchart() %>% 
  hc_chart(type = "line") %>% 
  hc_add_series_df(data = result, type = "line", 
                   x = month, y = n, group  = carrier) 


 
highchart() %>%
  hc_add_series(
    data = result$n, 
    type = "spline",
    name = paste(group_name, " total flights")) %>%
  hc_xAxis(
    categories = months.of.year,
    tickmarkPlacement = "on")
  

data(citytemp)

hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_series(name = "London", data = citytemp$london) %>% 
  hc_add_series(name = "Other city",
                data = (citytemp$tokyo + citytemp$london)/2)

hc

library(tidyr)
long_temp <- citytemp %>% gather(city, temp, tokyo:london, factor_key = T)

hc_add_series_df(highchart(), data = long_temp, type = "line", 
                 x = as.character(month), y = temp, group  = city) %>%
  hc_xAxis(categories = long_temp$month)

data(economics_long, package = "ggplot2")
economics_long2 <- filter(economics_long,
                          variable %in% c("pop", "uempmed", "unemploy"))
hc_add_series_df(highchart(), economics_long2, "line", x = date,
                 y = value01, group = variable) %>%
  hc_xAxis(type = "datetime")


### Plotly line chart
output$x2 <- renderPlotly({
  
  s <- input$x1_rows_selected
  
  if (!length(s)) {
    p <- d %>%
      plot_ly(x = ~mpg, y = ~disp, mode = "markers", color = I('black'), name = 'Unfiltered') %>%
      layout(showlegend = T) %>% 
      highlight("plotly_selected", color = I('red'), selected = attrs_selected(name = 'Filtered'))
  } else if (length(s)) {
    pp <- m %>%
      plot_ly() %>% 
      add_trace(x = ~mpg, y = ~disp, mode = "markers", color = I('black'), name = 'Unfiltered') %>%
      layout(showlegend = T)
    
    # selected data
    pp <- add_trace(pp, data = m[s, , drop = F], x = ~mpg, y = ~disp, mode = "markers",
                    color = I('red'), name = 'Filtered')
  }
  
})

dens <- with(diamonds, tapply(price, INDEX = cut, density))
df <- data.frame(
  x = unlist(lapply(dens, "[[", "x")),
  y = unlist(lapply(dens, "[[", "y")),
  cut = rep(names(dens), each = length(dens[[1]]$x))
)

result <- db_flights %>%
  group_by(carrier, month) %>%
  tally() %>%
  collect()


  plot_ly(result, x = ~month, y = ~n) %>%
  add_lines() %>%
  add_trace(data = result[result$carrier == "AA",], x = ~month, y = ~n, mode = "lines",
            color = I('red'), name = 'Selected')
  
  
  plot_ly(result, x = ~month, y = ~n, grp = ~carrier name = 'trace 0', type = 'scatter', mode = 'lines')