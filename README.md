shiny_maddata
=============

R Shiny project


### Introduction
Maddata is the repository for our MADtraffic shiny app, that we developed for the MADdata contest organized by the local council of Madrid in October 2014.

MADtraffic is a shiny app that pretends to explore and analyze traffic and pollution data, independently and together. We want to provide an app that easily shows which streets are the most traffic loaded, and when, their traffic trends, and in a similar way with pollution. With this two datasets, the final purpose is to match them and try to find correlations between them.

### Requirements

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
require(lubridate)
library(openair)


### Installation notes
You will need to install the following external packages:
install.packages('devtools'); 
require(devtools)
install_github('ramnathv/rCharts')
install.packages("openair", dep=TRUE)
install.packages("lubridate")
install.packages("markdown")



* install.packages("openair", dep=TRUE)
* install.packages("openair", dep=TRUE)

### Developed by
Miguel Fiandor Gutiérrez
Jose Luis Alonso

### About us
Both developers belong to ADIRSE, a renewable energy and environmental care association created from the Polythecnic University master studies in the same field, ERMA.
ADIRSE: htpp://www.adirse.org
ERMA:


