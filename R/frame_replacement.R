#' @keywords internal
if_function_factory <- function(df) {
  pattern <- df$If[1]

  if (!all(df$If == pattern)) {
    stop(sprintf("Rule block contains multiple 'If' values: %s", df$If))
  }

  structure(\(vec) grepl(pattern, vec, fixed = TRUE),
    class = "if_function",
    If = pattern
  )
}
print.if_function <- function(x, ...) {
  sprintf("`if_function` for %s", attr(x, "If")) |>
    print()
}

#' @keywords internal
then_function_factory <- function(from, to) {
  structure(
    \(vec) gsub(from, to, vec, fixed = TRUE),
    class = "then_function",
    from = from,
    to = to
  )
}
print.then_function <- function(x, ...) {
  sprintf("`then_function` for %s -> %s", attr(x, "from"), attr(x, "to")) |>
    print()
}

#' @keywords internal
then.list.factory <- function(df) {
  purrr::map2(df$From, df$To, then.function.factory)
}

#' @keywords internal
rule.logic <- function(df) {
  cond_fun <- if.function.factory(df)
  replace_funs <- then.list.factory(df)

  list(condition = cond_fun, replace = replace_funs)
}


#' Replacement rules to redaction function
#'
#' Convert a `data.frame` of redaction rules into a function that can be applied to a character vector.
#'
#' @param rules.frm A data.frame with columns `If`, `From` and `To`.
#'
#' @importFrom purrr reduce map2
#'
#' @examples
#' data(the_one_in_massapequa)
#' example.data <- head(the_one_in_massapequa)
#'
#' raw_rules <- pid_pos(example.data) |>
#'   report_to_redaction_rules()
#'
#' redaction_rules <- auto_replace(raw_rules,
#'   replacement.f = random_replacement.f()
#' )
#'
#' redaction_func <- redaction_function_factory(redaction_rules)
#'
#' redaction_func(example.data)
#'
#' @export
redaction_function_factory <- function(rules.frm) {
  grouped <- dplyr::group_split(rules.frm, .data$If)
  rule_blocks <- purrr::map(grouped, rule.logic)

  parsed_function <- function(vec) {
    purrr::reduce(rule_blocks, function(acc, block) {
      cond <- block$condition(acc)

      if (any(cond)) {
        replaced_subset <- purrr::reduce(block$replace, \(a, f) f(a), .init = acc[cond])
        acc[cond] <- replaced_subset
      }

      acc
    }, .init = vec)
  }

  structure(parsed_function, class = "redaction_function", NRules = length(rule_blocks))
}

#' @exportS3Method
print.redaction_function <- function(x, ...) {
  sprintf("`redaction_function` with %d rules", attr(x, "NRules")) |>
    print()
}


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
