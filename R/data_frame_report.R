data_frame_report <- function(frm,
                              chunk_size = 1e2,
                              to_ignore = c(),
                              warn_if_missing=F) {
  #' Proper Noun Detection
  #'
  #' For a given data set, the function reports each detected instance of a proper
  #' noun and reports the location in the data set, the sentence containing the
  #' proper noun, and how often the sentence occurs.
  #'
  #' @param frm A data frame to check for proper nouns
  #' @param chunk_size [optional] The number of sentences to tag at a time.  The optimal value
  #'   has yet to be determined.
  #' @param to_ignore [optional] A vector of column names to be ignored by the algorithm.  
  #'   Intended to be used for variables that are giving strong false positives, such as
  #'   IDs or ICD-10 codes.
  #' @param warn_if_missing [optional] Raise a warning if the `to_ignore` columns are 
  #'   not in the data frame.
  #'
  #' @return A `pid_report` (inheriting from tibble) containing:
  #' \itemize{
  #'   \item `ID`: The location of the sentence in the data frame in the form `Col:<colname> Row:<rownumber>`.
  #'   \item `Token`: The detected proper noun.
  #'   \item `Sentence`: The sentence containing the proper noun.
  #'   \item `Repeats`: The number of times the sentence occurs in the data frame.
  #'   \item `Affected Columns`: The columns in the data frame where the sentence occurs.
  #' }
  #' If no proper nouns are detected, an empty data frame is returned.
  #'
  #' @examples
  #' data(the_one_in_massapequa)
  #' example.data <- head(the_one_in_massapequa, 10)
  #' try(
  #'   data_frame_report(example.data, to_ignore=c("scene", "utterance"))
  #' )
  #' @export
  #' @importFrom magrittr %>%
  #' @importFrom dplyr group_by group_modify left_join where all_of
  #' @importFrom dplyr rename select mutate
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom tibble as_tibble
  #' 
  
  frm_cols <- colnames(frm)
  cant_remove <- setdiff(to_ignore, frm_cols)
  
  if (warn_if_missing & (length(cant_remove) > 0)) {
    warning(
      glue(
        "The following columns to remove were not found in the data frame: {paste(cant_remove, collapse=', ')}"
      )
    )
  }
  
  tags <- data_frame_tagger(frm, chunk_size, to_ignore)

  report <- left_join(
    tags$`Proper Nouns`,
    tags$Sentences,
    by = "ID"
  ) %>%
    as_tibble() |>
    arrange(PK) |>
    rename(
      Token = token,
      Document = Sentence,
      Sentence = sentence
    ) |>
    select("ID", "Token", "Sentence", "Document", "Repeats", "Affected Columns")

  class(report) <- c("pid_report", class(report))
  report
}
