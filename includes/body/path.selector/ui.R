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
body.panel.left.setup = card.pro(
  title = "File selector",
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = FALSE,
  tags$blockquote("Select directory and files to compare"),

  radioButtons(
    "checkGroupDatasetT",
    "Type of directory",
    choices = list("User uploaded directory" = 2, "Local file directory" = 1),
    selected = 1
  ),
  conditionalPanel(
    condition = "input.checkGroupDatasetT == 2",
    column(width = 6,fileInput("ufileupd1a","Upload zipped Original directory (.zip or .tgz)",width = "100%"),
           div(id="ufileupd1afiles")),
    column(width = 6,fileInput("ufileupd1b","Upload zipped QC directory (.zip or .tgz)",width = "100%"),
           div(id="ufileupd1bfiles"))
  ),
  conditionalPanel(
    condition = "input.checkGroupDatasetT == 1",
    # Taken from: https://github.com/ronkeizer/nonmem_examples
    column(width = 6,
    textInput("dirfiletype1a", "Local Original files directory path","www/example/Original",width = "100%"),
    div(id="dirfiletype1afiles")),
    column(width = 6,
    textInput("dirfiletype1b", "Local QC files directory path","www/example/QC",width = "100%"),
    div(id="dirfiletype1bfiles")),
  ),
  hr(),
  "56 Files were found to have the same file names between the two paths",
  footer = textOutput("trackfileupdates")
)




body.panel.left.stats = div(
  # class="padding-15",
  # initStore("all",rpkg.api.key = "f0d7a266f47a8ab4f8fc5d537d9f2d1cd33f8a2c4d2d2421e82b1ade1a974086"),
  # viewsBox("tmpviewstats","loading views..."),br(),br(),
  # lfButton("likebtn1",suffix="likes"),
  # lfButton("followbtnt",suffix="followers")
)


# assemble left panel
body.panel.left = primePanel(
  width = 12,
  body.panel.left.setup,
  body.panel.left.stats
)

