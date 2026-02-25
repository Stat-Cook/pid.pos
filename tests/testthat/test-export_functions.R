test_that("export_as_tree writes CSV and returns correct path", {
  tmp <- withr::local_tempdir()
  
  report <- data.frame(a = 1:3, b = letters[1:3])
  path <- export_as_tree(report, "test_report", tmp)
  
  expect_true(file.exists(path))
  expect_equal(
    path,
    file.path(tmp, "test_report.csv")
  )
  
  # Check contents
  read_back <- read.csv(path)
  expect_equal(read_back, report)
})

test_that("export_as_tree creates nested directories if needed", {
  tmp <- withr::local_tempdir()
  nested_path <- file.path(tmp, "a", "b", "c")
  
  report <- data.frame(x = 1)
  path <- export_as_tree(report, "nested", nested_path)
  
  expect_true(dir.exists(nested_path))
  expect_true(file.exists(path))
})

test_that("export_as_tree overwrites existing file", {
  tmp <- withr::local_tempdir()
  
  report1 <- data.frame(x = 1)
  report2 <- data.frame(x = 2)
  
  path <- export_as_tree(report1, "overwrite_test", tmp)
  path <- export_as_tree(report2, "overwrite_test", tmp)
  
  read_back <- read.csv(path)
  expect_equal(read_back, report2)
})

test_that("export_flat replaces forward slashes with underscores", {
  tmp <- withr::local_tempdir()
  
  report <- data.frame(x = 1)
  path <- export_flat(report, "a/b/c", tmp)
  
  expect_equal(
    basename(path),
    "a_b_c.csv"
  )
})

test_that("export_flat writes valid CSV", {
  tmp <- withr::local_tempdir()
  
  report <- data.frame(x = 42)
  path <- export_flat(report, "flat/test", tmp)
  
  expect_true(file.exists(path))
  expect_equal(read.csv(path), report)
})