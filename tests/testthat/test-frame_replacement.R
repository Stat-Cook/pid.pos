test_that("frame_replacement works", {
  last100 <- tail(the_one_in_massapequa, 100)

  rules.frm <- data.frame(
    If = "Rachel Green",
    From = c("Rachel", "Green"),
    To = c("XXX", "YYY")
  )


  .redacted <- frame_replacement(last100, rules.frm)

  expect_equal(
    sum(str_detect(.redacted$speaker, "Rachel Green")),
    0
  )
})
