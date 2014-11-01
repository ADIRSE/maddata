library(ggmap) 
library(ggplot2)
library(RColorBrewer)


getAQData <- function() {
  input_file <- paste(getwd(), '/data/AQ_SEP2014_28079004.csv', sep='')
  print(input_file)
  AQdata <- read.csv(input_file, sep=',', dec = ".", header=T)
  print(head(AQdata))
  # remove week days name because of locale
  AQdata$Fecha <- strptime(substr(AQdata$Datum, 5, length(AQdata$Datum)), "%d-%m %H")
  AQdata$hora <- strftime(AQdata$Fecha, "%H")
  AQdata

}



getDensityMap <- function() {
    
  input_file_1 <- paste(getwd(), '/data/Traffic_Madrid4.csv', sep='')
  input_file_2 <- paste(getwd(), '/data/Est_AirQ_Madrid2.csv', sep='')
  print(input_file_1)
  print(input_file_2)
  data <- read.csv(file=input_file_1, header=T, stringsAsFactors=F)
  data2 <- read.csv(file=input_file_2, header=T, stringsAsFactors=F)
  madrid <- get_map(location=c(lon=median(data$Long), lat=median(data$Lat)), zoom=12, maptype='roadmap', color='bw')
  
  print(head(data))
  print(head(data2))
#   print(madrid)
  
  data$Medida <- "trafico"
  data2$Medida <- "AirQ"
  df <- merge(data, data2, all=TRUE)
  YlOrBr <- c("#FFFFD4", "#FED98E", "#FE9929", "#D95F0E", "#993404")

  print(head(df))

  traf.map <- ggmap(madrid) %+% df +
    aes(x = Long,
        y = Lat, 
        z = intensidad) + 
    stat_summary2d(fun = sum, bins=100,alpha=0.5) + 
    scale_fill_gradientn(name = "veh/h",
                         colours = YlOrBr,
                         space = "Lab") +
    coord_map() + geom_point(color='black', size = 1)
  
  traf.map <- traf.map + geom_point(data = subset(df, Medida == 'AirQ'), color='red', size = 2)
   
  # print(head(traf.map))

  traf.map
}