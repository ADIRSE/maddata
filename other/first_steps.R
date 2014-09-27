
data_folder <- 'data'
file1 <- paste(data_folder, 'PUNTOS_MEDIDA_TRAFICO_2014_01_23.csv', sep = '/')
l_traffic_measure_points <- read.csv2(file1)
head(l_traffic_measure_points)
typeof(l_traffic_measure_points)
df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
df_traffic_measure_points
head(df_traffic_measure_points)
# lat = y
# lon = x

