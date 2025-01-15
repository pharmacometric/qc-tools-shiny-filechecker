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

# sims setup panel
body.panel.paths = card.pro(
  title = "File selector",
  removebtn = 0L,
  colorbtn = 0L,
  expandbtn = 0L,
  editbtn = 0L,
  collapsed = 1L,
  icon = icon("folder-open"),
  header.bg = "greenLight",
  tags$blockquote("Select directory and files to compare"),

  radioButtons(
    "checkGroupDatasetT",
    "Type of directory",
    choices = list(
      "User uploaded directory" = 2,
      "Local file directory" = 1
    ),
    selected = 1
  ),
  conditionalPanel(
    condition = "input.checkGroupDatasetT == 2",
    column(
      width = 6,
      fileInput(
        "ufileupd1a",
        "Upload zipped Original directory (.zip or .tgz)",
        accept = c(".zip",".tgz",".tar.gz"),
        width = "100%"
      ),
      textInput("ufileupd1apath", "Uploaded Original files directory path", width = "100%"),
      shwhdbtn("ufileupd1afiles"),
      div(id = "ufileupd1afiles", class = "hidethis")
    ),
    column(
      width = 6,
      fileInput("ufileupd1b",
                "Upload zipped QC directory (.zip or .tgz)",
                accept = c(".zip",".tgz",".tar.gz"),
                width = "100%"),
      textInput("ufileupd1bpath", "Uploaded QC files directory path", width = "100%"),
      shwhdbtn("ufileupd1bfiles"),
      div(id = "ufileupd1bfiles", class = "hidethis")
    )
  ),
  conditionalPanel(
    condition = "input.checkGroupDatasetT == 1",
    # Taken from: https://github.com/ronkeizer/nonmem_examples
    column(
      width = 6,
      textInput(
        "dirfiletype1a",
        "Local Original files directory path",
        "www/example/Original",
        width = "100%"
      ),
      shwhdbtn("dirfiletype1afiles"),
      div(id = "dirfiletype1afiles", class = "hidethis")
    ),
    column(
      width = 6,
      textInput(
        "dirfiletype1b",
        "Local QC files directory path",
        "www/example/QC",
        width = "100%"
      ),
      shwhdbtn("dirfiletype1bfiles"),
      div(id = "dirfiletype1bfiles", class = "hidethis")
    ),
  ),
  footer = textOutput("trackfileupdates")
)


