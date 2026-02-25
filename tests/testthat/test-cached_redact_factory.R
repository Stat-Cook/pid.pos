# Dummy redaction function
redact_fun <- function(x) {
  paste0("REDACTED_", x)
}

test_that("CachedRedact recodes values correctly", {
  cr <- CachedRedact$new(redact_fun)
  vec <- c("a", "b", "c")

  out <- cr$recode(vec)

  expect_true(all(grepl("^REDACTED_", out)))
  expect_equal(length(out), length(vec))
})

test_that("CachedRedact caches previously seen values", {
  cr <- CachedRedact$new(redact_fun)

  v1 <- c("a", "b")
  v2 <- c("b", "c")

  out1 <- cr$recode(v1)
  out2 <- cr$recode(v2)

  # The internal cache should now contain a, b, c
  expect_setequal(names(cr$redacted), c("a", "b", "c"))
  # Values from previous call should be reused
  expect_equal(cr$redacted[["b"]], redact_fun("b"))
})

test_that("CachedRedact handles repeated values efficiently", {
  cr <- CachedRedact$new(redact_fun)

  vec <- c("a", "a", "b", "b")
  out <- cr$recode(vec)

  # Output length matches input
  expect_equal(length(out), length(vec))
  # All unique values are in cache
  expect_setequal(names(cr$redacted), unique(vec))
})

test_that("CachedRedact handles NA values correctly", {
  cr <- CachedRedact$new(redact_fun)

  vec <- c("a", NA, "b", NA)
  out <- cr$recode(vec)

  expect_true(all(is.na(out[c(FALSE, TRUE, FALSE, TRUE)]))) # NAs preserved
  expect_true(all(grepl("^REDACTED_", out[c(TRUE, FALSE, TRUE, FALSE)])))
})

test_that("cached_redact_factory returns a function with cache", {
  f <- cached_redact_factory(redact_fun)

  expect_s3_class(f, "cached_redact_function")
  expect_true(inherits(attr(f, "cache"), "CachedRedact"))

  # Check that redaction works
  vec <- c("a", "b")
  out <- f(vec)
  expect_true(all(grepl("^REDACTED_", out)))
})

test_that("cached_redact_function caches correctly across calls", {
  f <- cached_redact_factory(redact_fun)

  v1 <- c("a", "b")
  v2 <- c("b", "c")

  out1 <- f(v1)
  out2 <- f(v2)

  cache <- attr(f, "cache")
  expect_setequal(names(cache$redacted), c("a", "b", "c"))
})

test_that("print.CachedRedact shows correct size", {
  cr <- CachedRedact$new(redact_fun)
  cr$recode(c("a", "b"))

  txt <- capture.output(print(cr))
  expect_match(txt, "CachedRedact Object \\[size=2\\]")
})

test_that("print.cached_redact_function shows cache size", {
  f <- cached_redact_factory(redact_fun)
  f(c("a", "b"))

  txt <- capture.output(print(f))
  expect_match(txt, "`cached_redact_function` \\[size=2\\]")
})

test_that("cached_redact_function is idempotent for repeated values", {
  f <- cached_redact_factory(redact_fun)
  vec <- c("x", "y", "x", "y")

  out1 <- f(vec)
  out2 <- f(vec)

  expect_equal(out1, out2)
})
