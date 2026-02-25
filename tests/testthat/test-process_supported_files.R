# Mock all external dependencies
mock_udpipe_factory <- function(tagger) function(vec) vec
mock_read_data <- function(file) data.frame(text = c("Alice", "Bob"))
mock_pid_pos <- function(frm, ...) paste0("report_", nrow(frm))
mock_export_as_tree <- function(report, name, path) paste0("exported_", name)

# Begin test suite
test_that("process_supported_files runs with default parameters", {
  
  # Create a temporary report path
  tmp_dir <- tempdir()
  
  # Mock dependencies inside the function
  stubbed_process <- process_supported_files
  mockery::stub(stubbed_process, "udpipe_factory", mock_udpipe_factory)
  mockery::stub(stubbed_process, "read_data", mock_read_data)
  mockery::stub(stubbed_process, "pid_pos", mock_pid_pos)
  mockery::stub(stubbed_process, "export_as_tree", mock_export_as_tree)
  
  # Minimal input
  file_list <- list("file1.txt", "file2.txt")
  
  result <- stubbed_process(file_list, tmp_dir)
  
  # If nothing crashes, function works with defaults
  expect_true(TRUE)
})

test_that("process_supported_files uses custom tagger and export function", {
  
  tmp_dir <- tempdir()
  
  custom_tagger <- function(vec) paste("tagged", vec)
  custom_export <- mockery::mock("called_export")
  
  stubbed_process <- process_supported_files
  mockery::stub(stubbed_process, "read_data", mock_read_data)
  mockery::stub(stubbed_process, "pid_pos", mock_pid_pos)
  
  file_list <- list("file1.txt")
  
  stubbed_process(file_list, tmp_dir, tagger = custom_tagger, export_function = custom_export)
  
  # Ensure export function was called
  mockery::expect_called(custom_export, 1)
})

test_that("process_supported_files catches errors in processing", {
  
  tmp_dir <- tempdir()
  
  error_read <- function(file) stop("Read error!")
  
  stubbed_process <- process_supported_files
  mockery::stub(stubbed_process, "read_data", error_read)
  
  file_list <- list("file1.txt")
  
  expect_warning(
    stubbed_process(file_list, tmp_dir),
    "Failed processing a data frame"
  )
})