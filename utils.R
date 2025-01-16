############################################################################
############################################################################
##  Document Path: utils.R
##
##  Description: global functions and variables used by the app
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


source.part <- function(path, which = c("ui", "server"), input = NULL, output = NULL, session = NULL) {
  which <- match.arg(which)
  for (h in list.files(path = path, pattern = paste0(which, ".R$"), full.names = 1L, recursive = 1L)) {
    this.path <- dirname(h)
    source(h, local = TRUE)
  }
}


updateDirStatus <- function(message = "") {
  shinyjs::runjs(paste0("$('#trackfileupdates').html('", message, "')"))
}

updateDirStatus4 <- function(g) {

}
updateFCStatus <- function(message = "", color = "red") {
  if (message == "") {
    shinyjs::runjs(paste0("$('#filecomparemessage').html('')"))
  } else {
    shinyjs::runjs(paste0("$('#filecomparemessage').html('<blockquote style=\"color:", color, "\">", message, "</blockquote>')"))
  }
}


updateGraphStatus <- function(message = "") {
  shinyjs::runjs(paste0("$('#reportgraphstatus').html('", message, "')"))
}

updateGraphStatus2 <- function(message = "") {
  shinyjs::runjs(paste0("$('#reportgraphstatus2').html('", message, "')"))
}

updateGraphStatus3 <- function(message = "") {
  shinyjs::runjs(paste0("$('#reporthiststatus2').html('", message, "')"))
}


updateGraphStatus4 <- function(message = "") {
  shinyjs::runjs(paste0("$('#repttablstatus1').html('", message, "')"))
}
updateVariableHolder <- function(message = "") {
  shinyjs::runjs(paste0("$('#varnamesholder').html('", message, "')"))
}




getTimeV <- function(n, t0) {
  if (n > 1) {
    c(0, pop_off(cumsum(t0)))
  } else {
    0
  }
}

pop_off <- function(.) {
  .[1:{
    length(.) - 1
  }]
}

compare_files <- function(file1, file2) {
  # Check if both files exist
  if (!file.exists(file1) || !file.exists(file2)) {
    message("One or both of the files do not exist.")
    return(FALSE)
  }

  # Read the content of the files
  content1 <- readLines(file1, warn = FALSE)
  content2 <- readLines(file2, warn = FALSE)

  # Compare the contents
  identical(content1, content2)
}

compare_files_md5 <- function(file1, file2) {
  # Check if both files exist
  if (!file.exists(file1) || !file.exists(file2)) {
    message("One or both of the files do not exist.")
    return(FALSE)
  }

  # Calculate MD5 hash for both files
  hash1 <- tools::md5sum(file1)
  hash2 <- tools::md5sum(file2)

  # Compare the hashes
  hash1 == hash2
}


percent_similarity <- function(file1, file2) {
  # Check if both files exist
  if (!file.exists(file1) || !file.exists(file2)) {
    message("One or both of the files do not exist.")
    return(0)
  }

  # Read the content of the files
  content1 <- readLines(file1, warn = FALSE)
  content2 <- readLines(file2, warn = FALSE)

  # Make both files the same length by padding shorter file with empty lines
  max_length <- max(length(content1), length(content2))
  content1 <- c(content1, rep("", max_length - length(content1)))
  content2 <- c(content2, rep("", max_length - length(content2)))

  # Calculate the number of matching lines
  matching_lines <- sum(content1 == content2)

  # Calculate percent similarity
  percent <- round((matching_lines / max_length) * 100, 2)

  return(percent)
}



compare_word_files <- function(file1, file2) {
  # Extract text from both Word files
  doc1 <- read_docx(file1) %>%
    docx_summary() %>%
    dplyr::pull(text) %>%
    paste(collapse = "\n")
  doc2 <- read_docx(file2) %>%
    docx_summary() %>%
    dplyr::pull(text) %>%
    paste(collapse = "\n")

  # Calculate similarity (e.g., line-by-line)
  lines1 <- unlist(strsplit(doc1, "\n"))
  lines2 <- unlist(strsplit(doc2, "\n"))

  max_length <- max(length(lines1), length(lines2))
  lines1 <- c(lines1, rep("", max_length - length(lines1)))
  lines2 <- c(lines2, rep("", max_length - length(lines2)))

  similarity <- sum(lines1 == lines2) / max_length * 100
  return(round(similarity, 2))
}


