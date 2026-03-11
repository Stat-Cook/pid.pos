#' A custom abort function
#'
#' @param message The error message to display
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
#'   pid.pos:::file_not_found_error("This is a type error", call = rlang::caller_env())
#' }
#'
#' # Trigger the error safely without stopping R
#' result <- try(f(), silent = TRUE)
#' result
#'
file_not_found_error <- new_error_type("file_not_found_error")
