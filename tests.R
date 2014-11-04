
##########
library(ggplot2)

AQdata <- read.table('/home/alonso/Documentos/madtraffic/datos/sep_mo14_mio.csv', sep=',', dec = ".", header=T)
AQdata <- read.table(paste(getwd(), '/app/data/airq/sep_mo14.csv', sep=''), sep=',', dec = ".", header=T)

PlotFun <- function(Cod, p, m){ 
  print(str(subset(AQdata, Code == Cod & Par == p & mes == m)))
  plot_data <- subset(AQdata, Code == Cod & Par == p & mes == m)
  
  p <- ggplot(data=AQdata, aes(x=as.numeric(plot_data$hora), y=plot_data$Value, group=as.numeric(plot_data$dia), color=plot_data$dia)) + geom_line() + geom_hline(yintercept=200, color='red') + xlim(1, 24)
  p <- p + xlab('Hora') + ylab('Nivel NO2 [mg/m3]') + theme(legend.position="none")
  print(p)
}

PlotFun(28079004, 1, 9)

##########
txt2Csv <- function(input_file = 'app/data/airq/sep_mo14.txt', output_file = 'app/data/airq/sep_mo14.csv') { 
  
  dataAQ <- read.fwf(file = input_file, 
                     c(8,2,2,2,2,2,2,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1,5,-1),
                     col.names=c("Code","Par","Tec","Pe","ano","mes","dia","hora1","hora2","hora3","hora4","hora5","hora6","hora7","hora8","hora9","hora10","hora11","hora12","hora13","hora14","hora15","hora16","hora17","hora18","hora19","hora20","hora21","hora22","hora23","hora24"),
                     strip.white=TRUE) 
  dataAQ2 <- data.frame(matrix(nrow = nrow(dataAQ)*24, 
                               ncol = 7))
  k=as.numeric(1)
  for (i in 1:nrow(dataAQ)) {
    for (j in 8:31) {
      dataAQ2[k,1] <- dataAQ[i, 'Code']
      dataAQ2[k,2] <- dataAQ[i, 'Par']
      #dataAQ2[k,3] <- paste(as.character(dataAQ[i, 'dia']), as.character(dataAQ[i, 'mes']), as.character(2000+dataAQ[i, 'año']), as.character(j-7))
      dataAQ2[k,3] <- dataAQ[i, 'dia']
      dataAQ2[k,4] <- dataAQ[i, 'mes']
      dataAQ2[k,5] <- 2000 + dataAQ[i, 'ano']
      dataAQ2[k,6] <- j-7
      dataAQ2[k,7] <- dataAQ[i, j]
      k <- k+1
    }
  }
  
  names(dataAQ2)=c("Code","Par","dia","mes","ano","hora","Value")
  
  write.table(dataAQ2, file = output_file, 
              sep = ",", 
              dec = ".", 
              col.names = TRUE, 
              row.names = FALSE)

}

txt2Csv()
month.name[1:5]
months_es <- c('ene','feb','mar', 'abr', 
  'may', 'jun','jul', 'ago', 'sep', 'oct','nov', 
  'dec') 

# GENERADOR DE CSVs de AIRQ DATA
for(m in months_es[1:8]){
# for(m in month.name[1:5]){
  input <- paste('app/data/airq/', 
                  m,
                  '_mo14.txt', sep = '')
  output <- paste('app/data/airq/', 
                 m,
                 '_mo14.csv', sep = '')
  print(input)
  print(output)
  txt2Csv(input, output)  
}

txt2Csv('app/data/airq/ago_mo14.txt', 'app/data/airq/ago_mo14.csv')

##########

install_github("jcheng5/leaflet-shiny")
library(leaflet)
map <- createLeafletMap("1", "myMap")
map$setView(0, 0, 8)

##########
install.packages("lib/CartoDB_1.4.tar.gz", repos=NULL, type="source")
# install_github("cartodb-r", "Vizzuality")
library(RCurl)
library(RJSONIO)
library(CartoDB)

# Setup your connection
cartodb_account_name = ""
cartodb(cartodb_account_name)

# You can quickly test that your connection works
cartodb.test()

