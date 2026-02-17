# Dummy POS functions for testing
dummy_pos <- function(doc) {
  tibble::tibble(word = unlist(strsplit(doc, " ")), pos = "NN")
}

dummy_empty <- function(doc) {
  if (nchar(doc) == 0) {
    tibble::tibble(word = character(), pos = character())
  } else {
    tibble::tibble(word = unlist(strsplit(doc, " ")), pos = "NN")
  }
}

# Wrap the dummy POS functions
tagger <- custom_tagger(dummy_pos)
tagger_empty <- custom_tagger(dummy_empty)

# Sample documents
docs <- c("This is one", "Another doc")
docs_special <- c("Hello, world!", "R&D is fun")

test_that("basic functionality works", {
  res <- tagger(docs)

  expect_equal(nrow(res), sum(sapply(strsplit(docs, " "), length)))

  expect_true(all(c("word", "pos", "doc_id") %in% colnames(res)))

  expect_true(all(res$doc_id %in% 1:2))
})

test_that("custom doc_ids are used", {
  res_custom <- tagger(docs, doc_ids = c(10, 20))
  expect_true(all(res_custom$doc_id %in% c(10, 20)))
})

test_that("POS function returning empty data frame is handled", {
  res_edge <- tagger_empty(c("Test", ""))
  expect_equal(nrow(res_edge), 1) # only one word from non-empty doc
  expect_true(all(c("word", "pos", "doc_id") %in% colnames(res_edge)))
})

test_that("special characters are handled", {
  res_special <- tagger(docs_special)
  expect_true(all(c("word", "pos", "doc_id") %in% colnames(res_special)))
  expect_equal(sum(res_special$doc_id == 1), length(unlist(strsplit(docs_special[1], " "))))
})

test_that("results are consistent across multiple runs", {
  res1 <- tagger(docs)
  res2 <- tagger(docs)
  expect_identical(res1, res2)
})

test_that("type check warnings", {
  expect_error(custom_tagger(12))
  expect_error(custom_tagger("12"))

  expect_error(custom_tagger(function() 12), "at least one argument")
  expect_error(custom_tagger(function(a, b) 12), "can't have more than one")
})
