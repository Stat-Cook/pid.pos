# Possibly deprecated

prepare_redactions <- function(object) {
  #' Prepare redaction function from replacement rules.
  #'
  #' @param object The `replacement_rules` (can be a path to a csv file
  #' or a `data.frame`).
  #'
  #' @export
  UseMethod("prepare_redactions")
}

prepare_redactions.character <- function(object) {
  #' @exportS3Method
  rules.frm <- read.csv(object)

  prepare_redactions(rules.frm)
}

prepare_redactions.data.frame <- function(object) {
  #' @exportS3Method
  redaction_function_factory(object)
}


#' then_factory <- function(From, To, If){
#'   purrr::map2(
#'     From, To, function(.x, .y) function(vec) str_replace(vec, .x, .y)
#'   ) |>
#'     append(list(If), after=0) |>
#'     reduce(~ .y(.x))
#' }
