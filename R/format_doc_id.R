format_doc_id <- function(docs, doc_id = NULL) {
  if (is.null(doc_id)) {
    doc_id <- seq_along(docs)
  }

  if (is.numeric(doc_id)) {
    doc_id <- paste("doc", doc_id, sep = "")
  }

  doc_id
}
