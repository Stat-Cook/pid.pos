test_that("get_context works", {
  
  .subset <- the_one_in_massapequa[101:110,]
  
  text.responses <- data_frame_report(.subset) |> 
    filter(`Affected Columns` == "`text`")
  
  context <- get_context(text.responses$Sentence, text.responses$Token)
  
  expect_equal(nrow(text.responses), length(context))
  
  expect_true(
    all(str_detect(context, text.responses$Token))
  )
  
  set_context_window(0)
  context.0 <- get_context(text.responses$Sentence, text.responses$Token)
  expect_true(
    all(context.0 != context)
  )
})
