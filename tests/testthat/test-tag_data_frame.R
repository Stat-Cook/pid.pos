fake_tag_documents <- function(docs, doc_ids, tagger, chunk_size) {
  tibble::tibble(
    ID = doc_ids,
    Token = docs,
    TokenNo = seq_along(docs)
  )
}


test_that("tag_data_frame returns expected structure", {
  mockery::stub(tag_data_frame, "tag_documents", fake_tag_documents)

  df <- data.frame(
    text1 = c("Hello", "World"),
    text2 = c("Test", "Data"),
    num = 1:2
  )

  result <- tag_data_frame(df)

  expect_type(result, "list")
  expect_named(result, c("AllTags", "Documents"))
  expect_s3_class(result$AllTags, "tbl_df")
  expect_s3_class(result$Documents, "tbl_df")
})

test_that("non-character columns are ignored", {
  mockery::stub(tag_data_frame, "tag_documents", fake_tag_documents)

  df <- data.frame(
    text = c("A", "B"),
    number = 1:2
  )

  result <- tag_data_frame(df)

  expect_true(all(result$Documents$Document %in% c("A", "B")))
})

test_that("to_ignore excludes specified columns", {
  mockery::stub(tag_data_frame, "tag_documents", fake_tag_documents)

  df <- data.frame(
    text1 = c("A", "B"),
    text2 = c("C", "D")
  )

  result <- tag_data_frame(df, to_ignore = "text2")

  expect_false(any(result$Documents$Document %in% c("C", "D")))
})

test_that("returns NULL components if no character columns", {
  df <- data.frame(x = 1:3, y = 4:6)

  result <- tag_data_frame(df)

  expect_null(result$AllTags)
  expect_null(result$Documents)
})

test_that("invalid inputs error", {
  expect_error(
    tag_data_frame(123),
    "`frm` must be a data frame"
  )

  expect_error(
    tag_data_frame(data.frame(x = "a"), chunk_size = 0),
    "`chunk_size` must be a positive integer"
  )
})

test_that("character tagger is accepted", {
  mockery::stub(tag_data_frame, "tag_documents", fake_tag_documents)
  mockery::stub(tag_data_frame, "udpipe_factory", function(x) function(...) {})

  df <- data.frame(text = c("A", "B"))

  expect_type(tag_data_frame(df, tagger = "english-ewt"), "list")
})
