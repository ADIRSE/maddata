require(shiny)
require(RJSONIO)
require(rCharts)
require(RColorBrewer)
require(httr)
library(ggplot2)
library(ggmap)
require(downloader)
library(RCurl)
require(rJava)
library(RImpala)
library(openair)
require(lubridate)                                                                                                                          
# library(OpenStreetMapR)
# source("some_charts.R")

source("global_functions.R")
source("airq.R")

connectImpala()

#######################
# GLOBAL SETTINGS
#######################

num_decimals <- 3
# load traffic measure  points
input_file <- paste(getwd(), '/data/PUNTOS_MEDIDA_TRAFICO_2014_01_23_FIXED.csv', sep='')
l_traffic_measure_points <- read.csv2(input_file)
df_traffic_measure_points <- as.data.frame(l_traffic_measure_points)
df_traffic_measure_points$Long <- as.numeric(as.character(df_traffic_measure_points$Long))
df_traffic_measure_points$Lat <- as.numeric(as.character(df_traffic_measure_points$Lat))
df_traffic_measure_points$Long <- round(df_traffic_measure_points$Long, digits = num_decimals)
df_traffic_measure_points$Lat <- round(df_traffic_measure_points$Lat, digits = num_decimals)

names(df_traffic_measure_points)
names(df_traffic_measure_points) <- c('id', 'tipo', 'code', 'name', 'x', 'y', 'long', 'lat')

# get traffic names
# traffic_points_choices <- getTrafficPointsChoicesImpala()[[1]]
traffic_points_choices  <- sort(df_traffic_measure_points$name, decreasing = FALSE)
# remove_choices <- c(as.vector(traffic_points_choices[grepl("^04", traffic_points_choices)]),
#                     as.vector(traffic_points_choices[grepl("^03", traffic_points_choices)])
#                   )
# 
# length(as.vector(all_traffic_points_choices[grepl("^04", all_traffic_points_choices)]))
# traffic_points_choices <- setdiff(all_traffic_points_choices, remove_choices)

l_airq_measure_points <- read.csv2('data/est_airq_madrid.csv')
df_airq_measure_points <- as.data.frame(l_airq_measure_points)
df_airq_measure_points$Long2 <- as.numeric(as.character(df_airq_measure_points$Long2))
df_airq_measure_points$Lat2 <- as.numeric(as.character(df_airq_measure_points$Lat2))
df_airq_measure_points$Long2 <- round(df_airq_measure_points$Long2, digits = num_decimals)
df_airq_measure_points$Lat2 <- round(df_airq_measure_points$Lat2, digits = num_decimals)

# fix air station codes
df_airq_measure_points$Id <- sapply(df_airq_measure_points$Id, function(x) fixStationCodes(x))

# get air quality station names
# traffic_points_choices <- getTrafficPointsChoicesImpala()[[1]]
airq_measure_choices  <- sort(df_airq_measure_points$Estacion, decreasing = FALSE)

# madrid_aq_sites <- airbaseInfo(code = airbaseFindCode(country = c("ES"), 
#                                                       city = "madrid"), 
#                                instrument = FALSE)

pollutants <- read.csv(paste(getwd(), '/data/pollutants.csv', sep=''), sep=',', dec = ".", header=T)

input_data_file <- paste(getwd(), '/data/airq/', 'airq_ano_14.csv', sep='') # fichero anual
airq_data_2014 <- read.table(input_data_file, sep=',', dec = ".", header=T)
