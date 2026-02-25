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

#' @exportS3Method
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

#' @exportS3Method
print.then_function <- function(x, ...) {
  sprintf("`then_function` for %s -> %s", attr(x, "from"), attr(x, "to")) |>
    print()
}

#' @keywords internal
then_list_factory <- function(df) {
  if (!all(c("From", "To") %in% names(df))) {
    validation_error("Columns `From` and `To` are needed in `df`")
  }

  purrr::map2(df$From, df$To, then_function_factory)
}

#' @keywords internal
rule_logic <- function(df) {
  cond_fun <- if_function_factory(df)
  replace_funs <- then_list_factory(df)

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
  rule_blocks <- purrr::map(grouped, rule_logic)

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

  structure(parsed_function,
    class = "redact_function",
    NRules = nrow(rules.frm),
    NBlocks = length(rule_blocks)
  )
}

#' @exportS3Method
print.redact_function <- function(x, ...) {
  sprintf(
    "`redaction_function` with %d rules over %d blocks",
    attr(x, "NRules"), attr(x, "NBlocks")
  ) |>
    print()
}
