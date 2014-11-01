require(shiny)
require(rCharts)

# source("global.R")
source("some_charts.R")
source("airq.R")

shinyServer(function(input, output) {
  
  output$map_container <- renderMap({
#     getKMLData()
#     plotMap(500)
    plotMap(input$num_traffic_points)
  })
  output$series_container1 <- renderChart2({
#     print(input$date_range)
#     print(input$date_range[1])
#     print(input$date_range[2])

#     getTrafficSeriesChart()
#     getTrafficSeriesChart(input$traf_point)
#     getTrafficSeriesChart(input$traf_point, input$date_range[1], input$date_range[2])
    getTrafficSeriesChart(input$traf_point, input$date_range[1], 0)
    
  })

  output$series_container2 <- renderChart({
#     getAnotherChart()
    getNVD3test()
#     getNVD3()
  })

  output$series_container3 <- renderChart2({
#     getScatterChart(input)
    getDensityMap()
  })

  output$series_container4 <- renderChart2({
    getxChart()
#     getAQData()
  })
})
