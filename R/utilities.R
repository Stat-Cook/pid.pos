set_model_folder <- function(path) {
  pid.pos_env$model_folder <- path
  path
}

enable_local_models <- function(sub_folder = TRUE) {
  #' Set the model folder to a local 'pid_pos_models' sub-folder.
  #'
  #' Intended if you want to use local udpipe models for a specific R project.
  #'
  #' @param sub_folder Logical. If TRUE, use a 'pid_pos_models' sub-folder
  #'   of the current working directory. If FALSE use the current working directory.
  #'
  #' @return The path to the model folder.
  #'
  #' @export
  #'
  #' @examples
  #' enable_local_models()
  #' enable_local_models(sub_folder=FALSE)
  wd <- getwd()
  if (sub_folder) {
    wd <- file.path(wd, "pid_pos_models")
  }

  set_model_folder(wd)
}

enable_package_models <- function() {
  #' Set the model folder to the package data folder.
  #'
  #' Intended if you want to share udpipe models between different R projects.
  #'
  #' @return The path to the model folder.
  #' @export
  #' @examples
  #' enable_package_models()
  set_model_folder(user_data_dir("pid.pos"))
}
