require(shiny)
require(rCharts)

connectImpala()


shinyUI(pageWithSidebar( 
    headerPanel("MADtraffic"),
    sidebarPanel(
      "MADtraffic", 
      
      # Num of measure traffic points
      sliderInput("num_traffic_points", "Número ptos. tráfico:",
                  min = 10, max = 1000, value = 200),
      
      # day of analysis
      dateInput("day_selection", "Selecciona un día:", value = "2014-05-01"
                , min = "2013-01-01"
                , max = "2014-07-01"),
      
      radioButtons("pollutant", "Elige contaminante:",
                   c("CO" = "CO",
                     "CO2" = "CO2",
                     "PM2.5" = "PM2.5",
                     "PM10" = "PM10",
                     "NO" = "NO",
                     "NO2" = "NO2",
                     "NOx" = "NOx",
                     "SO2" = "SO2"), 
                   selected='NO2'),
      
#       selectInput("pollutant", "Elige contaminante:",
#                    pollutants$pollutant, 
#                    selected='NO2'),

      checkboxGroupInput("traf_variables", "Variables de Tráfico:",
                         c("Intensidad" = "intensidad",
                           "Carga" = "carga",
                           "Velocidad media" = "vmed"),
                         selected=c('carga', 'vmed')),
#       selectInput("traf_point", "Punto medida de tráfico", traffic_points_choices)
#       selectInput("traf_point", "Punto medida de tráfico", traffic_points_choices, selected = 'BRAVO MURILLO - (AZUCENAS-CONDE VALLELLANO)')
      selectInput("traf_point", "Punto medida de tráfico", traffic_points_choices, selected = 'PM43221'),
      
      selectInput("airq_point", "Estación de calidad del aire", airq_measure_choices, selected = 'Plaza de España')
      
   ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Puntos de medida del tráfico y calidad del aire", 
                 includeMarkdown("docs/desc_map_points.md"),
                 chartOutput("tab_container_1", 'leaflet')),
        
#         tabPanel("Puntos de medida", 
#                  htmlOutput("tab_container_1_bis")),

          tabPanel("Velocidad media vs Tráfico", 
                 includeMarkdown("docs/desc_chart_series.md"),
                 chartOutput("tab_container_2", 'morris')
                 ),
        
        tabPanel("Top medidas de tráfico", 
                 includeMarkdown("docs/desc_table_top.md"),
                 dataTableOutput("tab_container_3")
        ),
        
        tabPanel("Contaminación mensual", 
                 includeMarkdown("docs/desc_chart_pollution.md"),
                 plotOutput("tab_container_4")
                 ),
        tabPanel("Tabla de contaminación", 
                 includeMarkdown("docs/desc_table_pollution.md"),
                 dataTableOutput("tab_container_5")
        ),
        
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
