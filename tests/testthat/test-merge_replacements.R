test_that("merge_redactions works", {
  vec <- c(letters, LETTERS)

  cached_redactions <- data.frame(If = letters, Then = "XXX")

  redacted.vec <- vector_merge_redactions(vec, cached_redactions)

  expect_true(all(
    str_detect("[a-z]", redacted.vec, T)
  ))

  raw.frm <- data.frame(Lower = letters, Upper = LETTERS)
  redacted.frm <- raw.frm |>
    merge_redactions(cached_redactions)

  expect_true(all(
    str_detect("[a-z]", redacted.frm$Lower, T)
  ))
})
