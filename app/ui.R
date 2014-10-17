require(shiny)
require(rCharts)

shinyUI(pageWithSidebar( 
    headerPanel("MADtraffic"),
    sidebarPanel(
      "MADtraffic", 
       selectInput(inputId = "x",
                   label = "Choose X",
                   choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                   selected = "SepalLength"),
       selectInput(inputId = "y",
                   label = "Choose Y",
                   choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                       selected = "SepalWidth")              
   ),
    
    mainPanel(
      tabsetPanel(
#         tabPanel("Puntos de medida del tráfico y calidad del aire", mapOutput('map_container')),
        tabPanel("Puntos de medida del tráfico y calidad del aire", chartOutput("map_container", 'leaflet')),
        tabPanel("Prueba", chartOutput("series_container1", 'morris')),
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
