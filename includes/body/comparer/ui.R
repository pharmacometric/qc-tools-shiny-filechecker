############################################################################
############################################################################
##  Document Path: includes/body/comparer/ui.R
##
##  Description: User interface for file compare
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# plot panels
body.panel.compare <- card.pro(
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

  # for comparison metrics
  div(id = "fcomparisonmetricsa"),

  # for actual file comparison
  column(
    width = 12,
    style = "padding:0px",
    tags$strong("File content comparison"),

    # for images
    div(id = "diffrfilesimg"),

    # for documents
    diffrOutput("diffrfiles", width = "100%", height = "500px")
  )
)
