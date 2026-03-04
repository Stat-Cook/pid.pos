#' @keywords internal
parse_redacter <- function(redacter, with_cache = T) {
  UseMethod("parse_redacter")
}

#' @exportS3Method
parse_redacter.data.frame <- function(redacter, with_cache = T) {
  redaction_function_factory(redacter) |>
    parse_redacter(with_cache)
}

#' @exportS3Method
parse_redacter.redact_function <- function(redacter, with_cache = T) {
  if (with_cache) {
    cached_redact_factory(redacter)
  } else {
    redacter
  }
}

#' @exportS3Method
parse_redacter.cached_redact_function <- function(redacter, with_cache = T) {
  redacter
}
