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

library(ggplot2)
library(grid)
library(ggthemes)

source.part = function(path, which = c("ui", "server"), input = NULL, output = NULL, session = NULL) {
  which = match.arg(which)
  for (h in list.files(path = path, pattern = paste0(which, ".R$"), full.names = 1L, recursive = 1L)) {
    this.path = dirname(h)
    source(h, local = TRUE)
  }
}


updateDirStatus = function(message = "") {
  shinyjs::runjs(paste0("$('#trackfileupdates').html('", message, "')"))
}

updateDirStatus4 = function(g){

}

updateGraphStatus = function(message = "") {
  shinyjs::runjs(paste0("$('#reportgraphstatus').html('", message, "')"))
}

updateGraphStatus2 = function(message = "") {
  shinyjs::runjs(paste0("$('#reportgraphstatus2').html('", message, "')"))
}

updateGraphStatus3 = function(message = "") {
  shinyjs::runjs(paste0("$('#reporthiststatus2').html('", message, "')"))
}


updateGraphStatus4 = function(message = "") {
  shinyjs::runjs(paste0("$('#repttablstatus1').html('", message, "')"))
}
updateVariableHolder = function(message = "") {
  shinyjs::runjs(paste0("$('#varnamesholder').html('", message, "')"))
}

disableSims = function(is = "1L") {
  shinyjs::runjs(paste0('$("#runsimbutton").prop("disabled",', is, ")"))
}




styler06 = list(theme(
  axis.title.y = element_text(face = "bold"),
  panel.background = element_rect(colour = "#333333"),
  strip.text = element_text(face = "bold")
))

styler00 = list(theme(
  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  axis.title.y = element_text(face = "bold"),
  panel.background = element_rect(colour = "#333333"),
  strip.text = element_text(face = "bold")
))

styler03 = theme(
  plot.title = element_text(
    face = "bold",
    hjust = 0.5, margin = margin(0, 0, 20, 0)
  ),
  text = element_text(),
  panel.background = element_rect(colour = NA),
  plot.background = element_rect(colour = NA),
  panel.border = element_rect(colour = NA),
  axis.title = element_text(face = "bold", size = rel(1)),
  axis.title.y = element_text(angle = 90, vjust = 2),
  axis.title.x = element_text(vjust = -0.2),
  axis.text = element_text(),
  axis.line.x = element_line(colour = "black"),
  axis.line.y = element_line(colour = "black"),
  axis.ticks = element_line(),
  legend.key = element_rect(colour = NA),
  legend.position = "bottom",
  legend.direction = "horizontal",
  legend.box = "vetical",
  legend.key.size = unit(0.5, "cm"),
  # legend.margin = unit(0, "cm"),
  legend.title = element_text(face = "italic"),
  plot.margin = unit(c(10, 5, 5, 5), "mm"),
  strip.background = element_rect(colour = "#000000", fill = "#f3f3f3", linewidth = rel(1.6)),
  strip.text = element_text(face = "bold")
)
styler01 = list(
  theme(
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14, face = "bold", angle = 90),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 14),
    # panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text.x = element_text(size = 14, face = "bold")
  )
)



getTimeV = function(n, t0) {
  if (n > 1) {
    c(0, pop_off(cumsum(t0)))
  } else {
    0
  }
}

pop_off = function(.) {
  .[1:{
    length(.) - 1
  }]
}

compare_files <- function(file1, file2) {
  # Check if both files exist
  if (!file.exists(file1) || !file.exists(file2)) {
    stop("One or both of the files do not exist.")
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
    stop("One or both of the files do not exist.")
  }

  # Calculate MD5 hash for both files
  hash1 <- utils::md5sum(file1)
  hash2 <- utils::md5sum(file2)

  # Compare the hashes
  identical(hash1, hash2)
}


