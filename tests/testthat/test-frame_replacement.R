test_that("frame_replacement works", {
  last100 <- tail(the_one_in_massapequa, 100)

  rules.frm <- data.frame(
    If = "Rachel Green",
    From = c("Rachel", "Green"),
    To = c("XXX", "YYY")
  )


  .redacted <- redact(last100, rules.frm)

  expect_equal(
    sum(str_detect(.redacted$speaker, "Rachel Green")),
    0
  )
})

test_that("then_list_factory returns list of same length as input rows", {
  df <- data.frame(
    From = c("a", "b", "c"),
    To = c("x", "y", "z"),
    stringsAsFactors = FALSE
  )

  mock_fun <- function(from, to) paste(from, to)

  mockery::stub(
    then_list_factory,
    "then_function_factory",
    mock_fun
  )

  result <- then_list_factory(df)

  expect_type(result, "list")
  expect_length(result, nrow(df))
})

test_that("then_list_factory pairs From and To correctly", {
  df <- data.frame(
    From = c("a", "b"),
    To = c("x", "y"),
    stringsAsFactors = FALSE
  )

  mock_fun <- function(from, to) paste0(from, "->", to)

  mockery::stub(
    then_list_factory,
    "then_function_factory",
    mock_fun
  )

  result <- then_list_factory(df)

  expect_equal(result, list("a->x", "b->y"))
})

test_that("then_list_factory returns empty list for empty data frame", {
  df <- data.frame(
    From = character(),
    To = character(),
    stringsAsFactors = FALSE
  )

  result <- then_list_factory(df)

  expect_equal(result, list())
})

test_that("then_list_factory errors if columns missing", {
  df <- data.frame(x = 1:3)

  expect_error(then_list_factory(df))
})


test_that("rule_logic returns list with condition and replace elements", {
  df <- data.frame(x = 1)

  mock_cond <- function() "cond"
  mock_replace <- list("r1", "r2")

  mockery::stub(rule_logic, "if_function_factory", function(df) mock_cond)
  mockery::stub(rule_logic, "then_list_factory", function(df) mock_replace)

  result <- rule_logic(df)

  expect_type(result, "list")
  expect_named(result, c("condition", "replace"))
})

test_that("rule_logic passes through factory outputs unchanged", {
  df <- data.frame(x = 1)

  mock_cond <- function() TRUE
  mock_replace <- list(function(x) x + 1)

  mockery::stub(rule_logic, "if_function_factory", function(df) mock_cond)
  mockery::stub(rule_logic, "then_list_factory", function(df) mock_replace)

  result <- rule_logic(df)

  expect_identical(result$condition, mock_cond)
  expect_identical(result$replace, mock_replace)
})

test_that("rule_logic calls both factories once", {
  df <- data.frame(x = 1)

  cond_calls <- 0
  replace_calls <- 0

  mockery::stub(
    rule_logic,
    "if_function_factory",
    function(df) {
      cond_calls <<- cond_calls + 1
      function() NULL
    }
  )

  mockery::stub(
    rule_logic,
    "then_list_factory",
    function(df) {
      replace_calls <<- replace_calls + 1
      list()
    }
  )

  rule_logic(df)

  expect_equal(cond_calls, 1)
  expect_equal(replace_calls, 1)
})

test_that("rule_logic propagates errors from factories", {
  df <- data.frame(x = 1)

  mockery::stub(
    rule_logic,
    "if_function_factory",
    function(df) stop("bad condition")
  )

  expect_error(rule_logic(df), "bad condition")
})
