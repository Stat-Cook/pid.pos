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
#' f <- function(){
#'   file_not_found_error("This is a type error", call=rlang::caller_env())
#' }
#' 
#' # Trigger the error safely without stopping R
#' result <- try(f(), silent = TRUE)
#' result
#' 
file_not_found_error <- function(msg, inherited_class = NULL, ..., call = caller_env()) {
  
  cls <- c("pid_pos_file_not_found_error", "file_not_found_error", "pid_pos_error", inherited_class)
  
  abort(
    message = msg,
    class = cls,
    call = call,
    !!!list(...)
  )
}
