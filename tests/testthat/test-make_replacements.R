test_that("make and merge replacements workflow", {
  report <- data_frame_report(the_one_in_massapequa)

  .rules <- report_to_redaction_rules(
    report
  )

  .replacer <- random_replacement.f()

  .rules.replaced <- auto_replace(.rules, .replacer)

  redactions <- prepare_redactions(.rules.replaced)

  .new <- the_one_in_massapequa |>
    mutate(across(
      where(is.character),
      ~ redactions(.x)
    ))

  expect_true(any(.new$speaker != the_one_in_massapequa$speaker))
})
