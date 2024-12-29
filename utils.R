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


