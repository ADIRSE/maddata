require(shiny)
require(rCharts)


shinyServer(function(input, output) {
  output$map_container <- renderMap({
#     getKMLData()
    plotMap(500)
  })
})
