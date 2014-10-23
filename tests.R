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

//DROP SI YA EXISTE
rimpala.query("DROP TABLE [nombre_tabla]")

rimpala.showdatabases()
rimpala.showtables()
rimpala.describe("md_trafico_madrid") #Describes la tabla de trafico
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid LIMIT 100")
prueba <- rimpala.query("SELECT * FROM md_trafico_madrid WHERE identif = 'PM20742' LIMIT 100")
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

