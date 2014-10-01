require(RJSONIO); require(rCharts); require(RColorBrewer); require(httr)
library(ggplot2)
library(ggmap)

plotMap <- function(num_measure_points = nrow(df_traffic_measure_points), 
                    width = 1600, 
                    height = 800){
  
  map <- Leaflet$new()
  map$setView(c(40.41, -3.70), zoom = 12)
#   map$geoJson(toGeoJSON(df_airq_measure_points), 
#              onEachFeature = '#! function(feature, layer){
#       layer.bindPopup(feature.properties.popup)
#     } !#',
#              pointToLayer =  "#! function(feature, latlng){
#       return L.circleMarker(latlng, {
#         radius: 4,
#         fillColor: feature.properties.fillColor || 'red',    
#         color: '#000',
#         weight: 1,
#         fillOpacity: 0.8
#       })
#     } !#")

  # load traffic measure  points
  l_traffic_measure_points <- read.csv2('PUNTOS_MEDIDA_TRAFICO_2014_01_23_FIXED.csv')
  df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
  df_traffic_measure_points$Long <- as.numeric(as.character(df_traffic_measure_points$Long))
  df_traffic_measure_points$Lat <- as.numeric(as.character(df_traffic_measure_points$Lat))
  df_traffic_measure_points$Long <- round(df_traffic_measure_points$Long, digits = 2)
  df_traffic_measure_points$Lat <- round(df_traffic_measure_points$Lat, digits = 2)
  
  # load air quality measure points
  l_airq_measure_points <- read.csv2('est_airq_madrid.csv')
  df_airq_measure_points <- as.data.frame(l_airq_measure_points)
  df_airq_measure_points$Long2 <- as.numeric(as.character(df_airq_measure_points$Long2))
  df_airq_measure_points$Lat2 <- as.numeric(as.character(df_airq_measure_points$Lat2))
  df_airq_measure_points$Long2 <- round(df_airq_measure_points$Long2, digits = 2)
  df_airq_measure_points$Lat2 <- round(df_airq_measure_points$Lat2, digits = 2)

  for(i in 1:num_measure_points) {
    html_text <- paste("<p>",  df_traffic_measure_points$NOMBRE.C.254[i]," </p>")
    map$marker(c(df_traffic_measure_points$Lat[i], 
                  df_traffic_measure_points$Long[i]), 
                bindPopup = html_text)
  }
  for(i in 1:nrow(df_airq_measure_points)) {
    html_text <- paste("<p>",  df_airq_measure_points$Estacion[i]," </p>")
    map$marker(c(df_airq_measure_points$Lat2[i], 
                  df_airq_measure_points$Long2[i]),
                bindPopup = html_text)
  }
#   map$print("chart7")
#   map$enablePopover(TRUE)
#   map$fullScreen(TRUE)
  map
}