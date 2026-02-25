test_that("find_supported_files finds correct files", {
  tmp <- withr::local_tempdir()

  # Create files
  file.create(file.path(tmp, "a.csv"))
  file.create(file.path(tmp, "b.rds"))
  file.create(file.path(tmp, "c.txt")) # unsupported
  dir.create(file.path(tmp, "sub"), recursive = FALSE)
  file.create(file.path(tmp, "sub", "d.csv"), recursive = TRUE)

  # Stub file readers for testing
  old_readers <- pid.pos_env$file_readers
  pid.pos_env$file_readers <- list(csv = TRUE, rds = TRUE)

  extensions <- get_implemented_extensions()

  files <- find_supported_files(tmp, extensions = extensions, verbose = FALSE)

  # Tests
  expect_type(files, "character")
  expect_length(files, 3)
  expect_true(all(tools::file_ext(files) %in% c("csv", "rds")))
  expect_true(all(names(files) != "")) # named vector

  normalized_files <- normalizePath(files, winslash = "/")
  normalized_tmp <- normalizePath(tmp, winslash = "/")

  expect_true(all(grepl(normalized_tmp, normalized_files))) # normalized paths

  # restore
  reinstate_default_reader()
})


test_that("unsupported files are ignored", {
  tmp <- withr::local_tempdir()
  file.create(file.path(tmp, "unsupported.xyz"))
  file.create(file.path(tmp, "unsupported.csv"))

  pid.pos_env$file_readers <- list(csv = TRUE)

  expect_message(
    find_supported_files(tmp, verbose = TRUE),
    "Ignored files"
  )
  reinstate_default_reader()
})


test_that("empty folder warns", {
  tmp <- withr::local_tempdir()

  pid.pos_env$file_readers <- list(csv = TRUE)

  expect_warning(
    find_supported_files(tmp),
    "No supported files found"
  )

  reinstate_default_reader()
})
