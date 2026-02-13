local({
  tagger <- udpipe_factory("english-ewt")
  stub(tagger, "udpipe::udpipe", fake_udpipe_success)
  
  test_that("tagger processes documents correctly", {
    result <- tagger("Test sentence")
    
    expect_s3_class(result, "tbl_df")
    expect_setequal(names(result),
                    c("ID", "token_id", "Token", "Sentence", "TokenNo"))
    expect_equal(result$Token, "Test")
    expect_equal(result$ID, "doc1")
  })
  
  test_that("tagger errors on non-character input", {
    expect_error(tagger(123), "`docs` must be a non-empty character vector.")
  })
  
  test_that("tagger errors on empty input", {
    expect_error(tagger(character(0)),
                 "`docs` must be a non-empty character vector.")
  })
})

test_that("tagger errors cleanly when UDPipe fails", {
  # Inject the failing fake
  tagger <- udpipe_factory(model = "english-ewt")
  stub(tagger, "udpipe::udpipe", fake_udpipe_failure)
  
  # Expect a controlled error with your custom message
  expect_error(tagger("This is a test."))
})

test_that("tagger can download model", {
  # Inject the failing fake
  tagger <- udpipe_factory(model = "english-ewt")
  # Expect a controlled error with your custom message
  result <- tagger("This is a test.")
  expect_equal(nrow(result), 5)
})
