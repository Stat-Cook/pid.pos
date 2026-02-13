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
  stop("model missing")
}