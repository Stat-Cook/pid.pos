# Test for Proper Noun Report

test_that("proper_noun_report - test functionality", {
  report <- proper_noun_report(sentence_frm$Sentence)
  
  expect_type(report, "list")
  expect_s3_class(report$`Proper Nouns`, "data.frame")  
  
  expect_equal(nrow(report$`Proper Nouns`), 3)  
  expect_equal(colnames(report$`Proper Nouns`), 
               c("Token", "doc_id", "paragraph_id", "Context")) 
  

  expect_true("Peter" %in% report$`Proper Nouns`$Token)
  expect_true("Jane" %in% report$`Proper Nouns`$Token)
  expect_true("John" %in% report$`Proper Nouns`$Token)
  
})
