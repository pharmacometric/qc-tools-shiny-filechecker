header.main <- titlePanel(tags$div(
  tags$img(src="logo.jpg")," ",
  "QC toolset: Scripts and output checker",
  tags$div(class = "hidden-mobile hidden-tablet pull-right",
             actionButton("aboutproject", "", icon = icon("question")))
), windowTitle = "QC toolset: pharmacometric scripts and output checker")
