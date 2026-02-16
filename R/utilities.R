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
  local_dir <- getwd()
  if (sub_folder) {
    local_dir <- file.path(local_dir, "pid_pos_models")
  }

  if (!dir.exists(local_dir)) {
    dir.create(local_dir)
  }

  set_model_folder(local_dir)
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


set_udpipe_version <- function(version = c("2.5", "2.4", "2.3")) {
  #' Set the udpipe model repository version.
  #'
  #' @param version Character. The udpipe model version to use. One of "2.5", "2.4", or "2.3".
  #'
  #' @return Character. The udpipe model repository.
  #'
  #' @examples
  #' set_udpipe_version("2.4")
  #' @export
  #'
  version <- match.arg(version)
  pid.pos_env$udpipe_version <- pid.pos_env$allowed_repos[[version]]
  pid.pos_env$udpipe_version
}
