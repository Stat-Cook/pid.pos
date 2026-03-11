#' Tag a set of documents
#'
#' `tag_documents()` applies a tagging function (defaulting to a `udpipe_factory()`) to a
#' vector of text documents, optionally splitting them into chunks for memory efficiency.
#' The function returns a tibble containing tokens, sentences, and token-level metadata.
#'
#' @param docs Character vector. The text documents to tag. Must be non-empty.
#' @param doc_ids Character vector or NULL. Optional document identifiers; if NULL,
#'   default IDs will be generated.
#' @param tagger Function. A tagging function, typically created with
#'   `udpipe_factory()`.
#' @param chunk_size Integer. Number of documents to process per batch. Defaults to 100.
#'
#' @return A tibble (`tbl_df`) with columns depending on `tagger`s output.
#'
#' @keywords internal
#'
#' @examples
#' # Sample text
#' example_text <- c(
#'   "This is a test sentence.",
#'   "Here is another sentence."
#' )
#'
#' # Create a tagger for the English EWT model
#' ewt_tagger <- udpipe_factory("english-ewt")
#' ewt_result <- pid.pos:::tag_documents(example_text, tagger = ewt_tagger)
#'
#' # Create a tagger for the English GUM model
#' gum_tagger <- udpipe_factory("english-gum")
#' gum_result <- pid.pos:::tag_documents(example_text, tagger = gum_tagger)
#'
#' # Create a tagger for the English LINES model
#' lines_tagger <- udpipe_factory("english-lines")
#' lines_result <- pid.pos:::tag_documents(example_text, tagger = lines_tagger)
#'
tag_documents <- function(docs,
                          doc_ids = NULL,
                          tagger = NULL,
                          chunk_size = 100) {
  if (!is.character(docs) || length(docs) == 0) {
    type_error("`docs` must be a non-empty character vector.")
  }

  if (!is.numeric(chunk_size) || chunk_size < 1) {
    type_error("`chunk_size` must be a positive integer.")
  }

  if (is.null(tagger)) {
    tagger <- udpipe_factory()
  }

  doc_ids <- format_doc_id(docs, doc_ids)

  splits <- ceiling(seq_along(docs) / chunk_size)

  chunks <- split(docs, splits)
  id_chunks <- split(doc_ids, splits)

  tagged <- map2(chunks, id_chunks, tagger,
    .progress = T
  )

  dplyr::bind_rows(tagged)
}
