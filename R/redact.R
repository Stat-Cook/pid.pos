#' Redact PID
#'
#' @param object The object to be redacted - either a vector or data frame
#' @param redacter A `data.frame` of redaction rules or a function created by `redaction_function_factory()`.
#'
redact <- function(object, redacter, in_batches = T, ...) {
  redacter <- parse_redacter(redacter)

  if (in_batches) {
    batched_redact(object, redacter, ...)
  } else {
    redact_internal(object, redacter)
  }
}
