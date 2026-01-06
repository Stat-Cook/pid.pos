then_factory <- function(From, To, If) {
  functions <- purrr::map2(
    # From, To, function(.x, .y) function(vec) str_replace(vec, .x, .y)
    From, To, function(.x, .y) function(vec) gsub(.x, .y, vec, fixed = T)
  )

  function(vec) {
    sapply(
      vec,
      \(i) functions |>
        append(list(i), after = 0) |>
        reduce(~ .y(.x))
    )
  }
}

if_factory <- function(If) {
  function(vec) {
    # str_detect(vec, If)
    grepl(If, vec, fixed = T)
  }
}


then.function.list <- function(rules.frm) {
  #' @importFrom dplyr group_by group_map
  rules.frm |>
    group_by(If) |>
    group_map(
      ~ then_factory(.x$From, .x$To, .y$If)
    )
}


if.function.list <- function(rules.frm) {
  rules.frm |>
    group_by(If) |>
    group_map(
      ~ if_factory(.y$If)
    )
}

redaction_function_factory <- function(rules.frm) {
  #' Create a redaction function from a `data.frame` of replacement rules.
  #'
  #' @param rules.frm A data.frame with columns `If`, `From` and `To`.
  #'
  #' @importFrom purrr reduce map2
  then.functions <- then.function.list(rules.frm)
  if.functions <- if.function.list(rules.frm)

  function(vec) {
    conditions <- map(if.functions, ~ .x(vec))

    redactions <- map2(
      conditions,
      then.functions,
      function(.x, .y) function(vec) ifelse(.x, .y(vec), vec)
    )


    redactions |>
      append(list(vec), after = 0) |>
      reduce(~ .y(.x))
  }
}

frame_replacement <- function(frm, rules.frm) {
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
  #' report <- data_frame_report(example.data)
  #' redactions.raw <- report_to_redaction_rules(report)
  #'
  #' replace_by <- random_replacement.f()
  #' redactions <- auto_replace(redactions.raw, replacement.f = replace_by)
  #'
  #' frame_replacement(example.data, redactions)
  #' }
  #'
  #' @export
  redaction.f <- redaction_function_factory(rules.frm)

  frm |>
    mutate(
      across(
        where(is.character),
        \(i) redaction.f(i)
      )
    )
}
