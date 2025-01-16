############################################################################
############################################################################
##  Document Path: includes/header/ui.R
##
##  Description: Header section for the app
##
##  Date: 2025-01-16
##
##  R Version: R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################
titleapp <- "QC toolset: script and output checker"
header.main <- titlePanel(tags$div(
  tags$img(src = "logo0.jpg"), " ",
  titleapp,
  tags$div(
    class = "hidden-mobile hidden-tablet pull-right",
    actionButton("aboutproject", "", icon = icon("question"))
  )
), windowTitle = titleapp)
