require(shiny)
require(leafletR)
require(rCharts)


shinyServer(function(input, output) {
  output$map_container <- renderMap({
    plotMap(500)
  })
})
