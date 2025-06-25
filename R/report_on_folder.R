empty.report <- data.frame(
  `ID` = character(0),
  Token = character(0),
  Sentence = character(0),
  Repeats = integer(0),
  "Affected Columns" = character(0)
)


report_on_folder <- function(data_path, report_dir = "Proper Noun Reports",
                             to_remove = c()) {
  #' Itterates over a folder of data files and produces a report on proper nouns.
  #'
  #' @param data_path The path to the data files
  #' @param report_dir The directory to save the reports
  #' @param to_remove A character vector of column names to remove from the data frame
  #'
  #' @return NULL
  #'
  #' @export
  #'
  #' @importFrom dplyr arrange
  #' @importFrom stringr str_replace str_replace_all
  .files <- find_files(data_path)

  doc_id <- NA

  if (!dir.exists(report_dir)) dir.create(report_dir)

  for (.file in .files) {
    base <- basename(.file)

    frm <- read_data(.file) %>%
      remove_if_exists(to_remove)

    report <- data_frame_report(frm)

    base <- str_replace(base, "\\..*$", ".csv")

    noun.report.path <- file.path(report_dir, base)

    if (nrow(report) == 0) {
      write.csv(empty.report, noun.report.path)
    } else {
      write.csv(report, noun.report.path)
    }
  }
}
