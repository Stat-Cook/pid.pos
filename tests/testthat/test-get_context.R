test_that("get_context works", {
  expect_match(
    get_context("This is a sentence to be tested", "sentence"),
    "This is a sentence to be tested"
  )
  
  expect_equal(
    get_context("This is a sentence to be tested", "sentence", 2),
    "...a sentence t..."
  )
  
  set_context_window(2)
  
  expect_equal(
    get_context("This is a sentence to be tested", "sentence"),
    "...a sentence t..."
  )
  
  set_context_window(25)
  
})
  