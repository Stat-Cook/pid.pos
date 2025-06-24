library(rmarkdown)
library(readr)

paper.md <- read_lines("JOSS_utilities/paper.rmd")

render_preamble <- read_lines("JOSS_utilities/render_preamble.txt")
joss_preamble <- read_lines("JOSS_utilities/joss_preamble.txt")

temp_rmd <- tempfile(fileext = ".Rmd")

c(render_preamble, paper.md) |>
  readr::write_lines(temp_rmd)

render(temp_rmd, output_file = "paper.md", output_dir = getwd())

c(joss_preamble, read_lines("paper.md")) |> 
  stringr::str_replace_all("\\\\(\\[|\\])", "\\1") |>
  readr::write_lines("paper.md")

vignette_preamble <- read_lines("JOSS_utilities/vignette_preamble.txt")

c(vignette_preamble, paper.md) |>
  readr::write_lines("vignettes/PaperVignette.Rmd")
