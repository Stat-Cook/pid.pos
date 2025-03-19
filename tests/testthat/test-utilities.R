# Write test for set_model_folder()

test_that("set_model_folder", {
  set_model_folder("path/to/folder")
  expect_equal(pid.pos_env$model_folder, "path/to/folder")
})
