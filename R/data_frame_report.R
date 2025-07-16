data_frame_report <- function(frm,
                              chunk_size = 1e2,
                              to_remove = c()) {
  #' Tags a data frame with part of speech tags.
  #'
  #' @param frm A data frame to tag
  #' @param chunk_size The number of sentences to tag at a time
  #' @param to_remove A character vector of column names to remove from the data frame
  #'
  #' @export
  #' @importFrom magrittr %>%
  #' @importFrom dplyr group_by group_modify left_join where all_of
  #' @importFrom dplyr rename select mutate
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom tibble as_tibble
  tags <- data_frame_tagger(frm, chunk_size, to_remove)

  report <- left_join(
    tags$`Proper Nouns`,
    tags$Sentences,
    by = "ID"
  ) %>%
    as_tibble() |>
    select(-Sentence) |>
    arrange(PK) |>
    rename(Token = token, Sentence = sentence) |>
    select("ID", "Token", "Sentence", "Repeats", "Affected Columns")

  class(report) <- c("pid_report", class(report))
  report
}
