read_data <- function(file_path, ...) {
  ext <- tolower(tools::file_ext(file_path))

  reader <- pid.pos_env$file_readers[[ext]]

  if (is.null(reader)) {
    stop("Unsupported file type: ", ext, call. = FALSE)
  }

  reader(file_path, ...)
}
