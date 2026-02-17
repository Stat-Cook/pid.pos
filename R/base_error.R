#' A custom abort function
#'
#' @param msg The error message to display
#' @param inherited_class A character vector of additional classes to inherit from (optional)
#' @param ... Additional arguments to pass to `abort()`
#' @param call The call environment to use for the error (defaults to the caller's environment)
#'
#' @return An error object with the specified message and classes
#'
#' @importFrom rlang abort caller_env
#' @keywords internal
#'
#' @examples
#' #' # Example of using type_error
#' f <- function() {
#'   type_error("This is a type error", call = rlang::caller_env())
#' }
#'
#' # Trigger the error safely without stopping R
#' result <- try(f(), silent = TRUE)
#' result
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
