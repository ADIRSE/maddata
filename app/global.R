require(RJSONIO); require(rCharts); require(RColorBrewer); require(httr)
library(ggplot2)
library(ggmap)

getTrafficPoints <- function() {
  num_decimals <- 3
  # load traffic measure  points
  l_traffic_measure_points <- read.csv2('data/PUNTOS_MEDIDA_TRAFICO_2014_01_23_FIXED.csv')
  df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
  df_traffic_measure_points$Long <- as.numeric(as.character(df_traffic_measure_points$Long))
  df_traffic_measure_points$Lat <- as.numeric(as.character(df_traffic_measure_points$Lat))
  df_traffic_measure_points$Long <- round(df_traffic_measure_points$Long, digits = num_decimals)
  df_traffic_measure_points$Lat <- round(df_traffic_measure_points$Lat, digits = num_decimals)
  return (df_traffic_measure_points)
  
}

getAirQualityPoints <- function() {
  num_decimals <- 3
  # load air quality measure points
  l_airq_measure_points <- read.csv2('data/est_airq_madrid.csv')
  df_airq_measure_points <- as.data.frame(l_airq_measure_points)
  df_airq_measure_points$Long2 <- as.numeric(as.character(df_airq_measure_points$Long2))
  df_airq_measure_points$Lat2 <- as.numeric(as.character(df_airq_measure_points$Lat2))
  df_airq_measure_points$Long2 <- round(df_airq_measure_points$Long2, digits = num_decimals)
  df_airq_measure_points$Lat2 <- round(df_airq_measure_points$Lat2, digits = num_decimals)
  return (df_airq_measure_points)
}


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
  df_traffic_measure_points <- getTrafficPoints()
  df_airq_measure_points <- getAirQualityPoints()

  for(i in 1:num_measure_points) {
    html_text <- paste("<h6> Punto de medida del tráfico </h6>")
    html_text <- paste(html_text, "<p>",  df_traffic_measure_points$NOMBRE.C.254[i]," </p>")
    map$marker(c(df_traffic_measure_points$Lat[i], 
                  df_traffic_measure_points$Long[i]), 
                bindPopup = html_text)
  }
  for(i in 1:nrow(df_airq_measure_points)) {
    html_text <- paste("<h6> Estación de calidad del Aire </h6>")
    html_text <- paste(html_text, "<p>",  df_airq_measure_points$Estacion[i]," </p>")
    map$marker(c(df_airq_measure_points$Lat2[i], 
                  df_airq_measure_points$Long2[i]),
                bindPopup = html_text)
  }
#   map$print("chart7")
  map$enablePopover(TRUE)
  map$fullScreen(TRUE)
  map
}