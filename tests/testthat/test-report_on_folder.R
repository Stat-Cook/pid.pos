test_that(
  "report_on_folder full flow",
  {
    dir <- test_path()
    test_data_dir <- file.path(dir, "test_data")

    report_on_folder(test_data_dir)

    expect_true(T)
  }
)


