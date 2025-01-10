############################################################################
############################################################################
##  Document Path: includes/body/server.R
##
##  Description: Server function for body
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################





output$summaryrestbl = renderDT(
  data01() %>% select(Group,ID,time,WT,Dose,cmt,ii,addl), options = list(lengthChange = FALSE)#,dom = 't'
)

output$rawrestbl = renderDT(
  summary01(), options = list(lengthChange = FALSE), filter = list(position = "top")
)



observe({

})



