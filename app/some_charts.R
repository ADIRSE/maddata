library(WDI)
library(rCharts)
library(plyr)

getSeriesChart <- function () {
  data(economics, package = 'ggplot2')
  typeof(economics)
  head(economics)
  econ <- transform(economics, date = as.character(date))
  str(economics)
  str(econ)
  #   typeof(econ)
  m1 <- mPlot(x = 'date', y = c('psavert', 'uempmed'), type = 'Line',
              data = econ)
  m1$set(pointSize = 0, lineWidth = 1)
  m1

}

#   url <- 'http://datune.maddata.es:9090/BigOpenApi/probarRecurso?dsTabla=md_trafico_madrid'
#   data <- getBOAData(url)
#   data <- as.data.frame(data$Result)
#   typeof(data)
#   head(data)
#   str(data)
#   str(data$Result)
#   str(y)
#   data[1]
#   parsedData <- transform(data, date = as.character(fecha))
#   head(parsedData, n = 2)


getNVD3test <- function () {
    hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
    n1 <- nPlot(Freq ~ Hair, group = "Eye", data = hair_eye_male, type = 'multiBarChart')
    n1
}

getScatterChart <- function (input){
names(iris) = gsub("\\.", "", names(iris))
  p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
              facet = "Species", type = 'point')
  p1$addParams(dom = 'myChart')
  p1
}

getRPlott <- function () {
  

}

getxChart <- function () {
  require(reshape2)
  uspexp <- melt(USPersonalExpenditure)
  names(uspexp)[1:2] = c('category', 'year')
  x1 <- xPlot(value ~ year, group = 'category', data = uspexp, 
              type = 'line-dotted')
  x1

}


getNVD3 <- function () {
  
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
}