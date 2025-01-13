############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/conc.vs.time/ui.R
##
##  Description: User interface for file compare
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# for(u in indexed(libs))message(u$key,"-",u$val)
# for exporting code
GLOBAL$code.convtm.tpl <- paste0(this.path, "/code.tpl")
GLOBAL$code.convtm.libs.glue <- paste0('c("', paste(libs[c(10, 11, 12, 20, 19)], collapse = '","'), '")')


# plot panels
body.panel.right.compare <- card.pro(
  title = "File compare",
  icon = icon("book-open"),
  collapsed = 0L,
  togglebtn = 0L,
  editbtn = 0L,
  expandbtn = 1L,
  colorbtn = 0L,
  removebtn = 0L,
  sortable = 1L,
  header.bg = "blueLight",
  div(id = "filecomparemessage"),
  column(
    width = 6,
    class = "p-0",
    selectInput(
      "codecfile1",
      "Original file:",
      choices = c(),
      width = "98%"
    )
  ),
  column(
    width = 6,
    class = "p-0",
    selectInput(
      "codecfile2",
      "QC file:",
      choices = c(),
      width = "98%"
    )
  ),
  div(id = "fcomparisonmetricsa"),
  # diff files
  column(
    width = 12,
    style = "padding:0px",
    tags$strong("File content comparison"),
    div(id = "diffrfilesimg"),
    diffrOutput("diffrfiles", width = "100%", height = "600px")
  ),


  sidebar = div(
    tags$label("Graph settings"),
    selectInput(
      "fcwordWrap",
      "Word wrap",
      choices = c("True" = 1, "False" = 0),
      width = "90%"
    ),
    # textInput("fcwidth", "Width of diff", "100%", width = "95%"),
    # textInput("fcheight", "Height of dif", "500", width = "95%"),
    textInput("fcminjs", "Minimum jump size", "5000", width = "95%"),
    textInput("fccons", "Minimum context size", "3", width = "95%"),


    selectInput(
      "loglinear",
      "semi-log or linear",
      choices = c("linear", "semi-log"),
      width = "90%"
    ),
    textInput("labely", "Y-label", "Concentration (ug/ml)", width = "95%"),
    textInput(
      "labelx",
      "X-label (TSFD tab)",
      "Time after first dose (hrs)",
      width = "95%"
    ),
    textInput(
      "labelx2",
      "X-label (TSLD tab)",
      "Time after last dose (hrs)",
      width = "95%"
    ),
    selectInput(
      "legendposition",
      "Legend position",
      choices = c("bottom", "top", "left", "right", "none"),
      width = "90%"
    ),
    numericInput(
      "ncollegend",
      "Number of legend columns",
      value = 5,
      width = "90%"
    ),
    selectInput(
      "graphfont",
      "Font type",
      choices = "sans",
      selected = "Arial",
      width = "90%"
    ),
    sliderInput(
      "fontxytitle",
      "Font-size text",
      min = 1,
      max = 50,
      value = 12
    ),
    sliderInput(
      "fontxyticks",
      "Font-size ticks",
      min = 1,
      max = 50,
      value = 12
    ),
    sliderInput(
      "fontxystrip",
      "Font-size strip",
      min = 1,
      max = 50,
      value = 12
    ),
    "For downloads:",
    numericInput("downimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("downimgw", "Image width (px)", 2500, width = "90%"),
    numericInput("downimgh", "Image height (px)", 1700, width = "90%"),
    numericInput("downimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton(
      "concvtimedownloadimg",
      "Download plot",
      icon = icon("image"),
      class = "downloadbtns"
    )
  ),
  footer = list(
    downloadButton(
      "concvtimedownloadimg",
      "Download plot file (png)",
      icon = icon("image")
    ),
    downloadButton(
      "concvtimedownloadimg2",
      "Download plot object (ggplot)",
      icon = icon("image"),
      class = "downloadbtns2"
    ),
    downloadButton(
      "cdownloadconcvt2",
      "Download plot code (R)",
      icon = icon("code"),
      class = "downloadbtns"
    )
  )
)
