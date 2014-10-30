require(shiny)
require(rCharts)

source("global.R")
source("some_charts.R")

shinyServer(function(input, output) {
  
  output$map_container <- renderMap({
#     getKMLData()
#     plotMap(500)
    plotMap(input$num_traffic_points)
  })
  output$series_container1 <- renderChart2({
    getTrafficSeriesChart()
#     getTrafficSeriesChart(input$traf_point)
  })

  output$series_container2 <- renderChart({
#     getAnotherChart()
    getNVD3test()
#     getNVD3()
  })

  output$series_container3 <- renderChart2({
    getScatterChart(input)
  })

  output$series_container4 <- renderChart2({
    getxChart()
  })
})