CartoDB::map(regions="madrid", lwd=0.05, lty=1)
points(data$the_geom_x, data$the_geom_y, col="red")


##########

# OPENAIR
install.packages("openair", dep=TRUE)
library(openair)

# eng_sites <- airbaseFindCode(country = c("GB"), site.type = "traffic", city = "London")
# airbaseFindCode(site = "madrid")
# airbaseInfo(code = "ES0113A", instrument = FALSE)
# airbaseInfo(code = "ES0113A", instrument = TRUE)

madrid_aq_sites <- airbaseInfo(code = airbaseFindCode(country = c("ES"), 
                                                      city = "madrid"), 
                    instrument = FALSE)

# head(madrid_aq_sites, n = 15)
# length(madrid_aq_sites)
# str(madrid_aq_sites)
# summary(madrid_aq_sites)

# importing data
as.character(madrid_aq_sites[1,1])

importAirbase(site = "ES0113A", year = 2000:2001, pollutant = NA)
importAirbase(site = "ES0113A", year = 2000)

head(importAirbase(site = "gb0620a", year = 2012:2012, pollutant = NA,
              add = c("country", "site.type"), splice = FALSE, local = NA))

# FUNC OF AQ DATA
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

# 
# sapply(as.character(madrid_aq_sites[1:4,1]), 
#        function(x) getAirBaseData(x)
# )
# sapply(as.character(madrid_aq_sites[,1]), 
#        function(x) getAirBaseData(x)
# )

# ab_list <- importAirbase(site = "ES0115A", year = 2010:2010, pollutant = NA, add = c("country", "site.type"), splice = FALSE, local = NA)
# ab_list <- importAirbase(site = "ES0115A", year = 2014:2014, pollutant = NA, add = c("country", "site.type"), splice = FALSE, local = NA)
# write.csv2(ab_list, file = "ES0115A_2010.csv")

# download yearly data from Madrid stations
getAirBaseData("ES0115A", 2010)
getAirBaseData("ES0115A", 2012)
getAirBaseData("ES0115A", 2013)

for (i in madrid_aq_sites[,1] ) {
  sapply(seq(2012, 2014), function(x) getAirBaseData(i, x))
}




# airbaseStats(statistic = "Mean", pollutant = "no2", avg.time = "auto",
#              code = NULL, site.type = c("background", "traffic", "industrial",
#                                         "unknown"), year = 1969:2012, data.cap = 0, add = c("country", "lat",
#                                                                                             "lon", "site.type"))

# calculate monthly means
means <- aggregate(mydata["nox"], format(mydata["date"],"%Y-%m"),
                   mean, na.rm = TRUE)
# derive the proper sequence of dates
means$date <- seq(min(mydata$date), max(mydata$date), length = nrow(means))
# plot the means
plot(means$date, means[, "nox"], type = "l")

plot(as.factor(format(mydata$date, "%Y-%m")), mydata$no2, col = "lightpink")
polarPlot(mydata, cols = "jet")
# Sys.setenv(TZ = "Etc/GMT-1")


# load openair data if not loaded already
data(mydata)
str(mydata)
mydata[1:200,]
# basic use, single pollutant
scatterPlot(mydata[1:200,], x = "nox", y = "no2")
# scatterPlot by year
scatterPlot(mydata[1:200,], x = "nox", y = "no2", type = "year")
# scatterPlot by day of the week, removing key at bottom
scatterPlot(mydata[1:200,], x = "nox", y = "no2", type = "weekday", key =
              FALSE)

# example of the use of continuous where colour is used to show
# different levels of a third (numeric) variable
# plot daily averages and choose a filled plot symbol (pch = 16)
# select only 2004
## Not run: dat2004 <- selectByDate(mydata, year = 2004)
scatterPlot(dat2004, x = "nox", y = "no2", z = "co", avg.time = "day", pch = 16)
## End(Not run)
# show linear fit, by year
## Not run: scatterPlot(mydata, x = "nox", y = "no2", type = "year", smooth =
# FALSE, linear = TRUE)
## End(Not run)
# do the same, but for daily means...
## Not run: scatterPlot(mydata, x = "nox", y = "no2", type = "year", smooth =
# FALSE, linear = TRUE, avg.time = "day")
## End(Not run)
# log scales
## Not run: scatterPlot(mydata, x = "nox", y = "no2", type = "year", smooth =
# FALSE, linear = TRUE, avg.time = "day", log.x = TRUE, log.y = TRUE)
## End(Not run)

