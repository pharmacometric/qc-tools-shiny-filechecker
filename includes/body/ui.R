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

body.main = moveable(
  body.model.info, # model infor panel
  body.panel.left, # directory selector
  body.panel.right.compare #
)
