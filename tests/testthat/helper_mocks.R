# Shared fake udpipe responses for testing

# Successful mock
fake_udpipe_success <- function(...) {
  data.frame(
    doc_id   = "doc1",
    token_id = 1,
    token    = "Test",
    sentence = "Test sentence",
    stringsAsFactors = FALSE
  )
}

# Failing mock
fake_udpipe_failure <- function(...) {
  stop("Model missing")
}
