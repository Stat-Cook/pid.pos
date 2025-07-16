test_that("summary works", {
  report <- data_frame_report(the_one_in_massapequa)
  .summary <- summary(report)

  expect_equal(nrow(.summary), 2)
  expect_equal(ncol(.summary), 4)
})
