#' Remove PID from a data frame.
#'
#' Applied the replacement rules (as defined in a `data.frame` with columns
#' `If`, `From` and `To`) to all character columns in a data frame.
#'
#' @param frm The data frame containing text
#' @param rules.frm The `data.frame` containing `If`, `From` and `To` rules.
#'
#' @return A data.frame with the same structure as
#'
#' @examples
#' \dontrun{
#' example.data <- head(the_one_in_massapequa)
#' report <- pid_pos(example.data)
#' redactions.raw <- report_to_redaction_rules(report)
#'
#' replace_by <- random_replacement.f()
#' redactions <- auto_replace(redactions.raw, replacement.f = replace_by)
#'
#' frame_replacement(example.data, redactions)
#' }
#'
#' @export
frame_replacement <- function(frm, rules.frm) {
  redaction.f <- redaction_function_factory(rules.frm)
  redaction.f(frm)
  # frm |>
  #   mutate(dplyr::across(where(is.character), \(i) redaction.f(i)))
}
