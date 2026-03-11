test_that("parse_redacter dispatches correctly", {
  mockery::stub(
    parse_redacter.data.frame, "redaction_function_factory",
    function(frm) {
      structure(function(a) "Bob",
        class = "redact_function"
      )
    }
  )

  df <- data.frame()
  uncached <- parse_redacter(df, with_cache = FALSE)

  expect_type(uncached, "closure")
  expect_equal(class(uncached), "redact_function")
  expect_equal(uncached("anything"), "Bob")

  cached <- parse_redacter(df)

  expect_type(cached, "closure")
  expect_equal(class(cached), c("cached_redact_function", "redact_function"))
  expect_equal(cached("anything"), "Bob")
})
