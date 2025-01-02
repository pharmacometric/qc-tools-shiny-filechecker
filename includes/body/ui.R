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
# assemble right contents
body.panel.right = primePanel(
  width = 12,
  body.panel.right.compare,
  body.panel.right.codecheck
)

body.main = moveable(
  body.model.info, # model infor panel
  body.panel.left, # directory selector
  body.panel.right # sims output panel # ui.part3.R
)
