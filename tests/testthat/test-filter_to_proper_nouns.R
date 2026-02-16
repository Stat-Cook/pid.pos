test_that("filter_to_proper_nouns filters only PROPN rows", {
  df <- tibble::tibble(
    ID = 1:4,
    Token = c("John", "runs", "Paris", "quickly"),
    Sentence = c(1, 1, 2, 2),
    upos = c("PROPN", "VERB", "PROPN", "ADV")
  )

  result <- filter_to_proper_nouns(df)

  expect_equal(nrow(result), 2)
  expect_true(all(df$upos[df$upos == "PROPN"] == "PROPN"))
})

test_that("returns only ID, Token, Sentence columns", {
  df <- tibble::tibble(
    ID = 1,
    Token = "John",
    Sentence = 1,
    upos = "PROPN",
    extra = "ignored"
  )

  result <- filter_to_proper_nouns(df)

  expect_named(result, c("ID", "Token", "Sentence"))
})

test_that("returns empty tibble when no proper nouns present", {
  df <- tibble::tibble(
    ID = 1:2,
    Token = c("runs", "fast"),
    Sentence = c(1, 1),
    upos = c("VERB", "ADV")
  )

  result <- filter_to_proper_nouns(df)

  expect_equal(nrow(result), 0)
})

test_that("handles empty data frame", {
  df <- tibble::tibble(
    ID = integer(),
    Token = character(),
    Sentence = integer(),
    upos = character()
  )

  result <- filter_to_proper_nouns(df)

  expect_equal(nrow(result), 0)
})

test_that("errors if input is not a data frame", {
  expect_error(
    filter_to_proper_nouns("not a df"),
    "must be a data frame"
  )
})

test_that("errors if required columns are missing", {
  df <- tibble::tibble(
    ID = 1,
    Token = "John"
  )

  expect_error(
    filter_to_proper_nouns(df),
    "Missing required columns"
  )
})
