batched_redact <- function(frm, redact, n = NULL, .progress = T) {
  #' A wrapper for efficient redaction.
  #'
  #' An experimental function for the efficient application of the redaction functions.
  #' This function wraps a redaction function in a  dynamic programming class which
  #' stores previously redacted values and reuses them when the same value is encountered again.
  #'
  #' This function splits the data frame into chunks and processes each chunk separately.
  #' This is useful for large data frames where the redaction function may be slow.
  #'
  #'
  #' @param frm The data frame to be redacted
  #' @param redact A  function which converts free text to redacted text.
  #' @param n The number of chunks to split the data frame into for processing.
  #' @param .progress Whether to show a progress bar.
  #'
  #' @returns A data frame with the same structure as `frm` but with redacted text.
  #'
  #' @examples
  #' \dontrun{
  #' example.data <- head(the_one_in_massapequa)
  #' report <- pid_pos(example.data, to_remove="speaker")
  #' redactions.raw <- report_to_redaction_rules(report)
  #'
  #' replace_by <- random_replacement.f()
  #' redactions <- auto_replace(redactions.raw, replacement.f = replace_by)
  #' redaction.f <- prepare_redactions(redactions)
  #' efficient_redaction(example.data, redaction.f)
  #' }
  #'
  #'
  #' @export
  UseMethod("batched_redact", redact)
}

batched_redact.cached_redact_function <- function(frm, redact, n = NULL, .progress = T) {
  #' @exportS3Method
  #'
  #' @importFrom dplyr across where mutate
  
  .mutate <- function(frm) {
    dplyr::mutate(
      frm,
      dplyr::across(where(is.character), \(i) redact(i))
    )
  }
  
  divide_map(frm, .mutate, n, .progress)
}

batched_redact.default <- function(frm, redact, n = NULL, .progress = T) {
  #' @exportS3Method
  #'
  
  cached.f <- cached_redact_factory(redact)
  batched_redact(frm, cached.f, n = n, .progress = .progress)
}