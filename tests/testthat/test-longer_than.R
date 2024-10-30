test_that(
  "Test longer_than gives true",
  {
    longer_than_5 <- longer_than(5)
    .str <- c("ABCDE", "ABC", "ABCDEFG")
    .result <- longer_than_5(.str)
    expect_true(.result)
  }
)

test_that(
  "Test longer_than gives false",
  {
    longer_than_5 <- longer_than(5)
    .str <- c("ABCD", "ABC", "AB")
    .result <- longer_than_5(.str)
    expect_false(.result)
  }
)
