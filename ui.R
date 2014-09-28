require(rCharts)
options(RCHART_LIB = 'polycharts')
library(shiny)

# Define UI for application that draws a histogram
shinyUI(page(
  
  # Application title
  headerPanel("MAD traffic!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarPanel(""),
  mainPanel( 
      plotOutput("madrid_static_Plot")
#       plotOutput("googleMapPlotMeuse")
#       uiOutput("googleMapPlotMeuse")
#       htmlOutput("googleMapPlotMeuse")
#       uiOutput('googleMapPlot')
  )
#   tabsetPanel(
#              tabPanel("Tráfico en Tiempo Real", plotOutput("map")),
#              tabPanel("Zonas más atascadas", plotOutput("map"))
#              #         tabPanel("Summary", verbatimTextOutput("summary")),
#              #         tabPanel("Table", tableOutput("table"))
#     )
))