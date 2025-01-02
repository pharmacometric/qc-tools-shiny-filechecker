############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/conc.vs.time/ui.R
##
##  Description: User interface for code QC
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################
print("conctime working...")
# for(u in indexed(libs))message(u$key,"-",u$val)
# for exporting code
GLOBAL$code.convtm.tpl <- paste0(this.path, "/code.tpl")
GLOBAL$code.convtm.libs.glue <- paste0('c("', paste(libs[c(10, 11, 12, 20, 19)], collapse = '","'), '")')


# plot panels
body.panel.right.codecheck <- card.pro(
  title = "Code Checks",
  icon = icon("code"),
  collapsed = 1L,
  header.bg = "blue",
  xtra.header.content = textOutput("reportcodechck"),
  div(
    id = "reportchecks2",
    tags$blockquote(style = "color:blue", "Code QC'er")
  ),
  column(width = 6, class = "p-0", selectInput("datatoUseconc1", "File to use:", choices = c())),
  column(
    width = 6, class = "p-0",
    conditionalPanel(
      condition = "input.cgraphtype == 7 | input.cgraphtype == 8", numericInput("pagetoshowc1", "Page to show", value = 1)
    )
  ),


  sidebar = div(),
  footer = list(
    downloadButton("cdownloadcodec1", "Download code check report (R)", icon = icon("code"), class = "downloadbtns")
  )
)
