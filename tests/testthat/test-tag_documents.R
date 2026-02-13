test_that("tag_documents returns correct tibble structure", {
  # Stub the udpipe call inside the tagger
  
  result <- tag_documents(the_one_in_massapequa$text, tagger = fake_tagger)
  
  expect_s3_class(result, "tbl_df")
  
  expected_cols <- c("ID", "Token", "Sentence", "upos")
  present <- expected_cols %in% names(result)
  expect_true(all(present))
  
})

test_that("tag_documents correctly splits into chunks", {
  docs <- letters[1:5]
  result <- tag_documents(docs, tagger = fake_tagger, chunk_size = 2)
  
  expect_equal(nrow(result), 5)
  expect_equal(result$Sentence, docs)
})

test_that("tag_documents validates inputs", {
  expect_error(
    tag_documents(123, tagger = fake_tagger),
    "`docs` must be a non-empty character vector"
  )
  
  expect_error(
    tag_documents(character(0), tagger = fake_tagger),
    "`docs` must be a non-empty character vector"
  )
  
  expect_error(
    tag_documents("test", tagger = fake_tagger, chunk_size = 0),
    "`chunk_size` must be a positive integer"
  )
})

test_that("tag_documents propagates tagger errors", {
  expect_error(tag_documents("test", tagger = fake_tagger_failure),
               "model missing")
  
  tagger <- udpipe_factory()
  stub(tagger, "udpipe::udpipe", fake_udpipe_failure)
  
  expect_error(tag_documents("test", tagger = tagger),
               ".*Original error: Model missing.*")
})
