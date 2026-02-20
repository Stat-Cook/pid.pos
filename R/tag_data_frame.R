#' Tags a data frame with part of speech tags
#'
#' @param frm A data frame to tag
#' @param tagger Either a string naming a UDPipe model (see `udpipe_factory` for the list of models)
#'   or a custom tagging function (see `udpipe_factory` for details of what is required).
#' @param chunk_size The number of sentences to tag at a time
#' @param to_ignore A character vector of column names to remove from the data frame
#'
#' @importFrom dplyr group_by group_modify row_number ungroup
#' @importFrom glue glue
#' @importFrom progress progress_bar
#' @importFrom dplyr where all_of filter
#' @importFrom purrr simplify
#' @importFrom tidyr pivot_longer
#' @importFrom rlang :=
#'
#' @return A list with two elements:
#' \describe{
#'   \item{AllTags}{A tibble of token-level annotations}
#'   \item{Documents}{A tibble describing the processed documents}
#' }
#' 
#' @export
#' 
#' @examples
#' example.data <- head(the_one_in_massapequa, 20)
#'
#' tag_data_frame(example.data, tagger = "english-ewt")
#' tag_data_frame(example.data, tagger = "english-gum")
#' tag_data_frame(example.data, tagger = "english-lines")
#'
#' ewt_tagger <- udpipe_factory("english-ewt")
#' tag_data_frame(example.data, tagger = ewt_tagger)
#'
#' gum_tagger <- udpipe_factory("english-gum")
#' tag_data_frame(example.data, tagger = gum_tagger)
#'
#' lines_tagger <- udpipe_factory("english-lines")
#' tag_data_frame(example.data, tagger = lines_tagger)
tag_data_frame <- function(frm,
                           tagger = "english-ewt",
                           chunk_size = 1e2,
                           to_ignore = character()) {
  if (!is.data.frame(frm)) {
    type_error("`frm` must be a data frame.")
  }

  if (!is.numeric(chunk_size) || chunk_size < 1) {
    type_error("`chunk_size` must be a positive integer.")
  }

  if (is.character(tagger)) {
    .tagger <- udpipe_factory(tagger)
  } else {
    .tagger <- tagger
  }

  character_frm <- frm %>%
    select(where(is.character)) %>%
    remove_if_exists(to_ignore)

  if (!nrow(character_frm) || !ncol(character_frm)) {
    return(list(
      AllTags = NULL,
      Documents = NULL
    ))
  }

  new_col <- make_unique_col(character_frm)

  doc_grid <- character_frm %>%
    mutate("{new_col}" := dplyr::row_number()) %>%
    pivot_longer(-all_of(new_col), names_to = "Column", values_to = "Document") |>
    rename(Row = all_of(new_col)) |>
    mutate(PK = row_number())

  document_frm <- group_by(doc_grid, .data$Document) %>%
    group_modify(summarize_repeated_sentences) |>
    ungroup() |>
    mutate(ID = glue("Col:{Column} Row:{Row}")) |>
    dplyr::select(.data$Document, .data$ID, .data$Repeats, 
                  .data$`Affected Columns`, .data$PK)

  tag_frm <- tag_documents(
    document_frm$Document,
    doc_ids = document_frm$ID,
    tagger = .tagger,
    chunk_size = chunk_size
  )

  list(AllTags = tag_frm, Documents = document_frm)
}
