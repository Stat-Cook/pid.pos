test_that("CachedRedact functions", {
  .redact <- function(vec) str_replace_all(vec, ".", "X")

  cr <- CachedRedact$new(.redact)

  test.vec <- c(letters, LETTERS)
  initial.uncoded <- cr$get_uncoded_keys(test.vec)

  expect_equal(test.vec, initial.uncoded)

  .coded <- cr$recode(test.vec)

  expect_equal(.coded, rep("X", length(test.vec)),
    ignore_attr = TRUE
  )

  still.uncoded <- cr$get_uncoded_keys(test.vec)
  expect_equal(length(still.uncoded), 0)
})


test_that("cached_redact_factory basic", {
  .redact <- function(vec) str_replace_all(vec, ".", "X")
  eff.f <- cached_redact_factory(.redact)

  test.vec <- c(letters, LETTERS)
  .coded <- eff.f(test.vec)
  expect_equal(.coded, rep("X", length(test.vec)),
    ignore_attr = TRUE
  )
})


test_that("divide_map", {
  n <- 12
  divide.job <- divide_map(
    the_one_in_massapequa,
    \(.x) data.frame(N = nrow(.x)),
    n = n
  )

  expect_equal(nrow(divide.job), n)
  expect_equal(sum(divide.job$N), nrow(the_one_in_massapequa))
})


test_that("batched & cached redaction", {
  top100 <- head(the_one_in_massapequa, 100)
  .redact <- function(vec) str_replace_all(vec, ".", "X")
  method1 <- batched_redact(top100, .redact)

  expect_equal(
    str_length(method1$speaker),
    str_length(top100$speaker)
  )

  .eff.redact <- cached_redact_factory(.redact)
  method2 <- batched_redact(top100, .eff.redact)

  expect_equal(
    str_length(method2$speaker),
    str_length(top100$speaker)
  )
})
