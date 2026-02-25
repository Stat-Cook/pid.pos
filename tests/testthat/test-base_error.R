test_that("base_error throws error with correct message and class", {
  expect_error(
    base_error("my_subclass", "oh no!", call = NULL),
    "oh no!",
    class = c("my_subclass")
  )
})

test_that("base_error preserves extra arguments via ...", {
  e <- tryCatch(
    base_error("my_subclass", "extra test", foo = 42, bar = "hello", call = NULL),
    error = function(e) e
  )
  
  expect_equal(e$foo, 42)
  expect_equal(e$bar, "hello")
})

test_that("new_error_type returns a constructor function", {
  my_error <- new_error_type("bad_thing")
  
  expect_type(my_error, "closure")
  
  e <- tryCatch(
    my_error("uh oh", call = NULL),
    error = function(e) e
  )
  
  expect_s3_class(e, c("mypkg_bad_thing", "bad_thing", "pid_pos_error", "error"))
  expect_match(conditionMessage(e), "uh oh")
})

test_that("new_error_type supports parent class inheritance", {
  parent_error <- new_error_type("parent")
  child_error <- new_error_type("child", parent = "parent")
  
  e <- tryCatch(
    child_error("fail", call = NULL),
    error = function(e) e
  )
  
  expect_s3_class(e, c("mypkg_child", "child", "parent", "pid_pos_error", "error"))
  expect_match(conditionMessage(e), "fail")
})

test_that("call is captured correctly", {
  my_error <- new_error_type("env_test")
  
  f <- function() my_error("inside function")
  
  expect_error(f(), "inside function")
  # optionally inspect call environment
  e <- tryCatch(f(), error = function(e) e)
  expect_true("env_test" %in% class(e))  # basic check
  expect_true(!is.null(e$call))          # call exists
})

test_that("extra arguments are accessible in the error object", {
  my_error <- new_error_type("extra_args")
  
  e <- tryCatch(
    my_error("msg", x = 5, y = "hello", call = NULL),
    error = function(e) e
  )
  
  expect_equal(e$x, 5)
  expect_equal(e$y, "hello")
})

