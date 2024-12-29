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




observeEvent(input$dirfiletype1a,{
  fillisttxt = c()
  if(!dir.exists(input$dirfiletype1a)) {
    updateDirStatus("Directory does not exist for Original")
    shinyjs::runjs(paste0("$('#dirfiletype1afiles').html(\'\')"))
   return("")
  }
  for(kfil in sort(list.files(path = input$dirfiletype1a))){
    fillisttxt = c(fillisttxt,paste0('<div class="filelistc1"><i class="fas fa-file-pdf" role="presentation" aria-label="chart-area icon"></i> ',
                                     kfil,'</div>'))
  }
  shinyjs::runjs(paste0("$('#dirfiletype1afiles').html(\'",paste(fillisttxt,collapse = ""),"\')"))
})

observeEvent(input$dirfiletype1b,{
  fillisttxt = c()
  if(!dir.exists(input$dirfiletype1b)) {
    updateDirStatus("Directory does not exist for QC")
    shinyjs::runjs(paste0("$('#dirfiletype1bfiles').html(\'\')"))
    return("")
  }
  for(kfil in sort(list.files(path = input$dirfiletype1b))){
    fillisttxt = c(fillisttxt,paste0('<div class="filelistc1"><i class="fa-regular fa-file-excel"></i> <i class="fa-solid fa-file-word"></i> ',
                                     kfil,'</div>'))
  }
  shinyjs::runjs(paste0("$('#dirfiletype1bfiles').html(\'",paste(fillisttxt,collapse = ""),"\')"))
})
