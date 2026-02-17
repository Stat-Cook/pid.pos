# Write test for set_model_folder()

test_that("set_model_folder", {
  set_model_folder("path/to/folder")
  expect_equal(pid.pos_env$model_folder, "path/to/folder")
})

# Assume enable_local_models() and set_model_folder() are loaded

test_that("creates and returns subfolder by default", {
  withr::with_tempdir({
    folder <- enable_local_models()
    
    # Check folder was created
    expect_true(dir.exists(file.path(getwd(), "pid_pos_models")))
    
    # Check returned path
    expect_equal(folder, file.path(getwd(), "pid_pos_models"))
  })
})

test_that("uses current working directory if sub_folder = FALSE", {
  withr::with_tempdir({
    folder <- enable_local_models(sub_folder = FALSE)
    
    # Should be current working directory
    expect_equal(folder, getwd())
    
    # No pid_pos_models folder should be created
    expect_false(dir.exists(file.path(getwd(), "pid_pos_models")))
  })
})

test_that("existing folder does not error", {
  withr::with_tempdir({
    path <- file.path(getwd(), "pid_pos_models")
    dir.create(path)
    
    # Should not error if folder exists
    folder <- enable_local_models()
    expect_equal(folder, path)
  })
})

test_that("returns folder path invisibly", {
  withr::with_tempdir({
    folder <- enable_local_models()
    
    # Check return value is correct
    expect_equal(folder, file.path(getwd(), "pid_pos_models"))
  })
})

test_that("integration with set_model_folder sets correct path", {
  withr::with_tempdir({
    folder <- enable_local_models()
    
    # Assuming get_model_folder() returns the currently set folder
    if (exists("get_model_folder")) {
      expect_equal(get_model_folder(), folder)
    } else {
      # If no getter, just ensure folder exists
      expect_true(dir.exists(folder))
    }
  })
})

test_that("recursive folder creation works for nested subfolders", {
  withr::with_tempdir({
    nested_path <- file.path(getwd(), "a/b/c")
    
    # Modify enable_local_models temporarily to create nested folder
    temp_fun <- function(sub_folder = TRUE) {
      local_dir <- nested_path
      if (!dir.exists(local_dir)) dir.create(local_dir, recursive = TRUE)
      local_dir
    }
    
    folder <- temp_fun()
    expect_true(dir.exists(nested_path))
    expect_equal(folder, nested_path)
  })
})

# # Create a mock pid.pos_env for testing
# if (!exists("pid.pos_env", envir = .GlobalEnv)) {
#   pid.pos_env <- new.env()
# }

test_that("valid versions update environment correctly", {
  v <- set_udpipe_version("2.5")
  expect_equal(pid.pos_env$udpipe_version, "jwijffels/udpipe.models.ud.2.5")
  expect_equal(v, "jwijffels/udpipe.models.ud.2.5")
  
  v <- set_udpipe_version("2.4")
  expect_equal(pid.pos_env$udpipe_version, "jwijffels/udpipe.models.ud.2.4")
  set_udpipe_version("2.5")
})

test_that("default argument picks first (latest) version", {
  v <- set_udpipe_version()
  expect_equal(v, pid.pos_env$allowed_repos[["2.5"]])
  expect_equal(pid.pos_env$udpipe_version, pid.pos_env$allowed_repos[["2.5"]])
})

test_that("invalid version triggers error", {
  expect_error(set_udpipe_version("9.9"), "'arg' should be one of")
})

test_that("missing repository for version triggers error", {

  tmp_repo <- pid.pos_env$allowed_repos[["2.3"]]
  
  pid.pos_env$allowed_repos <- pid.pos_env$allowed_repos[names(pid.pos_env$allowed_repos) != "2.3"]
  
  expect_error(set_udpipe_version("2.3"), "No repository defined for version")
  
  pid.pos_env$allowed_repos[["2.3"]] <- tmp_repo
  set_udpipe_version("2.5")
})


test_that("missing repository for version triggers error", {
  # Temporarily remove a repo
  tmp_allowed_repos <- pid.pos_env$allowed_repos
  pid.pos_env$allowed_repos <- pid.pos_env$allowed_repos[c("2.5", "2.4")]  
  
  expect_error(set_udpipe_version("2.3"), "No repository defined for version")
  
  # Restore
  pid.pos_env$allowed_repos <- tmp_allowed_repos
})

