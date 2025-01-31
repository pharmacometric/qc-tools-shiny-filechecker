############################################################################
############################################################################
##  Document Path: includes/body/ui.R
##
##  Description: User interface for main body section
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################
body.body.manual = card.pro(
  title = "Guide for using the QC file checker", width = 12,
  header.bg = "darken",
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = FALSE,
  collapsed = 1L,
  shadow = FALSE,
  shiny::includeMarkdown(file.path(this.path, "model_information.md"))
)
