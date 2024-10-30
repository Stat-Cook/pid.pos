test_that("Ticker works",{
  .tick <- Ticker$new()
  
  expect_equal(.tick$X, 0)
  
  expect_output(.tick$tick())
  expect_equal(.tick$X, 1)
  
  capture_output(.tick$tick())
  expect_equal(.tick$X, 2)
  
  .tick$reset()
  expect_equal(.tick$X, 0)
  
  capture_output(.tick$tick())
  expect_equal(.tick$X, 1)
})
