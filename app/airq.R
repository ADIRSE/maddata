library(ggmap) 
library(ggplot2)
library(RColorBrewer)
library(openair)

# FUNC THAT IMPORTS OPENAIR AQ DATA
getAirBaseData <- function (station, year) {  
  ab_data <- importAirbase(site = station, year = year:year, pollutant = NA, add = c("country", "site.type"), splice = FALSE, local = NA)
  csv_filename <- paste('app/data/airq/openair/',
                        station, 
                        '_', 
                        as.character(year), 
                        '.csv', 
                        sep = '')
  write.csv2(ab_data, file = csv_filename)
}

# function that parses .txt to a data frame
getDFFromFile <- function(text) {
  
  df <- data.frame()
  
  for (row in text[1:3]) {
    cod_station <- substr(row, 1, 8)
    cod_params <- substr(row, 8, 9)
    cod_tec_anal <- substr(row, 10, 11)
    cod_period <- substr(row, 12, 13)
    cod_year <- substr(row, 14, 15)
    cod_month <- substr(row, 15, 16)
    cod_day <- substr(row, 17, 18)
    cod_hour <- substr(row, 19, 20)

    substr(row, 1, 20)
    
    ini_pos <- 21
    for (h in 0:24) {
      print(substr(row, ini_pos + h*6, ini_pos + h*6 + 4))
      #     add all hours data to df
    }
    
    #     add all rows data to df
  }
  
  df
}


# function that returns AQ data given a month and year
getAytoAQData <- function(month, year) {
  month <- 'may'
  year <- 14
  input_file <- paste(getwd(), '/app/data/airq/', month, '_mo', as.character(year), '.txt', sep='')
  text <- readLines(input_file)
  head(text)
  typeof(text)
  length(text)
  text[100]
  
  df <- getDFFromFile(text)
  
  df
}
  

# devuelve los datos mensuales por horas
# getAQData <- function(fecha=mes) {
# añadir + contaminantes
getAQData <- function() {
  input_file <- paste(getwd(), '/data/AQ_SEP2014_28079004.csv', sep='')
  AQdata <- read.csv(input_file, sep=',', dec = ".", header=T)

  # remove week days name because of locale
  AQdata$Fecha <- strptime(substr(AQdata$Datum, 5, length(AQdata$Datum)), "%d-%m %H")
  AQdata$hora <- strftime(AQdata$Fecha, "%H")

  AQdata

}

GetLocale <- function() {
  Sys.getlocale()
}


SetLocale <- function(loc) {
#   Sys.setlocale("LC_TIME", "English")  
  Sys.setlocale(loc)
}
getAQPlot <- function(aq_data) {
  
  plot <- ggplot(aq_data, aes(x=hora, y=NO2)) + 
  geom_point() + 
  geom_hline(yintercept=200, 
             color='red')
  
  plot
} 

# getDensityMap <- function(fecha) {
getDensityMap <- function() {
    
  input_file_1 <- paste(getwd(), '/data/Traffic_Madrid4.csv', sep='')
  #   <--- sustituir por los datos de RImpala
  # pinta la densidad de trafico
  
  input_file_2 <- paste(getwd(), '/data/Est_AirQ_Madrid2.csv', sep='')
  # <-- pinta localizacion de estaciones de AIRQ
  # no pinta la contaminacion
  
  data <- read.csv(file=input_file_1, header=T, stringsAsFactors=F)
  data2 <- read.csv(file=input_file_2, header=T, stringsAsFactors=F)
  madrid <- get_map(location=c(lon=median(data$Long), lat=median(data$Lat)), 
                    zoom=12, 
                    maptype='roadmap', 
                    color='bw')
  
#   print(head(data))
#   print(head(data2))
#   print(madrid)
  
  data$Medida <- "trafico"
  data2$Medida <- "AirQ"
  df <- merge(data, data2, all=TRUE)
  YlOrBr <- c("#FFFFD4", "#FED98E", "#FE9929", "#D95F0E", "#993404")

#   print(head(df))

  traf.map <- ggmap(madrid) %+% df +
    aes(x = Long,
        y = Lat, 
        z = intensidad) + 
    stat_summary2d(fun = sum, bins=100,alpha=0.5) + 
    scale_fill_gradientn(name = "veh/h",
                         colours = YlOrBr,
                         space = "Lab") +
    coord_map() + geom_point(color='black', size = 1)
  
  traf.map <- traf.map + 
              geom_point(data = subset(df, Medida == 'AirQ'), 
                         color='red', 
                         size = 2)
  
  traf.map

}