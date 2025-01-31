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

# set colors for progress bar
lowcol <- "redLight"
highcol <- "green"

# add progress file observe
observe({
  if (input$codecfile1 != "" & input$codecfile2 != "") {
    GLOBAL$selectedCheckFiles <- list(
      file.path(input[[GLOBAL$selectedfilesInput[1]]], input$codecfile1),
      file.path(input[[GLOBAL$selectedfilesInput[2]]], input$codecfile2)
    )
    if (length(unique(tools::file_ext(GLOBAL$selectedCheckFiles))) == 2) {
      updateFCStatus("You may only compare files with the same file extension.")
    } else {
      updateFCStatus("")
      GLOBAL$selectedCheckFilesProcess <- 1L
    }
  }else{
    GLOBAL$selectedCheckFiles <- list()
  }
})






# diff file
observe({
  if (GLOBAL$selectedCheckFilesProcess == 1L) {
    file1 <- GLOBAL$selectedCheckFiles[[1]][1]
    file2 <- GLOBAL$selectedCheckFiles[[2]][1]

    # halt if the files do not exist
    if(!file.exists(file1) | !file.exists(file2)) return()

    # compare files
    samefileness <- compare_files_md5(file1, file2)
    shinyjs::runjs("$('#fcomparisonmetricsa').html('')")
    insertUI(
      selector = "#fcomparisonmetricsa",
      where = "beforeEnd",
      tagList(
        outexactcomp(filename = basename(file1) == basename(file2), sameness = samefileness), br(), br()
      )
    )


    shinyjs::runjs("$('#diffrfilesimg').html('')")
    shinyjs::runjs("$('#diffrfiles').html('')")

    # check if images
    isImage <- 0L
    if (tools::file_ext(file1) != "") {
      if (is.image(file1)) isImage <- 1L
    }

    if (!isImage & tools::file_ext(file1) %nin% c("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "csv")) {
      # if (tools::file_ext(file1) %in% c("","R","py","Rmd","txt","csv","xpt","Rd")) {
      # diff for txt files and scripts
      insertUI(
        selector = "#fcomparisonmetricsa", where = "beforeEnd",
        outcomparev(
          id = "comparefile1", id2 = "comparefile1b",
          label = "Similarity between the files",
          value = paste0(percent_similarity(file1, file2), "%"), color = ifelse(percent_similarity(file1, file2) <= 50, lowcol, highcol)
        ),
      )

      output$diffrfiles <- renderDiffr({
        diffr(file1, file2,
          wordWrap = input$fcwordWrap,
          # width = input$fcwidth,
          # height = input$fcheight,
          minJumpSize = input$fcminjs,
          contextSize = input$fccons,
          before = paste0("Original (", basename(file1), "; ", add_file_size(file1), "", ")"), paste0("QC (", basename(file2), "; ", "", add_file_size(file1), "", ")")
        )
      })
    } else {
      # for images
      if (isImage) {
        togglebuffermsg("fcomparisonmetricsa", 1L)
        imgcomparev(id = "diffrfilesimg", file1, file2)
        insertUI(
          selector = "#fcomparisonmetricsa", where = "beforeEnd",
          outcomparev(
            id = "comparefile1", id2 = "comparefile1b",
            label = "Similarity between the image files",
            value = paste0(compare_images(file1, file2), "%"), color = ifelse(compare_images(file1, file2) <= 50, lowcol, highcol)
          ),
        )
        togglebuffermsg("fcomparisonmetricsa", 0L)
      }


      # for word documents
      if (tools::file_ext(file1) %in% c("doc", "docx")) {
        togglebuffermsg("fcomparisonmetricsa", 1L)
        insertUI(
          selector = "#fcomparisonmetricsa", where = "beforeEnd",
          outcomparev(
            id = "comparefile1", id2 = "comparefile1b",
            label = "Similarity between the Word files",
            value = paste0(compare_word_files(file1, file2), "%"), color = ifelse(compare_word_files(file1, file2) <= 50, lowcol, highcol)
          ),
        )


        nfile1 <- tempfile()
        writeLines(read_docx(file1) %>% docx_summary() %>% dplyr::pull(text), con = nfile1)
        nfile2 <- tempfile()
        writeLines(read_docx(file2) %>% docx_summary() %>% dplyr::pull(text), con = nfile2)

        output$diffrfiles <- renderDiffr({
          diffr(nfile1, nfile2,
            wordWrap = input$fcwordWrap,
            minJumpSize = input$fcminjs,
            contextSize = input$fccons,
            before = paste0("Original (", basename(file1), "; ", add_file_size(file1), "", ")"), paste0("QC (", basename(file2), "; ", "", add_file_size(file1), "", ")")
          )
        })
        togglebuffermsg("fcomparisonmetricsa", 0L)
      }

      # for pdf documents
      if (tools::file_ext(file1) %in% c("pdf")) {
        togglebuffermsg("fcomparisonmetricsa", 1L)
        insertUI(
          selector = "#fcomparisonmetricsa", where = "beforeEnd",
          outcomparev(
            id = "comparefile1", id2 = "comparefile1b",
            label = "Similarity between the PDF files",
            value = paste0(compare_pdfs(file1, file2), "%"), color = ifelse(compare_pdfs(file1, file2) <= 50, lowcol, highcol)
          ),
        )


        nfile1 <- tempfile()
        writeLines(pdf_text(file1), con = nfile1)
        nfile2 <- tempfile()
        writeLines(pdf_text(file2), con = nfile2)

        output$diffrfiles <- renderDiffr({
          diffr(nfile1, nfile2,
            wordWrap = input$fcwordWrap,
            minJumpSize = input$fcminjs,
            contextSize = input$fccons,
            before = paste0("Original (", basename(file1), "; ", add_file_size(file1), "", ")"), paste0("QC (", basename(file2), "; ", "", add_file_size(file1), "", ")")
          )
        })
        togglebuffermsg("fcomparisonmetricsa", 0L)
      }


      # for ppt documents
      if (tools::file_ext(file1) %in% c("ppt", "pptx")) {
        togglebuffermsg("fcomparisonmetricsa", 1L)
        insertUI(
          selector = "#fcomparisonmetricsa", where = "beforeEnd",
          outcomparev(
            id = "comparefile1", id2 = "comparefile1b",
            label = "Similarity between the PPT files",
            value = paste0(compare_ppts(file1, file2), "%"), color = ifelse(compare_ppts(file1, file2) <= 50, lowcol, highcol)
          ),
        )


        nfile1 <- tempfile()
        writeLines(pptx_summary(read_pptx(file1)) %>% dplyr::pull(text), con = nfile1)
        nfile2 <- tempfile()
        writeLines(pptx_summary(read_pptx(file2)) %>% dplyr::pull(text), con = nfile2)

        output$diffrfiles <- renderDiffr({
          diffr(nfile1, nfile2,
            wordWrap = input$fcwordWrap,
            # width = input$fcwidth,
            # height = input$fcheight,
            minJumpSize = input$fcminjs,
            contextSize = input$fccons,
            before = paste0("Original (", basename(file1), "; ", add_file_size(file1), "", ")"), paste0("QC (", basename(file2), "; ", "", add_file_size(file1), "", ")")
          )
        })
        togglebuffermsg("fcomparisonmetricsa", 0L)
      }



      # for csv documents
      if (tools::file_ext(file1) %in% c("csv")) {
        togglebuffermsg("fcomparisonmetricsa", 1L)
        insertUI(
          selector = "#fcomparisonmetricsa", where = "beforeEnd",
          outcomparev(
            id = "comparefile1", id2 = "comparefile1b",
            label = "Similarity between the CSV files",
            value = paste0(compare_csvs(file1, file2), "%"), color = ifelse(compare_csvs(file1, file2) <= 50, lowcol, highcol)
          ),
        )


        output$diffrfiles <- renderDiffr({
          diffr(file1, file2,
            wordWrap = input$fcwordWrap,
            minJumpSize = input$fcminjs,
            contextSize = input$fccons,
            before = paste0("Original (", basename(file1), "; ", add_file_size(file1), "", ")"), paste0("QC (", basename(file2), "; ", "", add_file_size(file1), "", ")")
          )
        })
        togglebuffermsg("fcomparisonmetricsa", 0L)
      }
    }

    GLOBAL$selectedCheckFilesProcess <- 0L
  }
})
