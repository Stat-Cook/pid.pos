# Unit tests for data_frame_tagger

test_that("data_frame_tagger works", {
  # test that the function works
  res <- data_frame_tagger(sentence_frm)
  expect_type(res, "list")
})

test_that("data_frame_tagger returns expected names", {
  # test that the function returns the expected results

  res <- data_frame_tagger(sentence_frm)
  expect_equal(names(res), c("All Tags", "Proper Nouns", "Sentences"))
})

test_that("data_frame_tagger - correct size", {
  # test that the function returns the expected results

  res <- data_frame_tagger(sentence_frm)

  expect_equal(nrow(res$`All Tags`), 18)
  expect_equal(nrow(res$`Proper Nouns`), 3)
  expect_equal(nrow(res$`Sentences`), 5)
})

test_that("data_frame_tagger: correct size with `to_remove`", {
  # test that the function returns the expected results

  res <- data_frame_tagger(sentence_frm, to_remove = c("Random", "Numeric"))

  expect_equal(nrow(res$`All Tags`), 18)
  expect_equal(nrow(res$`Proper Nouns`), 3)
  expect_equal(nrow(res$`Sentences`), 5)
})
