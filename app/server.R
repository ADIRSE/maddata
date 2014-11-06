
shinyServer(function(input, output) {
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Reactive Functions
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   getAQData <- reactive({
# 
#     input_data_file <- paste(getwd(), '/data/airq/', 'sep_mo14.csv', sep='') # fichero mensual
# #     input_data_file <- paste(getwd(), '/data/airq/', 'airq_ano_14.csv', sep='') # fichero anual
#     aq_data <- read.table(input_data_file, sep=',', dec = ".", header=T)
#     aq_data
# 
#   })
  
  getOnePointTrafficData <- reactive({
    id_traf_point <- getIDTrafPoint(input$traf_point)
    data <- getTrafficSeriesChart(id_traf_point, input$day_selection, 0)
    data
  })
  
  getSumsData <- reactive({
    date <- as.Date(input$day_selection)
    year <- year(date)
    month <- month(date)
    
    filename <- paste('data/sums_data_',
                      year,
                      '-',
                      month,
                      '.csv', sep='')
    
    # store calculations in local csv files
    if (file.exists(filename)) {
      sums_data <- read.csv2(file=filename)
    }
    else {
      sums_data <- getSUMsDataTable(input$day_selection)
      write.csv2(sums_data, file=filename)
    }
    
    sums_data
    
  })
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output Functions
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$tab_container_1 <- renderMap({
    plotMap(input$num_traffic_points)
  })
  
  #   renderHTMl, => doesn't exist 
  #   renderMap, renderChart, renderChart2, rendererOutputType, => Error $ operator is invalid for atomic vectors
  #   renderPrint, => [1] "\n" [26] "  \n" [27] "\n"
  #   renderPlot => nothing
  #   renderText => warnings on console
#   output$tab_container_1_bis <- renderText({
#   
#     df[["greys"]] = gray(seq(0,1, length.out=64))
#     pointPlot = OSMMap(df, color='greys', size='size', layer = 'Points',colorByFactor = F)
#     print(pointPlot, returnText=T)
#     
#   })
  
  output$tab_container_2 <- renderChart2({
    
    data <- getOnePointTrafficData()  
    
    chart <- mPlot(x = 'fecha', 
                   y = input$traf_variables, 
                   type = 'Line',
                   data = data)
    
    chart$set(pointSize = 0, lineWidth = 1)    
    
    chart
  })
  
  output$tab_container_3 <- renderDataTable({
    
    sums_data <- getSumsData()
    sums_data
    
    }, options = list(lengthMenu = c(10, 15, 30, 50), 
                    iDisplayLength = 10,
                    search = list(regex = TRUE)
#                     fnInitComplete = I("function(oSettings, json) {alert( Done. );}")
                    ),
    searchDelay = 500)

  output$tab_container_4 <- renderPlot({
    #     aq_data <- getAQData()
    #     airq_data_2014  # <- es global
    
    date <- as.Date(input$day_selection)
    year <- as.integer(year(date))
    month <- as.integer(month(date))

    station_code <- df_airq_measure_points[df_airq_measure_points$Estacion==input$airq_point,]$Id
    pollutant <- pollutants[pollutants$pollutant==input$pollutant,]$code

    sub_airq_data <- subset(airq_data_2014, Code == station_code & Par == pollutant & mes == month)

    p <- ggplot(data=sub_airq_data, aes(x=as.numeric(hora), 
                                        y=Value, 
                                        group=as.numeric(dia), 
                                        color=dia)) + 
      geom_line() + 
      #       geom_hline(yintercept=200, color='red') + 
      xlim(1, 24)
    
    p <- p + xlab('Hora') + ylab('Nivel contaminante') + theme(legend.position="none")
    
    print(p)
    
  })

  output$tab_container_4 <- renderChart2({
    getScatterChart(input)
  })
  
#   output$tab_container_4_bis <- renderPlot({
#     map <- getDensityMap()
#     print(map)
#   }, width = 900, height = 600)


  output$tab_container_5 <-  renderDataTable({    
    airq_data_2014
    
  }, options = list(lengthMenu = c(10, 15, 30, 50), 
                    iDisplayLength = 10,
                    search = list(regex = TRUE)
                    ),
                searchDelay = 500)
})
