pid.pos_env <- new.env()

.onLoad <- function(libname, pkgname) {
  op <- options()
  if (is.null(op[["pid_pos_context_window"]])) options(pid_pos_context_window = 25)

  pid.pos_env$deault_model_folder <- user_data_dir("pid.pos")
  pid.pos_env$allowed_repos <- c(
    `2.5` = "jwijffels/udpipe.models.ud.2.5",
    `2.4` = "jwijffels/udpipe.models.ud.2.4",
    `2.3` = "jwijffels/udpipe.models.ud.2.3"
  )
  pid.pos_env$repo_dates <- c(
    "jwijffels/udpipe.models.ud.2.5" = "191206",
    "jwijffels/udpipe.models.ud.2.4" = "190531",
    "jwijffels/udpipe.models.ud.2.3" = "181115"
  )
  reinstate_default_reader()

  pid.pos_env$udpipe_repo <- pid.pos_env$allowed_repos[["2.5"]]

  enable_package_models()

  invisible()
}
