test_that("make and merge replacements workflow", {

  report <- data_frame_report(the_one_in_massapequa)

  .rules <- report_to_replacement_rules(
    report
  )
  
  .replacer <- random_replacement.f()
  
  .rules.replaced <- auto_replace(.rules, .replacer)
  
  .replacements <- make_replacements(.rules.replaced)
  
  .new <- merge_replacements(the_one_in_massapequa,
                     .replacements
  )

  expect_true(any(.new$speaker != the_one_in_massapequa$speaker))
  
})


