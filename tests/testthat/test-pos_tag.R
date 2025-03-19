# POS tag tests

test_that("POS tagger works", {
  tagged <- pos_tag(sentence_frm$Sentence)
  expect_s3_class(tagged, "data.frame")

  expect_equal(nrow(tagged), 18)
  expect_equal(ncol(tagged), 18)
  
})


test_that("chunked POS tagger works", {
  tagged <- chunked_pos_tag(sentence_frm$Sentence)
  expect_type(tagged, "list")
  
  tagged.frm <- reduce(tagged, rbind)
  
  
  expect_equal(nrow(tagged.frm), 18)
  expect_equal(ncol(tagged.frm), 18)
})


test_that("POS tagger can error", {
  
  expect_error(
    pos_tag(sentence_frm$Sentence, "FAIL"),
    regexp = ".*Please run `browse_model_location\\(\\)`.*"
  )
  
  expect_error(
    pos_tag(sentence_frm$Sentence, "FAIL", catch=F)
  )
  
})
