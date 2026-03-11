test_redacter <- structure(
  function(x) x,
  class=c("redact_function", "function")
)

test_that("defensive layers produce errors",{
  expect_error(redact_at_folder("data_path", function(x) x, output_path = 12), "output_path") 
  expect_error(redact_at_folder("data_path", function(x) x, output_path = NULL), "output_path")
  expect_error(redact_at_folder("data_path", function(x) x, output_path = letters), "output_path")
  
  expect_error(redact_at_folder("data_path", function(x) x), "redacter")
  expect_error(redact_at_folder("data_path", 12), "redacter")

  expect_error(redact_at_folder("data_path", test_redacter), "data_path.*exist")
  expect_error(redact_at_folder(12, test_redacter), "data_path.*single string")
  

})


find_supported_files_mock <- function(data_path, extensions, verbose) "supported_files"
redact_supported_files_mock <- function(files_to_redact, output_path, redacter, export_function) files_to_redact

test_that("internals pass results",{
  mockery::stub(redact_at_folder, "find_supported_files", find_supported_files_mock)
  mockery::stub(redact_at_folder, "redact_supported_files", redact_supported_files_mock)

  expect_equal(redact_at_folder("data_path", test_redacter), "supported_files")
  
})
