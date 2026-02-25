redaction_function <- structure(function(x)
  x, class = "redaction_function")

mock_read_data <- function(file){
  data.frame(text = c("Alice", "Bob"))
} 

mock_export_as_tree <- function(df, name, path){
  paste0("exported_", name)
} 

mock_redact <- function(df, redacter){
  paste0("redacted_", nrow(df))
} 

mock_parse_redacter <- function(redacter){
  function(df)  redaction_function
} 

test_that("redact_supported_files runs with default export_function", {
  tmp_dir <- tempdir()
  file_list <- list("file1.txt", "file2.txt")
  
  f <- redact_supported_files
  
  # Stub dependencies
  mockery::stub(f, "parse_redacter", function(redacter)
    function(df)
      redaction_function)
  mockery::stub(f, "read_data", mock_read_data)
  mockery::stub(f, "redact", mock_redact)
  mockery::stub(f, "export_as_tree", mock_export_as_tree)
  
  result <- f(file_list, tmp_dir, redacter = redaction_function)
  
  expect_true(TRUE) # passes if no error
})

test_that("redact_supported_files uses custom export_function", {
  tmp_dir <- tempdir()
  file_list <- list("file1.txt")
  
  custom_export <- mockery::mock("called_export")
  
  mockery::stub(redact_supported_files, "parse_redacter", function(redacter)
    function(df)
      redaction_function)
  mockery::stub(redact_supported_files, "read_data", mock_read_data)
  mockery::stub(redact_supported_files, "redact", mock_redact)
  
  redact_supported_files(file_list,
    tmp_dir,
    redacter = redaction_function,
    export_function = custom_export)
  
  mockery::expect_called(custom_export, 1)
})

test_that("redact_supported_files handles errors in read_data", {
  tmp_dir <- tempdir()
  file_list <- list("file1.txt")
  
  error_read <- function(file)
    stop("Read error!")
  
  f <- redact_supported_files
  mockery::stub(f, "parse_redacter", function(redacter)
    function(df)
      redaction_function)
  mockery::stub(f, "read_data", error_read)
  mockery::stub(f, "redact", mock_redact)
  mockery::stub(f, "export_as_tree", mock_export_as_tree)
  
  expect_warning(
    f(file_list, tmp_dir, redacter = redaction_function),
    "Failed processing a data frame"
  )
})