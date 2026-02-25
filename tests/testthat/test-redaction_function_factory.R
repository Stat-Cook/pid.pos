# Minimal example data frame
rules <- tibble::tibble(
  If = c("foo", "foo", "bar"),
  From = c("a", "b", "x"),
  To = c("A", "B", "X")
)

test_that("if_function_factory returns a function and errors on multiple Ifs", {
  df <- tibble::tibble(If = "foo")
  f <- if_function_factory(df)
  expect_s3_class(f, "if_function")
  expect_true(f("foo bar"))
  expect_false(f("baz"))

  # error on multiple If values
  df2 <- tibble::tibble(If = c("foo", "bar"))
  expect_error(if_function_factory(df2), "Rule block contains multiple 'If'")
})

test_that("then_function_factory replaces tokens correctly", {
  f <- then_function_factory("a", "A")
  expect_s3_class(f, "then_function")
  expect_equal(f("a b a"), "A b A")
})

test_that("then_list_factory returns list of then_function", {
  lst <- then_list_factory(rules[rules$If == "foo", ])
  expect_type(lst, "list")
  expect_length(lst, 2)
  expect_s3_class(lst[[1]], "then_function")
})

test_that("rule_logic combines if + then functions", {
  block <- rule_logic(rules[rules$If == "foo", ])
  expect_named(block, c("condition", "replace"))
  expect_s3_class(block$condition, "if_function")
  expect_type(block$replace, "list")
  expect_s3_class(block$replace[[1]], "then_function")
})

test_that("redaction_function_factory applies rules correctly", {
  redactor <- redaction_function_factory(rules)
  expect_s3_class(redactor, "redact_function")

  input <- c("foo a b c", "bar x y", "baz z")
  out <- redactor(input)

  # Check replacements
  expect_equal(out[1], "foo A B c") # first rule block: foo
  expect_equal(out[2], "bar X y") # second rule block: bar
  expect_equal(out[3], "baz z") # unchanged
})

test_that("redact_function preserves unmatched text", {
  redactor <- redaction_function_factory(rules)
  input <- c("no match")
  out <- redactor(input)
  expect_equal(out, "no match")
})

test_that("print.redact_function shows correct NRules", {
  redactor <- redaction_function_factory(rules)
  txt <- capture.output(print(redactor))
  expect_match(txt, "`redaction_function` with 3 rules over 2 blocks") # foo + bar
})
