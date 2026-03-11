library(tidyverse)

{
  s8 <- friends::friends |>
    filter(season == 8) %>%
    filter(episode <= 3) %>%
    split(.$episode)
  
  s8.info <- friends::friends_info |>
    filter(season == 8) %>%
    filter(episode <= 3)
  s8.titles <- s8.info$title
  names(s8.titles) <- s8.info$episode
  
  names(s8) <- s8.titles[names(s8)] |>
    str_remove_all("\\.|\\'") |>
    str_replace_all("\\s+", "_")
  
}

purrr::imap(s8, ~readr::write_csv(.x, file.path("inst", "vignette_data", paste0(.y, ".csv"))))

report_on_folder(file.path("inst", "vignette_data"), report_dir = file.path("inst", "vignette_reports"))