percent_similarity <- function(file1, file2) {
  # Check if both files exist
  if (!file.exists(file1) || !file.exists(file2)) {
    stop("One or both of the files do not exist.")
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
  percent <- (matching_lines / max_length) * 100

  return(percent)
}



compare_word_files <- function(file1, file2) {
  # Extract text from both Word files
  doc1 <- read_docx(file1) %>% docx_summary() %>% dplyr::pull(text) %>% paste(collapse = "\n")
  doc2 <- read_docx(file2) %>% docx_summary() %>% dplyr::pull(text) %>% paste(collapse = "\n")

  # Calculate similarity (e.g., line-by-line)
  lines1 <- unlist(strsplit(doc1, "\n"))
  lines2 <- unlist(strsplit(doc2, "\n"))

  max_length <- max(length(lines1), length(lines2))
  lines1 <- c(lines1, rep("", max_length - length(lines1)))
  lines2 <- c(lines2, rep("", max_length - length(lines2)))

  similarity <- sum(lines1 == lines2) / max_length * 100
  return(similarity)
}


compare_images <- function(file1, file2) {
  # Load the images
  img1 <- image_read(file1)
  img2 <- image_read(file2)

  # Resize images to the same dimensions
  img2 <- image_resize(img2, image_info(img1)$geometry)

  # Calculate pixel differences
  diff <- image_compare(img1, img2, metric = "AE") # Absolute Error

  # Convert to percent similarity
  total_pixels <- prod(dim(as.raster(img1)))
  percent_similarity <- 100 - (diff / total_pixels) * 100

  return(percent_similarity)
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
  return(percent_similarity)
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
  return(percent_similarity)
}


compare_ppts <- function(file1, file2) {
  # Read presentations
  ppt1 <- read_pptx(file1)
  ppt2 <- read_pptx(file2)

  # Extract text from slides
  text1 <- pptx_summary(ppt1) %>% dplyr::pull(text) %>% paste(collapse = "\n")
  text2 <- pptx_summary(ppt2) %>% dplyr::pull(text) %>% paste(collapse = "\n")

  # Compare the extracted text
  lines1 <- unlist(strsplit(text1, "\n"))
  lines2 <- unlist(strsplit(text2, "\n"))

  max_length <- max(length(lines1), length(lines2))
  lines1 <- c(lines1, rep("", max_length - length(lines1)))
  lines2 <- c(lines2, rep("", max_length - length(lines2)))

  matching_lines <- sum(lines1 == lines2)
  percent_similarity <- (matching_lines / max_length) * 100
  return(percent_similarity)
}

switchicons = function(xfile = ""){
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

  .icon = "file-circle-question"
  switch (xfile,
    "txt" = {.icon = "file"},
    "xlsx" = {.icon = "file-excel"},
    "xls" = {.icon = "file-excel"},
    "export" = {.icon = "file-export"},
    "doc" = {.icon = "file-word"},
    "docx" = {.icon = "file-word"},
    "import" = {.icon = "file-import"},
    "pdf" = {.icon = "file-pdf"},
    "ppt" = {.icon = "file-powerpoint"},
    "pptx" = {.icon = "file-powerpoint"},
    "lines" = {.icon = "file-lines"},
    "png" = {.icon = "file-image"},
    "jpg" = {.icon = "file-image"},
    "tiff" = {.icon = "file-image"},
    "csv" = {.icon = "file-csv"},
    "code" = {.icon = "file-code"},
    "folder" = {.icon = "folder"},
    "fopen" = {.icon = "folder-open"},
    "fclose" = {.icon = "folder-closed"},
    "dtree" = {.icon = "folder-tree"}
  )

  return(.icon)
}

calculate_auc = function(time, concentration) {
  # Check if inputs are of the same length
  if (length(time) != length(concentration)) {
    stop("Time and concentration vectors must be of the same length.")
  }

  # Sort the time and concentration data by time
  sorted_indices = order(time)
  time = time[sorted_indices]
  concentration = concentration[sorted_indices]

  # Calculate the AUC using the trapezoidal rule
  auc = sum((time[-1] - time[-length(time)]) * (concentration[-1] + concentration[-length(concentration)]) / 2)

  return(auc)
}



sampleplot = function() {
  colss = sample(grDevices::colors(), 5)
  plot(c(0, 20, 100),
       c(0, 20, 100),
       bg = colss[1:3],
       xlab = "Sample x",
       cex = 2,
       pch = 21,
       axes = 1L,
       ylab = "Sample y",
       bty = "n"
  )
  # box(lwd=2, col=colss[4])
  text(50, 50, "Click 'Generate data version' to get started", cex = 1.5, pos = 3, col = "red")
}




data_summarised_overall = function(dataa) {
  if (nrow(dataa)) {
    dataa %>%
      filter(not.na(.dv)) %>%
      group_by(.summ, .tm) %>%
      reframe(
        dv_mean = mean(.dv),
        dv_med = median(.dv),
        sd = sd(.dv),
        sem = sd(.dv) / sqrt(length((.dv))),
        q95 = quantile(.dv, probs = 0.95),
        q05 = quantile(.dv, probs = 0.05),
        q975 = quantile(.dv, probs = 0.975),
        q025 = quantile(.dv, probs = 0.025)
      )
  }
}

data_summarised_facet = function(dataa) {
  if (nrow(dataa)) {
    dataa %>%
      filter(not.na(.dv)) %>%
      group_by(.summ, .tm) %>%
      reframe(
        .colv = unique(.colv)[1],
        dv_mean = mean(.dv),
        dv_med = median(.dv),
        sd = sd(.dv),
        sem = sd(.dv) / sqrt(length((.dv))),
        q95 = quantile(.dv, probs = 0.95),
        q05 = quantile(.dv, probs = 0.05),
        q975 = quantile(.dv, probs = 0.975),
        q025 = quantile(.dv, probs = 0.025)
      )
  }
}



extract_pattern = function(file) {
  extract_words_with_braces = function(string) {
    pattern = "\\{([A-Z]+)\\}"
    matches = stringr::str_extract_all(string, pattern)
    if (length(matches) > 0) {
      return(unlist(matches))
    } else {
      return(NULL)
    }
  }

  # Read the file line by line
  lines = readLines(file)
  replacebr = c()
  for (line in lines) {
    replacebr = c(replacebr, extract_words_with_braces(line))
  }
  replacebr
}



outcomparev <- function(id, id2 = "", label = "", value = "50%", value2 = value, color = "red") {
  tags$div(
    id = id,
    tags$span(
      class = "text", label,
      tags$span(class = "pull-right", id = id2, value)
    ),
    tags$div(
      class = "progress",
      tags$div(class = paste0("progress-bar bg-color-", color),`data-transitiongoal`="1", `aria-valuenow`="1", style = paste0("width: ", value2, ";"), value2)
    )
  )
}
