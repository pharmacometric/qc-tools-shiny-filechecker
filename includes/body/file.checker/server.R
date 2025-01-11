############################################################################
############################################################################
##  Document Path: includes/body/conc.vs.time/server.R
##
##  Description: Server function for file comparer
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# set data versions to use for plotting

observe({
  if (input$codecfile1 != "" & input$codecfile2 != "") {
    GLOBAL$selectedCheckFiles <- list(
      file.path(input$dirfiletype1a, input$codecfile1),
      file.path(input$dirfiletype1b, input$codecfile2)
    )
    if (length(unique(tools::file_ext(GLOBAL$selectedCheckFiles))) == 2) {
      updateFCStatus("You may only compare files with the same file extension.")
    } else {
      updateFCStatus("")
      GLOBAL$selectedCheckFilesProcess <- TRUE
    }
  }
})






# Time after first dose plot
output$concvtimeplot1 <- renderPlot({})

# Time after last dose plot
output$concvtimeplot2 <- renderPlot({})



# diff file
observe({
  if (GLOBAL$selectedCheckFilesProcess == TRUE) {
    file1 <- GLOBAL$selectedCheckFiles[[1]][1]
    file2 <- GLOBAL$selectedCheckFiles[[2]][1]


    # compare files
    samefileness <- compare_files_md5(file1, file2)
    percsim <- percent_similarity(file1, file2)
    percsimcol <- ifelse(percsim <= 50, "red", "green")
    shinyjs::runjs("$('#fcomparisonmetricsa').html('')")
    insertUI(
      selector = "#fcomparisonmetricsa",
      where = "beforeEnd",
      tagList(
        outexactcomp(filename = basename(file1) == basename(file2), sameness = samefileness),br(),br(),
        outcomparev(id = "comparefile1", id2 = "comparefile1b", label = "Similarity between the files", value = paste0(percsim, "%"), color = percsimcol),
      )
    )





    # do a diff
    output$diffrfiles <- renderDiffr({
      diffr(file1, file2,
        wordWrap = input$fcwordWrap,
        # width = input$fcwidth,
        # height = input$fcheight,
        minJumpSize = input$fcminjs,
        contextSize = input$fccons,
        before = paste0("Original (",basename(file1),")"), paste0("QC (",basename(file2),")")
      )
    })
    GLOBAL$selectedCheckFilesProcess <- FALSE
  }
})
