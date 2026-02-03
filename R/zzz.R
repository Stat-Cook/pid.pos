.onLoad <- function(libname, pkgname) {
  # ns_dplyr <- ns_env(pkgname)

  op <- options()
  op.pid.pos <- list(
    pid.pos.context_window = 25
  )
  toset <- !(names(op.pid.pos) %in% names(op))
  if (any(toset)) options(op.pid.pos[toset])

  pid.pos_env$deault_model_folder <- user_data_dir("pid.pos")
  enable_local_models()

  invisible()
}
