# Shared fake udpipe responses for testing

# Successful mock
fake_udpipe_success <- function(...) {
  data.frame(
    doc_id   = "doc1",
    token_id = 1,
    token    = "Test",
    sentence = "Test sentence",
    upos = "XXX",
    stringsAsFactors = FALSE
  )
}

# Failing mock
fake_udpipe_failure <- function(...) {
  stop("Model missing")
}

fake_udpipe_file_not_found_failure <- function(...) {
  stop("File not found: ... does not exist.")
}

# Fake tagger function
fake_tagger <- function(docs, ids) {
  tibble::tibble(
    ID = ids,
    Token = docs, 
    Sentence = docs, 
    upos = "XXX"
  )
}

# Fake tagger function
fake_tagger_failure <- function(docs, ids) {
  stop("Model missing")
}

fake_tag_data_frame <- function(frm, tagger, chunk_size, to_ignore) {
  list(
    AllTags = tibble::tibble(
      ID = c("Col:text Row:1", "Col:text Row:2"),
      Token = c("John", "London"),
      Sentence = c("John went home.", "London is big."),
      upos = c("XXX", "PROPN"),
      PK = 1:2
    ),
    Documents = tibble::tibble(
      ID = c("Col:text Row:1", "Col:text Row:2"),
      Document = c("John went home.", "London is big."),
      Repeats = c(1, 1),
      `Affected Columns` = c("text", "text"),
      PK = 1:2
    )
  )
}
