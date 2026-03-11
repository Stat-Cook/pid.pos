set_model_folder <- function(path) {
  unlockBinding("model_folder", pid.pos_env)
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
  #' \dontrun{
  #'   tmp <- withr::local_tempdir()
  #'   withr::local_dir(tmp)
  #'
  #'   enable_local_models()
  #'   enable_local_models(sub_folder=FALSE)
  #' }
  #'

  local_dir <- getwd()
  if (sub_folder) {
    local_dir <- file.path(local_dir, "pid_pos_models")
  }

  if (!dir.exists(local_dir)) {
    if (!dir.create(local_dir, recursive = TRUE)) {
      stop("Could not create local model folder: ", local_dir)
    }
  }

  set_model_folder(local_dir)
  invisible(local_dir)
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

  cache_dir <- tools::R_user_dir("pid.pos", which = "cache")

  if (!dir.exists(cache_dir)) {
    if (!dir.create(cache_dir, recursive = TRUE)) {
      stop("Could not create local model folder: ", cache_dir)
    }
  }
  set_model_folder(cache_dir)
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
  pkg_env <- getNamespace("pid.pos")
  if (!exists("pid.pos_env", envir = pkg_env)) {
    stop("pid.pos_env does not exist. Initialize it first.")
  }

  version <- match.arg(version)

  if (!version %in% names(pid.pos_env$allowed_repos)) {
    validation_error("No repository defined for version")
  }

  # repo <- pid.pos_env$allowed_repos[[version]]
  # if (is.null(repo)) stop("No repository defined for version ", version)
  pid.pos_env$udpipe_version <- pid.pos_env$allowed_repos[[version]]

  invisible(pid.pos_env$udpipe_version)
}


summarize_repeated_sentences <- function(frm, ...) {
  #' @importFrom utils head read.csv write.csv
  first <- head(frm, 1)
  first$Repeats <- nrow(frm)
  first$`Affected Columns` <- paste(glue("`{unique(frm$Column)}`"), collapse = ", ")
  first
}


remove_if_exists <- function(frm, to_remove) {
  to_remove <- intersect(colnames(frm), to_remove)
  frm %>% select(-all_of(to_remove))
}


divide_map <- function(frm, func, n = NULL, .progress = T) {
  if (nrow(frm) == 0) {
    return(frm)
  }

  if (is.null(n)) {
    n <- round(sqrt(nrow(frm)))
  }

  .split <- ceiling(
    seq_len(nrow(frm)) * n / nrow(frm)
  )

  .grps <- split(frm, .split)

  map(.grps, func, .progress = .progress) |>
    bind_rows()
}
