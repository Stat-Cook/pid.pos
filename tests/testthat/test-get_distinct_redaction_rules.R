

# Mock get_context
get_context <- function(sentence, token) {
  paste0("context_", token)
}

# Mock report_to_redaction_rules uses include_context
report_to_redaction_rules <- function(report, include_context = FALSE) {
  df <- tibble::tibble(If = report$Sentence,
                       From = report$Token,
                       To = report$Token)
  if (include_context)
    df$Context <- map2(df$If, df$From, get_context)
  df
}

test_that("data.frame method returns correct redaction rules", {
  df <- tibble::tibble(Sentence = c("a b c", "d e f"),
                       Token = c("b", "e"))
  
  out <- get_distinct_redaction_rules(df, include_context = TRUE)
  
  expect_s3_class(out, "data.frame")
  expect_named(out, c("If", "From", "To", "Context"))
  expect_equal(nrow(out), 2)
})

test_that("list method combines multiple reports and deduplicates", {
  df1 <- tibble::tibble(Sentence = c("a b", "c d"), Token = c("b", "d"))
  df2 <- tibble::tibble(Sentence = c("a b", "e f"), Token = c("b", "f"))
  
  out <- get_distinct_redaction_rules(list(df1, df2))
  expect_equal(nrow(out), 3)  # "a b" / "c d" / "e f"
})

test_that("character method reads files and returns redaction rules", {
  tmp <- withr::local_tempdir()
  f1 <- file.path(tmp, "r1.csv")
  f2 <- file.path(tmp, "r2.csv")
  
  readr::write_csv(tibble::tibble(Sentence = c("a b", "c d"), Token = c("b", "d")), f1)
  readr::write_csv(tibble::tibble(Sentence = c("a b", "e f"), Token = c("b", "f")), f2)
  
  out <- get_distinct_redaction_rules(tmp)
  expect_s3_class(out, "data.frame")
  expect_equal(sort(out$If), sort(c("a b", "c d", "e f")))
})

test_that("character method errors if folder has no CSV files", {
  tmp <- withr::local_tempdir()
  dir.create(tmp, showWarnings = FALSE)
  
  expect_warning(expect_error(
    get_distinct_redaction_rules(tmp),
    "No supported files found"
  ))
})

test_that("include_context propagates correctly", {
  df <- tibble::tibble(Sentence = c("x y", "z w"), Token = c("y", "w"))
  
  out <- get_distinct_redaction_rules(df, include_context = TRUE)
  expect_true("Context" %in% names(out))
})
