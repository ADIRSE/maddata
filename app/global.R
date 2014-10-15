require(RJSONIO)
require(rCharts)
require(RColorBrewer)
require(httr)
library(ggplot2)
library(ggmap)
require(downloader)

## @knitr getData
getData <- function(network = 'citibikenyc'){
  require(httr)
  url = sprintf('http://api.citybik.es/%s.json', network)
  bike = content(GET(url))
  lapply(bike, function(station){within(station, { 
    fillColor = cut(
      as.numeric(bikes)/(as.numeric(bikes) + as.numeric(free)), 
      breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1), 
      labels = brewer.pal(5, 'RdYlGn'),
      include.lowest = TRUE
    ) 
    popup = iconv(whisker::whisker.render(
      '<b>{{name}}</b><br>
        <b>Free Docks: </b> {{free}} <br>
         <b>Available Bikes:</b> {{bikes}}
        <p>Retreived At: {{timestamp}}</p>'
    ), from = 'latin1', to = 'UTF-8')
    latitude = as.numeric(lat)/10^6
    longitude = as.numeric(lng)/10^6
    lat <- lng <- NULL})
  })
}

# test <- function() {
#   data(quakes)
#   toGeoJSON(data=quakes, name="quakes", dest=tempdir(), lat.lon=c(1,2))
#   path <- toGeoJSON(data=quakes)
#   toGeoJSON(data=quakes[1:99,], dest=tempdir(), name="quakes")
#   
#   
#   print("------------")
#   print(leafletR::toGeoJSON(getTrafficPoints(2), lat.lon = c('Lat', 'Long')))
#   print(data = toGeoJSON(getTrafficPoints(2), lat.lon = c('Lat', 'Long')))
#   print("------------")
#   print(toGeoJSON(getData('citibikenyc')))
#   print("------------")
# }

## @knitr getData
getTrafficPoints <- function(limit = 0) {
  num_decimals <- 3
  # load traffic measure  points
  input_file <- paste(getwd(), '/data/PUNTOS_MEDIDA_TRAFICO_2014_01_23_FIXED.csv', sep='')
  l_traffic_measure_points <- read.csv2(input_file)
  df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
  df_traffic_measure_points$Long <- as.numeric(as.character(df_traffic_measure_points$Long))
  df_traffic_measure_points$Lat <- as.numeric(as.character(df_traffic_measure_points$Lat))
  df_traffic_measure_points$Long <- round(df_traffic_measure_points$Long, digits = num_decimals)
  df_traffic_measure_points$Lat <- round(df_traffic_measure_points$Lat, digits = num_decimals)
  
  if (limit == 0)
    return (df_traffic_measure_points)
  else
    return (df_traffic_measure_points[1:limit,])
}

## @knitr getData
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

## @ knitr getKMLData
getKMLData <- function () {
  require(downloader)
  kml_url = 'http://datos.madrid.es/egob/catalogo/202088-0-trafico-camaras.kml'
  kml_file = '/data/202088-0-trafico-camaras.kml'
  if (file.exists(kml_file)) {
    download(url=kml_url, destfile = kml_file)
  }
  #   print(toGeoJSON(kml_file))
  #   toGeoJSON(data=quakes, name="quakes", dest=tempdir(), lat.lon=c(1,2))
#   return (toGeoJSON(kml_file))
  return (kml_file)
}

addColVis <- function(data) {
  nrows <- nrow(data)
  data$fillColor <- rgb(runif(nrows),runif(nrows),runif(nrows))  
  return (data)
}

getCenter <- function(nm, networks){
  net_ = networks[[nm]]
  lat = as.numeric(net_$lat)/10^6;
  lng = as.numeric(net_$lng)/10^6;
  return(list(lat = lat, lng = lng))
}

## @knitr plotMap
plotMap <- function(num_measure_points = nrow(df_traffic_measure_points), 
                    width = 1600, 
                    height = 800){
  
  map <- Leaflet$new()
  map$tileLayer(provide='Stamen.TonerLite')
  
  #   init map
  map$setView(c(40.41, -3.70), zoom = 12, size = c(20, 20))
  
  #   Please note: data only accepts GeoJSON files with 
  #   one geometry type and geographical coordinates (longlat, WGS84).
  #   map$tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
  
  # get kml data
  #   kml_file <- getKMLData()
  #   map$addKML(kml_file)
  #   map$save('index.html', cdn = TRUE)
  
  #   get data points
  df_traffic_measure_points <- getTrafficPoints(num_measure_points)
  df_airq_measure_points <- getAirQualityPoints()

  data_ <- df_traffic_measure_points[,c("Lat", "Long")]
  data_ <- addColVis(data_)
  colnames(data_) <- c('latitude', 'longitude', 'fillColor')
  
  output_geofile <- paste(getwd(), '/data/', sep='')

  #   citybikes example
  #   data_ <- getData(network); center_ <- getCenter(network, networks)popuppopup
  #   center_ <- getCenter(network, networks)    
  #   another example
  #   names(data_) <- c('lat', 'lng', 'fillColor')
  #   map$geocsv(data_)
  
  map$geoJson(
        leafletR::toGeoJSON(data_, 
#                             lat.lon = c('Lat', 'Long'),
                            dest=output_geofile),
        onEachFeature = '#! function(feature, layer){
                              layer.bindPopup(feature.properties.popup)
                            } !#',
        pointToLayer =  "#! function(feature, latlng){
                            return L.circleMarker(latlng, {
                              radius: 6,
                              fillColor: feature.properties.fillColor || 'blue',
                              color: '#333',
                              weight: 1,
                              fillOpacity: 0.8
                            })
                          } !#")
#   )

#   # append markers and popup texts
#   for(i in 1:num_measure_points) {
#     html_text <- paste("<h6> Punto de medida del tráfico </h6>")
#     html_text <- paste(html_text, "<p>",  df_traffic_measure_points$NOMBRE.C.254[i]," </p>")
#     map$marker(c(df_traffic_measure_points$Lat[i], 
#                   df_traffic_measure_points$Long[i]), 
#                 bindPopup = html_text)
#   }
# 
#   # append markers and popup texts
#   for(i in 1:nrow(df_airq_measure_points)) {
#     html_text <- paste("<h6> Estación de calidad del Aire </h6>")
#     html_text <- paste(html_text, "<p>",  df_airq_measure_points$Estacion[i]," </p>")
#     map$marker(c(df_airq_measure_points$Lat2[i], 
#                   df_airq_measure_points$Long2[i]),
#                 bindPopup = html_text)
# #     map$circle(c(df_airq_measure_points$Lat2[i], 
# #                  df_airq_measure_points$Long2[i]))
#   }


  map$enablePopover(TRUE)
  map$fullScreen(TRUE)
  return(map)
}