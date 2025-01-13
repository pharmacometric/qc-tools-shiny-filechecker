############################################################################
############################################################################
##  Document Path: includes/body/path.selector/server.R
##
##  Author: W.H
##
##  Date: 2025-01-09
##
##  R Version: R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


observeEvent(input$dirfiletype1a,{
  fillisttxt = c()
  if(!dir.exists(input$dirfiletype1a)) {
    updateDirStatus("Directory does not exist for Original")
    shinyjs::runjs(paste0("$('#dirfiletype1afiles').html(\'\')"))
    return("")
  }

  files3 = sort(list.files(path = input$dirfiletype1a))
  updateSelectInput(session, "codecfile1", choices = c("Select file"="",files3))

  for(kfil in files3){
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

  files3 = sort(list.files(path = input$dirfiletype1b))
  updateSelectInput(session, "codecfile2", choices = c("Select file"="",files3))

  for(kfil in files3){
    fillisttxt = c(fillisttxt,paste0('<div class="filelistc1"><i class="fa-regular fa-file-excel"></i> <i class="fa-solid fa-file-word"></i> ',
                                     kfil,'</div>'))
  }
  shinyjs::runjs(paste0("$('#dirfiletype1bfiles').html(\'",paste(fillisttxt,collapse = ""),"\')"))
})



observeEvent(input$ufileupd1a,{
  originalfilename = input$ufileupd1a['name']
  newFilename = input$ufileupd1a$datapath
  extension = tools::file_ext(originalfilename)
  acceptedextensions = c("zip","gz","tgz")

  if(extension %nin% acceptedextensions){
    updateDirStatus("The file selected should be a .zip or .tgz or .tar.gz")
  }else{
    if(dir.exists(GLOBAL$storageDir)){
      if(extension == acceptedextensions[1])unzip(newFilename, exdir = GLOBAL$storageDir)
      else untar(newFilename, exdir = GLOBAL$storageDir)
      print(list.files(GLOBAL$storageDir, recursive = TRUE))
    }
  }


})