compare_images <- function(img1_path, img2_path) {
  # Load images
  img1 <- imager::load.image(img1_path)
  img2 <- imager::load.image(img2_path)

  # Resize using imager's resize function
  # Calculate new dimensions maintaining aspect ratio
  target_size <- 100
  img1 <- imager::resize(img1, target_size, target_size)
  img2 <- imager::resize(img2, target_size, target_size)

  # Convert to grayscale if not already
  if (dim(img1)[4] > 1) img1 <- 0.3 * imager::R(img1) + 0.59 * imager::G(img1) + 0.11 * imager::B(img1)
  if (dim(img2)[4] > 1) img2 <- 0.3 * imager::R(img2) + 0.59 * imager::G(img2) + 0.11 * imager::B(img2)

  # Convert to matrices for easier calculation
  img1_matrix <- as.matrix(img1)
  img2_matrix <- as.matrix(img2)

  # Calculate Mean Squared Error (MSE)
  mse <- mean((img1_matrix - img2_matrix)^2)

  # Calculate similarity percentage
  round(100 * (1 - mse), 2)
}


compare_pdfs <- function(file1, file2) {
  # Extract text from both PDFs
  text1 <- pdf_text(file1) %>% paste(collapse = "\n")
  text2 <- pdf_text(file2) %>% paste(collapse = "\n")

  # Split text into lines for comparison
  lines1 <- unlist(strsplit(text1, "\n"))
  lines2 <- unlist(strsplit(text2, "\n"))

  # Make lengths equal
  max_length <- max(length(lines1), length(lines2))
  lines1 <- c(lines1, rep("", max_length - length(lines1)))
  lines2 <- c(lines2, rep("", max_length - length(lines2)))

  # Calculate percent similarity
  matching_lines <- sum(lines1 == lines2)
  percent_similarity <- (matching_lines / max_length) * 100
  return(round(percent_similarity, 2))
}

compare_csvs <- function(file1, file2) {
  # Read the CSV files
  data1 <- read.csv(file1, stringsAsFactors = FALSE)
  data2 <- read.csv(file2, stringsAsFactors = FALSE)

  # Check for identical structure
  if (!all(names(data1) == names(data2)) || nrow(data1) != nrow(data2)) {
    return(0) # 0% similarity if structure differs
  }

  # Calculate percent similarity
  total_cells <- nrow(data1) * ncol(data1)
  matching_cells <- sum(data1 == data2, na.rm = TRUE)
  percent_similarity <- (matching_cells / total_cells) * 100
  return(round(percent_similarity, 2))
}


compare_ppts <- function(file1, file2) {
  # Read presentations
  ppt1 <- read_pptx(file1)
  ppt2 <- read_pptx(file2)

  # Extract text from slides
  text1 <- pptx_summary(ppt1) %>%
    dplyr::pull(text) %>%
    paste(collapse = "\n")
  text2 <- pptx_summary(ppt2) %>%
    dplyr::pull(text) %>%
    paste(collapse = "\n")

  # Compare the extracted text
  lines1 <- unlist(strsplit(text1, "\n"))
  lines2 <- unlist(strsplit(text2, "\n"))

  max_length <- max(length(lines1), length(lines2))
  lines1 <- c(lines1, rep("", max_length - length(lines1)))
  lines2 <- c(lines2, rep("", max_length - length(lines2)))

  matching_lines <- sum(lines1 == lines2)
  percent_similarity <- (matching_lines / max_length) * 100
  return(round(percent_similarity, 2))
}

switchicons <- function(xfile = "") {
  # file 2
  # file-excel 2
  # file-export 1 solid
  # file-word 2
  # file-import 1 solid
  # file-pdf 2
  # file-powerpoint 1 solid
  # file-lines 1 solid
  # file-image 1 solid
  # file-csv 1 solid
  # file-code 2
  # file-circle-question 1 solid
  #
  # folder 2
  # folder-open 2
  # folder-closed 2
  # folder-tree 1

  .icon <- "file-circle-question"
  switch(xfile,
    "txt" = {
      .icon <- "file"
    },
    "xlsx" = {
      .icon <- "file-excel"
    },
    "xls" = {
      .icon <- "file-excel"
    },
    "export" = {
      .icon <- "file-export"
    },
    "doc" = {
      .icon <- "file-word"
    },
    "docx" = {
      .icon <- "file-word"
    },
    "import" = {
      .icon <- "file-import"
    },
    "pdf" = {
      .icon <- "file-pdf"
    },
    "ppt" = {
      .icon <- "file-powerpoint"
    },
    "pptx" = {
      .icon <- "file-powerpoint"
    },
    "lines" = {
      .icon <- "file-lines"
    },
    "png" = {
      .icon <- "file-image"
    },
    "jpg" = {
      .icon <- "file-image"
    },
    "tiff" = {
      .icon <- "file-image"
    },
    "csv" = {
      .icon <- "file-csv"
    },
    "code" = {
      .icon <- "file-code"
    },
    "folder" = {
      .icon <- "folder"
    },
    "fopen" = {
      .icon <- "folder-open"
    },
    "fclose" = {
      .icon <- "folder-closed"
    },
    "dtree" = {
      .icon <- "folder-tree"
    },
    {
      .icon <- "file"
    }
  )

  return(.icon)
}

