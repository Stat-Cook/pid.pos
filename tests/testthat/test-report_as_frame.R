# Test for report_as_rules_template

test_that("report_to_replacement_rules", {
  local({
    .report <- head(the_one_in_massapequa, 10) |>
      data_frame_report()

    # Create a temporary file
    temp_file <- local_tempfile(fileext = ".csv")

    # Run the function
    .rules <- report_to_redaction_rules(.report, path = temp_file)

    # Check the file exists
    expect_true(file.exists(temp_file))

    # Check the file is not empty
    expect_true(file.size(temp_file) > 0)

    .rules_from_file <- prepare_redactions(temp_file)
    expect_type(.rules_from_file, "closure")

    .rules_from_file.parsed <- prepare_redactions(temp_file)
    expect_type(.rules_from_file.parsed, "closure")
  })
})


test_that("report_as_rules_template", {
  .data <- head(the_one_in_massapequa, 5)

  .rules <- data.frame(
    If = "Monica Geller",
    From = c("Monica", "Geller"),
    To = c("XXX", "YYY")
  )

  replacement.func <- redaction_function_factory(.rules)

  replaced.data <- .data |>
    mutate(
      across(
        where(is.character),
        replacement.func
      )
    )

  expect_true(
    all(!str_detect(replaced.data$speaker, "Monica"))
  )
  expect_true(
    all(!str_detect(replaced.data$speaker, "Monica Geller"))
  )
})
