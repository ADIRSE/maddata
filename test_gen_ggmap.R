library(ggplot2)
library(ggmap)

data_folder <- 'data'
file1 <- paste(data_folder, 'PUNTOS_MEDIDA_TRAFICO_2014_01_23_FIXED.csv', sep = '/')
l_traffic_measure_points <- read.csv2(file1)
# l_traffic_measure_points <- read.csv2(file1, colClasses=c("Lat"="numeric", "Long"="numeric"))
df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
# FALLA PORQUE HAY DEMASIADOS DECIMALES!!!
df_sample <- df_traffic_measure_points[1:50, c("Long", "Lat")]
df_sample$Long <- as.numeric(as.character(df_sample$Long))
df_sample$Lat <- as.numeric(as.character(df_sample$Lat))
df_sample <- round(df_sample, digits = 2)

map <- get_googlemap(coord_madrid, markers = df_sample, path = df_sample, scale = 2, size = c(640, 640))
ggmap(map, extent = 'device')

##########################

#   coordinates(df_traffic_measure_points) = ~x+y
typeof(df_traffic_measure_points) # return list
coordinates(df_traffic_measure_points) = ~Lat+Lon
proj4string(df_traffic_measure_points) <- CRS("+init=epsg:3042")
typeof(df_traffic_measure_points) # return S4
s4_sample <- df_traffic_measure_points[1:50,]


# 40.416947,-3.703528
coord_madrid <- c(lon = -3.703528, lat = 40.416947)
madrid = get_map(location = coord_madrid, zoom = 12, maptype = 'roadmap')
madrid_map <- ggmap(madrid)
madrid_map <- madrid_map + 
              geom_point(data=df_sample, aes(x=Lat, y=Lon), size=5)

