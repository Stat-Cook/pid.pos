test_that("errors if data_path does not exist", {
  expect_error(
    report_on_folder("does/not/exist"),
    "data_path does not exist"
  )
})

test_that("creates report_dir if it does not exist", {
  input_dir  <- withr::local_tempdir()
  dir.create(input_dir, showWarnings = FALSE)
  
  output_dir <- file.path(input_dir, "reports")
  
  mockery::stub(report_on_folder, "find_supported_files", function(...) character(0))
  mockery::stub(report_on_folder, "process_supported_files", function(...) character(0))
  
  report_on_folder(input_dir, report_dir = output_dir)
  
  expect_true(dir.exists(output_dir))
})

test_that("calls process_supported_files with supported files", {
  input_dir <- local_tempdir()
  dir.create(input_dir, showWarnings = FALSE)
  
  fake_files <- c("a.csv", "b.csv")
  fake_output <- c("out/a.csv", "out/b.csv")

  mockery::stub(report_on_folder, "find_supported_files", function(...)  fake_files)
  mockery::stub(report_on_folder, "process_supported_files", function(files, ...) {
    expect_equal(files, fake_files)
    fake_output
  })
  
  result <- report_on_folder(
    input_dir,
    report_dir = local_tempdir()
  )
  
  expect_equal(result, fake_output)
})


test_that("passes arguments through correctly", {
  input_dir <- local_tempdir()
  dir.create(input_dir, showWarnings = FALSE)
  
  mockery::stub(report_on_folder, "find_supported_files", function(...)  character(0))
  
  mocked_process_supported_files <- function(files,
                                             report_dir,
                                             tagger,
                                             filter_func,
                                             chunk_size,
                                             to_ignore,
                                             export_function) {
    expect_equal(tagger, "custom")
    expect_equal(chunk_size, 50)
    expect_equal(to_ignore, c("ignore"))
    expect_identical(export_function, identity)
    
    character(0)
  }
  
  mockery::stub(report_on_folder, "process_supported_files", mocked_process_supported_files)

  report_on_folder(
    input_dir,
    report_dir = local_tempdir(),
    tagger = "custom",
    chunk_size = 50,
    to_ignore = c("ignore"),
    export_function = identity
  )
})

test_that("returns invisibly", {
  input_dir <- local_tempdir()
  dir.create(input_dir, showWarnings = FALSE)
  
  mockery::stub(report_on_folder, "find_supported_files", function(...)  character(0))
  mockery::stub(report_on_folder, "process_supported_files", function(...) "output")
  
  expect_invisible(
    result <- report_on_folder(input_dir, report_dir = local_tempdir())
  )
  
  expect_equal(result, "output")
})
