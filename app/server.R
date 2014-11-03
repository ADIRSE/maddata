library(ggplot2)
require(shiny)
require(rCharts)

# source("global.R")
source("some_charts.R")
source("airq.R")

shinyServer(function(input, output) {
  
  output$tab_container_1 <- renderMap({
#     getKMLData()
    plotMap(input$num_traffic_points)
  })

  output$tab_container_2 <- renderChart2({
    getTrafficSeriesChart(input$traf_point, input$date_range[1], 0)
    
  })

  output$tab_container_3 <- renderChart({
#     getAnotherChart()
    getNVD3test()
#     getNVD3()
  })

#   output$tab_container_4 <- renderChart2({
#     getScatterChart(input)
#   })
  
  output$tab_container_4 <- renderPlot({
    map <- getDensityMap()
    print(map)
  }, width = 900, height = 600)

#   output$tab_container_5 <- renderChart2({
#     getxChart()
#   })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Data Table
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   output$tab_container_5 <- renderDataTable({
#   }, options = list(aLengthMenu = c(10, 15, 30, 50), iDisplayLength = 15))

  output$tab_container_5 <- renderPlot({
    
    ## Check input
    aqdata_path <- "data/airq/aqdata_2014_08.rda"    

    if (file.exists(aqdata_path)){
      ## Use preloaded data
      #       saveRDS (df, file="mytweets.rds")
      aqdata <- readRDS(aqdata_path)      
      #       load("./demo/demo_london_eye.rda")      
      
    } else {
      #       Sys.Date()
      
      ## Use reactive function
      #       df <- create.df()
      
      date_selected <- input$date_range[1]
      date_selected <- as.Date(input$date_range[1])
      month <- tolower(format(date_selected, format = "%b"))
      year <- format(date_selected, format = "%y")
      input_aq_data_file <- paste("data/airq", 
                                  month,
                                  "_mo",
                                  year,
                                  ".txt", sept = '')
      print(input_aq_data_file)
      
#       month <- substr(strptime(date_selected, "%Y-%m-%d"), 6, 7)
      
      ## Display df
      aq_data <- getAQData()
    }

    aq_plot <- getAQPlot(aq_data)
    print(aq_plot)
  
  }, height = 350)


})
