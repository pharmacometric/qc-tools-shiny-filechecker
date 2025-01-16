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
libs = c("shiny","shinyjs","imager","officer","markdown","tibble","card.pro","dplyr","magrittr","pdftools","quickcode","tools","grid","shinyStorePlus","diffr")
lapply(libs, function(l)library(l,character.only=1L))

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
GLOBAL$selectedfilesInput = c()
GLOBAL$selectedCheckFiles = list()
GLOBAL$selectedCheckFilesProcess = FALSE


GLOBAL$storageDir = tempdir()