sort_by_name_and_ext <- function(file_paths) {
  # Split the file names into name and extension
  file_info <- data.frame(
    file_name = tools::file_path_sans_ext(basename(file_paths)),
    extension = tools::file_ext(file_paths),
    full_path = file_paths,
    stringsAsFactors = FALSE
  )

  # Sort by file name, then by extension
  sorted_files <- file_info[order(file_info$extension), ]

  # Return the sorted file paths
  return(sorted_files$full_path)
}

add_file_size <- function(file_path) {
  # Get file size in bytes
  size_bytes <- file.size(file_path)

  # Define conversion factors
  KB <- 1024
  MB <- KB * 1024
  GB <- MB * 1024
  TB <- GB * 1024

  # Convert to appropriate unit
  if (size_bytes < KB) {
    return(sprintf("%.2f bytes", size_bytes))
  } else if (size_bytes < MB) {
    return(sprintf("%.2f KB", size_bytes / KB))
  } else if (size_bytes < GB) {
    return(sprintf("%.2f MB", size_bytes / MB))
  } else if (size_bytes < TB) {
    return(sprintf("%.2f GB", size_bytes / GB))
  } else {
    return(sprintf("%.2f TB", size_bytes / TB))
  }
}

togglebuffermsg <- function(id, t) {
  if (t) {
    shinyjs::runjs(paste0("$('#", id, "').html('<p><b style=\"color:red\">Loading other comparison measures and similarity percent..</b></p>')"))
  } else {
    shinyjs::runjs(paste0("$('#", id, "').html('')"))
  }
}

shwhdbtn <- function(id = "dirfiletype1afiles") {
  tags$div(tags$button("Show:hide files", class = "btn btn-default mb-2", onclick = paste0("document.querySelector('#", id, "').classList.toggle('hidethis')")))
}

extract_pattern <- function(file) {
  extract_words_with_braces <- function(string) {
    pattern <- "\\{([A-Z]+)\\}"
    matches <- stringr::str_extract_all(string, pattern)
    if (length(matches) > 0) {
      return(unlist(matches))
    } else {
      return(NULL)
    }
  }

  # Read the file line by line
  lines <- readLines(file)
  replacebr <- c()
  for (line in lines) {
    replacebr <- c(replacebr, extract_words_with_braces(line))
  }
  replacebr
}

outexactcomp <- function(filename, sameness = TRUE) {
  color2 <- switch(as.character(as.boolean(sameness, type = 1)),
    "No" = "danger",
    "Yes" = "success"
  )
  .text1 <- ifelse(filename, "The two files have the same file names.", "The two files have different file names.")
  .text2 <- ifelse(sameness, "Both files are exactly the same.", "Both files are different from each other!")
  tags$div(class = paste0("mb-4 label label-", color2), .text1, .text2)
}

outcomparev <- function(id, id2 = "", label = "", value = "50%", value2 = value, color = "redLight") {
  tags$div(
    id = id,
    tags$span(
      class = "text", label,
      tags$span(class = "pull-right", id = id2, value)
    ),
    tags$div(
      class = "progress progress-striped",
      tags$div(class = paste0("progress-bar bg-color-", color), `data-transitiongoal` = "1", `aria-valuenow` = "1", style = paste0("width: ", value2, ";"), value2)
    )
  )
}



imgcomparev <- function(id, img1, img2) {
  .h <- row(
    class = "padding-15",
    column(width = 6, class = "p-0", tags$div(tags$b(basename(img1), "(", add_file_size(img1), ")")), tags$img(src = gsub("^www/", "", img1), width = "100%")),
    column(width = 6, class = "p-0", tags$div(tags$b(basename(img2), "(", add_file_size(img1), ")")), tags$img(src = gsub("^www/", "", img2), width = "100%"))
  )
  shinyjs::runjs(paste0("$('#", id, "').html('", gsub("\n", "", .h), "')"))
}
