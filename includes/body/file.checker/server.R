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

    GLOBAL$selectedCheckFilesProcess <- TRUE
    }

})






# Time after first dose plot
output$concvtimeplot1 <- renderPlot({})

# Time after last dose plot
output$concvtimeplot2 <- renderPlot({})



# diff file
observe({
  if (GLOBAL$selectedCheckFilesProcess == TRUE) {
    output$diffrfiles <- renderDiffr({
      file1 <- GLOBAL$selectedCheckFiles[[1]][1]
      file2 <- GLOBAL$selectedCheckFiles[[2]][1]
      diffr(file1, file2,
        wordWrap = input$fcwordWrap,
        # width = input$fcwidth,
        # height = input$fcheight,
        minJumpSize = input$fcminjs,
        contextSize = input$fccons,
        before = "Original", after = "QC"
      )
    })
    GLOBAL$selectedCheckFilesProcess <- FALSE
  }
})
