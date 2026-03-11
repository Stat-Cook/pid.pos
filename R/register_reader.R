register_reader <- function(fun, ext) {
  #' Add a reader function for a specific file extension.
  #'
  #' @param fun The function to read files with the specified extension.
  #'   The function should take a file path as its first argument and return a data frame.
  #' @param ext The file extension (e.g., "csv", "txt").
  #'
  #' @export
  #'
  #' @examples
  #' # example code
  #'
  if (!is.character(ext) || length(ext) != 1) {
    stop("Extension must be a single character string.", call. = FALSE)
  }
  if (!is.function(fun)) {
    stop("The reader must be a function.", call. = FALSE)
  }

  pid.pos_env$file_readers[[tolower(ext)]] <- fun
  invisible(TRUE)
}


reinstate_default_reader <- function() {
  #' Reinstate the default read functionality for csv, tsv, xls, and xlsx files.
  #'
  #' @export
  #'
  #' @examples
  #' reinstate_default_reader()
  default_readers <- list(
    csv = function(path, ..., show_col_types = FALSE) {
      readr::read_csv(path, ..., show_col_types = show_col_types)
    },
    tsv = readr::read_tsv,
    xls = readxl::read_excel,
    xlsx = readxl::read_excel
  )
  invisible(purrr::imap(default_readers, \(.x, .y) register_reader(.x, .y)))
}
