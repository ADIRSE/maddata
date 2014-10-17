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

