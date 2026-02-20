#' Filter a tagged data frame to proper nouns
#'
#' @param tag_frm A data frame containing at least the columns
#'   `upos`, `ID`, `Token`, and `Sentence`.
#'
#' @return A tibble containing only rows where `upos == "PROPN"`,
#'   with columns `ID`, `Token`, and `Sentence`.
#'
#' @export
#'
#' @examples
#' example.data <- head(the_one_in_massapequa, 20)
#' tagged <- tag_data_frame(example.data, tagger = "english-ewt")
#' filter_to_proper_nouns(tagged$`AllTags`)
#'
filter_to_proper_nouns <- function(tag_frm) {
  required_cols <- c("upos", "ID", "Token", "Sentence")

  if (!is.data.frame(tag_frm)) {
    type_error("`tag_frm` must be a data frame.")
  }

  missing_cols <- setdiff(required_cols, names(tag_frm))
  if (length(missing_cols) > 0) {
    validation_error(
      paste("Missing required columns:", paste(missing_cols, collapse = ", "))
    )
  }

  tag_frm %>%
    dplyr::filter(.data$upos == "PROPN") %>%
    dplyr::select(all_of(c("ID", "Token", "Sentence")))
}
