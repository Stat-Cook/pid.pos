# Test for report_as_rules_template

test_that("report_as_rules_template", {
  local({
    .report <- head(the_one_in_massapequa, 10) |>
      data_frame_report()

    # Create a temporary file
    temp_file <- local_tempfile(fileext = ".csv")
    
    # Run the function
    .rules <- report_as_rules_template(.report, path = temp_file)

    # Check the file exists
    expect_true(file.exists(temp_file))
    
    # Check the file is not empty
    expect_true(file.size(temp_file) > 0)
    
    .rules_from_file <- template_to_rules(temp_file)
    expect_type(.rules_from_file, "character")
  
    .rules_from_file.parsed <- template_to_rules(temp_file, parse = T)
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
  
  replacement.func <- frame_to_rules(.rules, parse = T)
  
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
