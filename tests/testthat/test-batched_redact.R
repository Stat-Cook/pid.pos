# Dummy redaction function
redact_fun <- function(x) {
  paste0("REDACTED_", x)
}

# Small example data frame
df <- tibble::tibble(
  id = 1:5,
  name = letters[1:5],
  notes = c("foo", "bar", "baz", "qux", "quux")
)

test_that("batched_redact.default applies redaction correctly", {
  result <- batched_redact(df, redact_fun, n = 2, .progress = FALSE)

  # Character columns are redacted
  expect_true(all(grepl("^REDACTED_", result$name)))
  expect_true(all(grepl("^REDACTED_", result$notes)))

  # Non-character column unchanged
  expect_equal(result$id, df$id)

  # Number of rows/columns preserved
  expect_equal(dim(result), dim(df))
})

test_that("batched_redact.cached_redact_function applies function correctly", {
  # Wrap redact_fun in cached_redact_function manually
  cached_fun <- cached_redact_factory(redact_fun)

  result <- batched_redact(df, cached_fun, n = 3, .progress = FALSE)

  expect_true(all(grepl("^REDACTED_", result$name)))
  expect_true(all(grepl("^REDACTED_", result$notes)))
})

test_that("batched_redact works with n = NULL", {
  result <- batched_redact(df, redact_fun, n = NULL)
  expect_equal(dim(result), dim(df))
})

test_that("batched_redact handles empty data frame", {
  empty_df <- df[0, ]
  result <- batched_redact(empty_df, redact_fun)

  expect_equal(nrow(result), 0)
  expect_equal(ncol(result), ncol(df))
})

test_that("batched_redact handles data frame with no character columns", {
  df_num <- df %>% select(id)
  result <- batched_redact(df_num, redact_fun)
  expect_equal(result$id, df$id)
})

test_that("batched_redact preserves idempotence for repeated calls", {
  result1 <- batched_redact(df, redact_fun)
  result2 <- batched_redact(df, redact_fun)
  expect_equal(result1, result2)
})

test_that("batched_redact handles redact function that doesn't change values", {
  identity_fun <- function(x) x
  result <- batched_redact(df, identity_fun)
  expect_equal(result, df)
})