##########
##########
# OpenStreetMapR
library(devtools)
install_github('greentheo/OpenStreetMapR')
library("OpenStreetMapR")

df = data.frame(lat=runif(10, 38,40), long=-runif(10, 104,106), 
                size=runif(10)*20, color=sample(rainbow(3), 10, replace=TRUE),
                line=sample(1:3, 10,replace=TRUE))
OSMMap(df)
OSMMap(df, size='size', color='color')
plot(OSMMap(df))

dualMap = (addLayers(OSMMap(df, size='size', color='color'),
                     linePlot))
plot(dualMap)
<!--begin.rcode results='asis'
(print(OSMMap(df, size='size', color='color')))
end.rcode-->
  
##########
# BOA
library(RCurl)
library(jsonlite)
# require(downloader)

getData <- function(url){
  temp <- getURL(URLencode(url), ssl.verifypeer = FALSE)
  data <- fromJSON(temp, simplifyVector=FALSE)  
}

url <- 'http://datune.maddata.es:9090/BigOpenApi/probarRecurso?dsTabla=md_trafico_madrid'

file = '/app/data/md_trafico_madrid_tr.json'


# download(url=url, destfile = file)
# if (file.exists(kml_file)) {
#   download(url=url, destfile = file)
# }

# DOWNLOAD

# url <- paste0("https://www.googleapis.com/freebase/v1/search?",
#                   "filter=", paste0("(all alias{full}:", "\"", "Airbag", "\"", " type:\"/film/film\")"),
#                   "&indent=TRUE",
#                   "&limit=1",
#                   "&output=(/film/film/genre)")


data$DatosConsultados
data$NumResult
data$Error
data$Result
head(data$Result)
typeof(data)
data$Result[0]
data$Result[1]
data$Result[100]
data$Result[as.numeric(data$NumResult)]

data$Result[c(2,4)]
head(data$Result[[100]])
typeof(data$Result[[100]])
data$Result[[100]][1]
head(data$Result[[100]][1])
head(data$Result[[100]][5])
data$Result[[100]]['ocupacion']
data$Result[[100]]['identif']
data$Result[[100]]['vmed']
data$Result[[100]]['carga']
data$Result[[100]]['error']
data$Result[[100]]['periodo_integracion']
data$Result[[100]]['fecha']

as.numeric(data$Result[[100]]['vmed'][1])

url <- 'http://datune.maddata.es:9090/BigOpenApi/filtrarResultados?dsTabla=md_trafico_madrid&dsCampo=identif&regex=PM10005'
# 'comprimir=true'
data <- getData(url)

# DO SOMETHING

##########
# RIMPALA

# install everis custom RImpala
package_path <- paste(getwd(), '/lib/impala/rimpala0.1.3.tar.gz', sep='')
install.packages(package_path, repos = NULL, type="source")

# loads
require(rJava)
library(RImpala)

# connect
rimpala.init(libs ="lib/impala/impala-jdbc-0.5-2/")
rimpala.connect("54.171.4.239", port = "21050", principal = "user=guest;password=maddata")
rimpala.usedatabase("bod_pro")


# //DROP SI YA EXISTE
# rimpala.query("DROP TABLE [nombre_tabla]")

rimpala.showdatabases()
rimpala.showtables()
rimpala.describe("md_trafico_madrid") #Describes la tabla de trafico
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = 'PM20742' LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE fecha = '2014-08-20 01:00:00' LIMIT 100")

prueba <- rimpala.query("SELECT DISTINCT identif FROM md_trafico_madrid LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"PM20742\" ORDER BY fecha LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"PM3856\" ORDER BY fecha LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"PM20742\" ORDER BY fecha LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"PM20742\" AND fecha > \"2012-12-31\" AND fecha < \"2013-01-03\" ORDER BY fecha")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"PM20742\" AND fecha >= \"2013-12-31\" AND fecha < \"2014-01-03\" ORDER BY fecha")

prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"41054\" AND fecha > \"2012-12-31\" ORDER BY fecha LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"41054\" AND fecha > \"2012-12-17\" ORDER BY fecha LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = \"41054\" AND fecha > \"2014-06-20\" ORDER BY fecha LIMIT 100")


prueba <- rimpala.query("SELECT intensidad, fecha FROM md_trafico_madrid WHERE  identif = \"PM20742\" AND fecha > \"2014-06-20\" and fecha < \"2014-06-30\" order by fecha")
prueba <- rimpala.query("SELECT sum(intensidad) FROM md_trafico_madrid WHERE fecha > \"2014-06-20\" and fecha < \"2014-06-23\" ")
prueba <- rimpala.query("SELECT identif, sum(intensidad) as suma FROM md_trafico_madrid WHERE fecha > \"2014-06-20\" and fecha < \"2014-06-23\" group by identif order by suma desc")

# one day
prueba <- rimpala.query("SELECT identif, sum(vmed) as vmed, sum(intensidad) as intensidad FROM md_trafico_madrid WHERE fecha > \"2014-06-20\" and fecha < \"2014-06-23\" group by identif order by intensidad desc")

# one month
prueba <- rimpala.query("SELECT identif, sum(vmed) as vmed, sum(intensidad) as intensidad FROM md_trafico_madrid WHERE fecha > \"2014-06-20\" and fecha < \"2014-06-23\" group by identif order by intensidad desc")

# 3846 3847 3848 3849 3850 3851 3852 3853 3854 3855 3856
rimpala.close() #cierras la conexion

rimpala.query("select * from information_schema")
rimpala.query("select * from information_schema.tables")

rimpala.query("SELECT [columna] FROM [nombre_tabla] WHERE [columna] [operador] [condición]")

##########
library(leafletR)

# load example data (Fiji Earthquakes)
data(quakes)

# store data in GeoJSON file (just a subset here)
q.dat <- toGeoJSON(data=quakes[1:99,], dest=tempdir(), name="quakes")

# make style based on quake magnitude
q.style <- styleGrad(prop="mag", breaks=seq(4, 6.5, by=0.5), 
                     style.val=rev(heat.colors(5)), leg="Richter Magnitude", 
                     fill.alpha=0.7, rad=8)

# create map
q.map <- leaflet(data=q.dat, dest=tempdir(), title="Fiji Earthquakes", 
                 base.map="mqsat", style=q.style, popup="mag")

# view map in browser
q.map

##########
library(WDI)
library(rCharts)
library(plyr)

countries <- c("AL", "AT", "BE", "BA", "BG", "HR", "CZ", "DK", "FI", "FR", "DE", "GR", 
               "HU", "IS", "IE", "IT", "NL", "NO", "PL", "PT", "RO", "RS", "SK", "SI", 
               "ES", "SE", "CH", "GB")

tfr <- WDI(country = countries, indicator = "SP.DYN.TFRT.IN", start = 1960, end = 2011)

#Clean up the data a bit
tfr <- rename(tfr, replace = c("SP.DYN.TFRT.IN" = "TFR"))

tfr$TFR <- round(tfr$TFR, 2)

# Create the chart
tfrPlot <- nPlot(
  TFR ~ year, 
  data = tfr, 
  group = "country",
  type = "lineChart")

# Add axis labels and format the tooltip
tfrPlot$yAxis(axisLabel = "Total fertility rate", width = 62)

tfrPlot$xAxis(axisLabel = "Year")

tfrPlot$chart(tooltipContent = "#! function(key, x, y){
        return '<h3>' + key + '</h3>' + 
        '<p>' + y + ' in ' + x + '</p>'
        } !#")

tfrPlot

#############

names(iris) = gsub("\\.", "", names(iris))
p1 <- rPlot('SepalWidth', 'SepalLength', data = iris, color = "Species", 
            facet = "Species", type = 'point')
p1$addParams(dom = 'myChart')
p1

