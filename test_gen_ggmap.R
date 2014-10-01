

# map <- get_googlemap(coord_madrid, markers = df_sample, path = df_sample, scale = 2, size = c(640, 640))
map <- get_googlemap(coord_madrid, markers = df_sample, path = '', scale = 2, size = c(640, 640))
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


################### LEAFLET
# load example data (Fiji Earthquakes)
library(leafletR)
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


####################### RCHARTS
devtools::install_github('rCharts', 'ramnathv')
require(rCharts)
## Example 1 Facetted Scatterplot
names(iris) = gsub("\\.", "", names(iris))
rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')
## Example 2 Facetted Barplot
hair_eye = as.data.frame(HairEyeColor)
rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')

require(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
    p1 <- rPlot(input$x, input$y, data = iris, color = "Species",
                facet = "Species", type = 'point')
    p1$addParams(dom = 'myChart')
    return(p1)
  })
})

shinyUI(pageWithSidebar(
  headerPanel("rCharts: Interactive Charts from R using polychart.js"),
  sidebarPanel(
    selectInput(inputId = "x",
                label = "Choose X",
                choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                selected = "SepalLength"),
    selectInput(inputId = "y",
                label = "Choose Y",
                choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                selected = "SepalWidth")
  ),
  mainPanel(
    showOutput("myChart", "polycharts")
  )
))

map3 <- Leaflet$new()
map3$setView(c(51.505, -0.09), zoom = 13)
map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
map3$print("chart7")
map3
