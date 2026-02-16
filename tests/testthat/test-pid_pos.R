test_that("pid_pos returns pid_report", {
  mockery::stub(pid_pos, "tag_data_frame", fake_tag_data_frame)
  
  df <- data.frame(text = c("John went home.", "London is big."))
  
  result <- pid_pos(df)
  
  expect_s3_class(result, "pid_report")
  expect_s3_class(result, "tbl_df")
})

test_that("errors on invalid frm", {
  
  expect_error(
    pid_pos(123),
    "`frm` must be a data frame"
  )
})

test_that("errors if filter_func not function", {
  
  expect_error(
    pid_pos(data.frame(text="x"), filter_func = 123),
    "`filter_func` must be a function"
  )
})

test_that("warns if to_ignore missing and warn_if_missing TRUE", {
  
  mockery::stub(pid_pos, "tag_data_frame", fake_tag_data_frame)
  
  df <- data.frame(text = "John")
  
  expect_warning(
    pid_pos(df, to_ignore = "not_a_column", warn_if_missing = TRUE),
    "were not found"
  )
})

fake_empty_tag_data_frame <- function(...) {
  list(AllTags = NULL, Documents = NULL)
}

test_that("returns empty pid_report if no tags", {
  
  mockery::stub(pid_pos, "tag_data_frame", fake_empty_tag_data_frame)
  
  df <- data.frame(text = "Nothing")
  
  result <- pid_pos(df)
  
  expect_s3_class(result, "pid_report")
  expect_equal(nrow(result), 0)
})
