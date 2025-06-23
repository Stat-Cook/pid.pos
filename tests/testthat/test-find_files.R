# Tests for find_files.R


test_that("find_files() works", {
  local({
    temp_dir <- local_tempdir("dir")
    temp_file <- local_tempfile(tmpdir = temp_dir, fileext = ".csv")
    writeLines("foo", temp_file)

    temp_subdir <- local_tempdir(pattern = "dir", tmpdir = temp_dir)
    temp_subfile <- local_tempfile(tmpdir = temp_subdir, fileext = ".csv")
    writeLines("bar", temp_subfile)

    files <- find_files(temp_dir, extensions = ".csv")
    files <- map(files, as.character) |>
      map(~ str_replace_all(., "\\/", "\\\\"))

    expected <- list(temp_subfile, temp_file) |>
      map(~ str_replace_all(., "\\/", "\\\\"))

    expect_equal(files, expected)
  })
})

test_that("get_implemented_extensions() works", {
  .ext <- get_implemented_extensions()

  expect_equal(length(.ext), 4)
})



test_that("list_files_by_extension() works", {
  local({
    temp_dir <- local_tempdir("dir")
    temp_file <- local_tempfile(tmpdir = temp_dir, fileext = "csv")
    writeLines("foo", temp_file)

    files <<- list_files_by_extension("csv", temp_dir)

    map(
      files,
      expect_s3_class,
      "csv_path"
    )
  })
})

test_that("set_class() works", {
  i <- 1
  .class <- "foo"

  i <- set_class(i, .class)

  expect_s3_class(i, .class)
})

test_that("find_files() works with no files", {
  local({
    temp_dir <- local_tempdir("dir")

    files <- find_files(temp_dir, extensions = ".csv")

    expect_equal(files, list())
  })
})
