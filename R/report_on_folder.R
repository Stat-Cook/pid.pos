empty.report <- data.frame(
  `doc_id` = character(0),
  token = character(0),
  sentence =character(0),
  Repeats = integer(0),
  "Affected Columns" = character(0)
)


report_on_folder <- function(data_path, report_dir = "Proper Noun Reports",
                             to_remove = c()){
  #' @export
  #'
  #' @importFrom dplyr arrange
  .files <- find_files(data_path)

  if (!dir.exists(report_dir)) dir.create(report_dir)

  for (.file in .files){

    base <- basename(.file)

    frm <- read_data(.file) %>%
      remove_if_exists(to_remove)

    tags <- data_frame_tagger(frm)

    base <- stringr::str_replace(base, "\\..*$", ".csv")

    noun.report.path <- file.path(report_dir, base)

    if(is.null(tags$`All Tags`)){
      write.csv(empty.report, noun.report.path)

    } else {
      report <- merge(
        tags$`Proper Nouns`,
        tags$Sentences,
        by.x = "doc_id", by.y = "ID"
      ) %>%
        select(doc_id, token, sentence, Repeats, `Affected Columns`) %>%
        arrange(doc_id)

      write.csv(report, noun.report.path)
    }
  }

}

