redact_internal <- function(object, redaction_func) {
  #' @keywords internal
  UseMethod("redact_internal")
}

redact_internal.data.frame <- function(object, redaction_func) {
  #' @exportS3Method 
  object |>
    dplyr::mutate(
      dplyr::across(where(is.character), \(i) redaction_func(i))
    )
}

redact_internal.default <- function(object, redaction_func) {
  #' @exportS3Method 
  redaction_func(object)
}

