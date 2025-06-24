
rmarkdown::render("JOSS_utilities/paper.rmd", 
                  output_file = "../paper.md"
                  )

preamble <- readr::read_lines("JOSS_utilities/preamble.txt")

c(preamble, readr::read_lines("paper.md")) |>
  stringr::str_replace_all("\\\\\\[", "\\[") |>
  stringr::str_replace_all("\\\\\\]", "\\]") |>
  readr::write_lines("paper.md")

rmarkdown::render("JOSS_utilities/paper.rmd", 
                  output_file = "../vignettes/PaperVignette.Rmd")

c(preamble, readr::read_lines("vignettes/PaperVignette.Rmd")) |>
  stringr::str_replace_all("\\\\\\[", " \\[") |>
  stringr::str_replace_all("\\\\\\]", "\\]") |>
  readr::write_lines("vignettes/PaperVignette.Rmd")
