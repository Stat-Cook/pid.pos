#' A custom abort function
#'
#' @param subclass a vector of inherited error class
#' @param message The error message to display
#' @param ... Additional arguments to pass to `abort()`
#' @param call The call environment to use for the error (defaults to the caller's environment)
#'
#' @return An error object with the specified message and classes
#'
#' @importFrom rlang abort caller_env
#' @keywords internal
#'
base_error <- function(subclass,
                       message,
                       ...,
                       call) {
  cls <- c(subclass, "pid_pos_error", "error")

  abort(
    message = message,
    class = cls,
    call = call,
    !!!list(...)
  )
}


new_error_type <- function(name, parent = NULL) {
  function(message, ..., call = caller_env()) {
    subclass <- c(
      paste0("mypkg_", name),
      name,
      parent
    )

    base_error(
      subclass = subclass,
      message = message,
      ...,
      call = call
    )
  }
}
