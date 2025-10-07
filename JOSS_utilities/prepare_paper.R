library(rmarkdown)
library(readr)
devtools::load_all()

kable_head <- function(x, ...) {
  head(x, 5) |> 
    knitr::kable() |>
    knitr::knit_print(...)
}


md_style <- md_document("markdown_github", df_print = kable_head)
attr <- xfun::attr2
render("JOSS_utilities/paper.rmd", md_style, output_file = "paper.md", output_dir = getwd())

# render("JOSS_utilities/paper.rmd", output_file = "pid_pos.docx", output_dir = getwd())

joss_preamble <- read_lines("JOSS_utilities/joss_preamble.txt")

c(joss_preamble, read_lines("paper.md")) |> 
  stringr::str_replace_all("\\\\(\\[|\\])", "\\1") |>
  readr::write_lines("paper.md")


paper.md <- read_lines("JOSS_utilities/paper.rmd")
vignette_preamble <- read_lines("JOSS_utilities/vignette_preamble.txt")

c(vignette_preamble, paper.md) |>
  readr::write_lines("vignettes/PaperVignette.Rmd")

detach("package:pid.pos", unload = TRUE)
pkgdown::build_site()
