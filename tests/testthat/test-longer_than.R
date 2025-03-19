# test longer_than

test_that("longer_than", {
  # test that longer_than works

  longer_than_5 <- longer_than(5)
  
  expect_type(longer_than_5, "closure")
    
  expect_true(
    longer_than_5(c("ABCDE", "ABC", "ABCDEFG"))
  )
  
  expect_false(
    longer_than(5)(c("ABC", "ABC", "DEF", NA))
  )
  
})
