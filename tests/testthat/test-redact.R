# # Example input
# vec <- c("secret info", "public info")
# df <- data.frame(a = vec, b = vec)
#
# parsed_reacter_mock <- function(redacter) "parsed_redacter"
# redact_internal_mock <- function(...) "internal_result"
# batched_redact_mock <- function(object, redacter, ...) "batched_result"
#
# test_that("redact calls redact_internal when in_batches = FALSE", {
#   mockery::stub(redact, "parse_redacter", parsed_reacter_mock)
#   mockery::stub(redact, "redact_internal", redact_internal_mock)
#
#   result <- redact(vec, redacter = "dummy", in_batches = FALSE)
#
#   expect_equal(result, "internal_result")
# })
#
# test_that("redact calls batched_redact when in_batches = TRUE", {
#   mockery::stub(redact, "parse_redacter", parsed_reacter_mock)
#   mockery::stub(redact, "batched_redact", batched_redact_mock)
#
#   result <- redact(vec, redacter = "dummy", in_batches = TRUE)
#
#   expect_equal(result, "batched_result")
# })
#
# test_that("parse_redacter is called with the provided redacter", {
#   called_with <- NULL
#   mockery::stub(redact, "parse_redacter", function(redacter) { called_with <<- redacter; parsed_reacter_mock(redacter)})
#   mockery::stub(redact, "redact_internal", redact_internal_mock)
#
#   redact(vec, redacter = "my_rules", in_batches = FALSE)
#
#   expect_equal(called_with, "my_rules")
# })


vec <- c("secret info", "public info")
df <- data.frame(a = vec, b = vec, stringsAsFactors = FALSE)

parsed_reacter_mock <- function(redacter) "parsed_redacter"
redact_internal_mock <- function(object, redaction_func, ...) "internal_result"
batched_redact_mock <- function(object, redacter, ...) "batched_result"


test_that("redact calls redact_internal when in_batches = FALSE", {
  mockery::stub(redact, "parse_redacter", parsed_reacter_mock)
  mockery::stub(redact, "redact_internal", redact_internal_mock)

  result <- redact(vec, redacter = "dummy", in_batches = FALSE)
  expect_equal(result, "internal_result")
})

test_that("redact calls batched_redact when in_batches = TRUE", {
  mockery::stub(redact, "parse_redacter", parsed_reacter_mock)
  mockery::stub(redact, "batched_redact", batched_redact_mock)

  result <- redact(vec, redacter = "dummy", in_batches = TRUE)
  expect_equal(result, "batched_result")
})

test_that("parse_redacter is called with the provided redacter", {
  called_with <- NULL
  mockery::stub(redact, "parse_redacter", function(redacter) {
    called_with <<- redacter
    parsed_reacter_mock(redacter)
  })
  mockery::stub(redact, "redact_internal", redact_internal_mock)

  redact(vec, redacter = "my_rules", in_batches = FALSE)
  expect_equal(called_with, "my_rules")
})


simple_redacter <- data.frame(
  pattern = c("secret", "private"),
  replacement = c("***", "###"),
  stringsAsFactors = FALSE
)


redact_internal_real <- function(object, redacter, ...) {
  if (is.data.frame(object)) {
    object[] <- lapply(object, function(col) {
      col <- as.character(col)
      for (i in seq_len(nrow(redacter))) {
        col <- gsub(redacter$pattern[i], redacter$replacement[i], col)
      }
      col
    })
    object
  } else {
    col <- as.character(object)
    for (i in seq_len(nrow(redacter))) {
      col <- gsub(redacter$pattern[i], redacter$replacement[i], col)
    }
    col
  }
}

test_that("redact works on character vector realistically", {
  mockery::stub(redact, "parse_redacter", function(redacter) simple_redacter)
  mockery::stub(redact, "redact_internal", redact_internal_real)

  result <- redact(vec, redacter = simple_redacter, in_batches = FALSE)
  expect_equal(result, c("*** info", "public info"))
})

test_that("redact works on data frame realistically", {
  mockery::stub(redact, "parse_redacter", function(redacter) simple_redacter)
  mockery::stub(redact, "redact_internal", redact_internal_real)

  result <- redact(df, redacter = simple_redacter, in_batches = FALSE)
  expect_equal(result$a, c("*** info", "public info"))
  expect_equal(result$b, c("*** info", "public info"))
})

test_that("redact works on data frame in batches", {
  mockery::stub(redact, "parse_redacter", function(redacter) simple_redacter)
  # For testing, batched_redact uses same logic
  mockery::stub(redact, "batched_redact", redact_internal_real)

  result <- redact(df, redacter = simple_redacter, in_batches = TRUE)
  expect_equal(result$a, c("*** info", "public info"))
  expect_equal(result$b, c("*** info", "public info"))
})

batched_redact_mock <- function(object, redacter, ...) {
  list(...)
}

test_that("redact works on data frame in batches", {
  mockery::stub(redact, "parse_redacter", function(redacter) simple_redacter)
  # For testing, batched_redact uses same logic
  mockery::stub(redact, "batched_redact", batched_redact_mock)

  result <- redact(df, redacter = simple_redacter, in_batches = TRUE, n = 1)
  expect_equal(result$n, 1)
})
