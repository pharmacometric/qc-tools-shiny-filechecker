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
updateSelectInput(session, "datatoUseconc1", choices = c())
updateSelectInput(session, "datatoUseconc2", choices = c())







# Time after first dose plot
output$concvtimeplot1 <- renderPlot({})

# Time after last dose plot
output$concvtimeplot2 <- renderPlot({})



# diff file

output$diffrfiles <- renderDiffr({
  file1 = "www/example/Original/sampleplotcode.R"
  file2 = "www/example/QC/sampleplotcode_qc.R"
  diffr(file1, file2, wordWrap = input$fcwordWrap,
        #width = input$fcwidth,
        #height = input$fcheight,
        minJumpSize = input$fcminjs,
        contextSize = input$fccons,
        before = "Original", after = "QC")
})
