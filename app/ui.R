require(shiny)
require(rCharts)

connectImpala()

# traffic_points_choices <- getTrafficPointsChoices()
traffic_points_choices <- getTrafficPointsChoicesImpala()[[1]]
# traffic_points_choices
# typeof(traffic_points_choices)

shinyUI(pageWithSidebar( 
    headerPanel("MADtraffic"),
    sidebarPanel(
      "MADtraffic", 
      
      # Num of measure traffic points
      sliderInput("num_traffic_points", "Número ptos. tráfico:",
                  min = 10, max = 1000, value = 200),
      
      # Range of dates to study data
      dateRangeInput("date_range", "Rango de fechas:",
                     start = "2014-01-01",
                     end = "2014-09-30"),
      
#       selectInput("traf_point", "Punto medida de tráfico", as.list(traffic_points_choices)),
      selectInput("traf_point", "Punto medida de tráfico", traffic_points_choices)

#       selectInput("select", label = h3("Select box"), 
#                   choices = list("Choice 1" = 1, "Choice 2" = 2,
#                                  "Choice 3" = 3), selected = 1)
      
   ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Puntos de medida del tráfico y calidad del aire", chartOutput("tab_container_1", 'leaflet')),
        tabPanel("Tráfico en 1 pto de medida", chartOutput("tab_container_2", 'morris')),
        tabPanel("Prueba", chartOutput("tab_container_3", 'nvd3')),
        
#         tabPanel("Prueba", chartOutput("tab_container_4", 'polycharts')),
        tabPanel("tab_container_4", plotOutput("tab_container_4")),

#         tabPanel("Prueba", chartOutput("tab_container_5", 'xcharts'))
        tabPanel("tab_container_5", plotOutput("tab_container_5")),
#         tabPanel("tab_container_5", dataTableOutput("tab_container_5")),

        tabPanel("Sobre nosotros", includeMarkdown("docs/about_us.md"))
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
