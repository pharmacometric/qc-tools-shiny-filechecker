#########################################################################################
#########################################################################################
##
##  Document Path: global.R
##
##  R version: 4.2.0 (2022-04-22)
##
##  Program purpose: Global library loads, prep environment and load libs
##
#########################################################################################
#########################################################################################



# clear console, set dir, load libs and load files
quickcode::clean(source = c("utils.R"), clearPkgs = 1L)

# load libraries
libs = c("shiny","shinyjs","magick","DT","flextable","officer","markdown","tibble","card.pro","dplyr","ggplot2","magrittr","pdftools","quickcode","patchwork","table1","r2resize","rlang","grid","ggthemes","PerformanceAnalytics","GGally","ggforce","shinyStorePlus","diffr")
#lapply(libs, function(l)library(l,character.only=1L))
library(shiny)
library(shinyjs)
library(magick)
library(DT)
library(flextable)
library(officer)
library(markdown)
library(tibble)
library(card.pro)
library(dplyr)
library(ggplot2)
library(magrittr)
library(pdftools)
library(quickcode)
library(patchwork)
library(table1)
library(r2resize)
library(rlang)
library(grid)
library(ggthemes)
library(PerformanceAnalytics)
library(GGally)
library(ggforce)
library(shinyStorePlus)
library(diffr)
# add all individual utils
for (ui_each in c(
  "includes/header",
  "includes/body",
  "includes/footer"
)) {
  this.path = ui_each
  source(file.path(ui_each,"libs.R"), local = T)
}


# declare the global reactive and regular values
GLOBAL= reactiveValues()
GLOBAL$files = list()
GLOBAL$selectedCheckFiles <- list()
GLOBAL$selectedCheckFilesProcess <- FALSE
