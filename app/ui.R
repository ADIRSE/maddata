require(shiny)
require(rCharts)

connectImpala()

# traffic_points_choices <- getTrafficPointsChoices()
traffic_points_choices <- getTrafficPointsChoicesImpala()

shinyUI(pageWithSidebar( 
    headerPanel("MADtraffic"),
    sidebarPanel(
      "MADtraffic", 
      
      # Num of measure traffic points
      sliderInput("num_traffic_points", "Número ptos. tráfico:",
                  min = 10, max = 1000, value = 200),
      
      # Range of dates to study data
      dateRangeInput("date_range", "Date range:",
                     start = "2013-01-01",
                     end = "2014-09-30"),
      
      selectInput("traf_point", "Punto medida de tráfico", as.list(traffic_points_choices)),
      
      selectInput("select", label = h3("Select box"), 
                  choices = list("Choice 1" = 1, "Choice 2" = 2,
                                 "Choice 3" = 3), selected = 1)
      
   ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Puntos de medida del tráfico y calidad del aire", chartOutput("map_container", 'leaflet')),
        tabPanel("Tráfico en 1 pto de medida", chartOutput("series_container1", 'morris')),
        tabPanel("Prueba", chartOutput("series_container2", 'nvd3')),
        tabPanel("Prueba", chartOutput("series_container3", 'polycharts')),
        tabPanel("Prueba", chartOutput("series_container4", 'xcharts'))
      )
    )
))



# 
# shinyUI(bootstrapPage( 
# #   tags$link(href='style.css', rel='stylesheet'),
# #   tags$script(src='app.js'),
# #   includeHTML('www/credits.html'),
# #   selectInput('network', '', sort(names(networks)), 'citibikenyc'),
#   chartOutput('map_container', 'leaflet')
# ))
