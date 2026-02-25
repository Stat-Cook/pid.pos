test_that("register_reader validates arguments and adds function", {
  # Save original readers
  original_readers <- pid.pos_env$file_readers
  pid.pos_env$file_readers <- list()
  on.exit(pid.pos_env$file_readers <- original_readers, add = TRUE)
  
  # Invalid extension type
  expect_error(register_reader(function(x) x, 1), "Extension must be a single character string")
  expect_error(register_reader(function(x) x, c("csv", "txt")), "Extension must be a single character string")
  
  # Invalid function
  expect_error(register_reader("not_a_function", "csv"), "The reader must be a function")
  
  # Valid function assignment
  fun <- function(path) data.frame(x = 1)
  expect_silent(register_reader(fun, "csv"))
  pid.pos_env$file_readers
  expect_true("csv" %in% names(pid.pos_env$file_readers))
  expect_identical(pid.pos_env$file_readers$csv, fun)
})
