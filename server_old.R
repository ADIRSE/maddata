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
library(plotGoogleMaps)
library(sp)

# meuse example
if (exists("meuse")) {
  data(meuse)
  coordinates(meuse)<-~x+y # convert to SPDF
  proj4string(meuse) <- CRS('+init=epsg:28992')
  meuse_map <- plotGoogleMaps(meuse, filename = 'meuseMap.html', openMap = F)
}

# google map with our coordinates
if (!exists("df_traffic_measure_points")) {
  print ("loading data file with measure traffic points...")
  data_folder <- 'data'
  file1 <- paste(data_folder, 'PUNTOS_MEDIDA_TRAFICO_2014_01_23_FIXED.csv', sep = '/')
  l_traffic_measure_points <- read.csv2(file1)
  df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
  df_traffic_measure_points$Lat <- as.numeric(df_traffic_measure_points$Lat)
  df_traffic_measure_points$Lon <- as.numeric(df_traffic_measure_points$Long)
#   coordinates(df_traffic_measure_points) = ~x+y
  coordinates(df_traffic_measure_points) = ~Lat+Lon
  proj4string(df_traffic_measure_points) <- CRS("+init=epsg:3042")
  sample <- df_traffic_measure_points[1:50,]
  m <- plotGoogleMaps(sample, filename = 'sample_new_coords.html', openMap = F)
  n <- plotGoogleMaps(df_traffic_measure_points, filename = 'new_coords.html', openMap = F)
}

# get madrid static map
if (!exists("madrid_map")) {
  coord_madrid <- c(lon = -3.688810, lat = 40.420088)
  madrid = get_map(location = coord_madrid, zoom = 12, maptype = 'roadmap')
#   madrid = get_googlemap(location = coord_madrid, zoom = 12, maptype = 'roadmap', size=(640, 640))
  madrid_map <- ggmap(madrid)
#   Lat <- sample$Lat
#   Lon <- sample$Lon
#   madrid_map + geom_point(data=sample, aes(x=Lat, y=Lon), size=5)
  
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
  output$madrid_static_Plot <- renderPlot({    
    print(madrid_map)
  })
  # meuse example
  output$googleMapPlotMeuse <- renderUI({
    tags$iframe(
      srcdoc = paste(readLines('meuseMap.html'), collapse = '\n'),
      width = "100%",
      height = "400px"
    )
  })
  # OUR DATA
  output$googleMapPlot <- renderUI({
#     proj4string(df_traffic_measure_points) = CRS("+init=epsg:28992")
    tags$iframe(
      srcdoc = paste(readLines('myMap1.html'), collapse = '\n'),
      width = "100%",
      height = "600px"
    )
  })
})