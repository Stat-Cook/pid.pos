test_that(
  "run a simple test",
  {
    expect_true(TRUE)
  }
)

test_that(
  "Test data frame tagger",
  {
    frm <- data.frame(
      A = 1:10,
      B = letters[1:10]
    )
    frm <- data_frame_tagger(frm)

    expect_true(nrow(frm$Sentences) == 10)
  }
)
