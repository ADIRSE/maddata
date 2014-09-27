# require(rCharts)
options(RCHART_WIDTH = 800)
library(shiny)
library(ggplot2)
library(ggmap)
library(jsonlite)
library(png)
library(grid)
library(RCurl)
library(plyr)
library(markdown)

coord_madrid <- c(lon = -3.688810, lat = 40.420088)
madrid = get_map(location = coord_madrid, zoom = 12, maptype = 'roadmap')
madrid_map = ggmap(madrid)
madrid_map

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
  output$map <- renderPlot({
#     map.base <- get_googlemap(
#       as.matrix(temp.geocode),
#       maptype = input$type, ## Map type as defined above (roadmap, terrain, satellite, hybrid)
#       markers = temp.geocode,
#       zoom = input$zoom,            ## 14 is just about right for a 1-mile radius
#       color = temp.color,   ## "color" or "bw" (black & white)
#       scale = temp.scale   ## Set it to 2 for high resolution output
#     )
#     map.final <- map.base
#     print(map.final)
    
    print(madrid_map)
  })
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
})