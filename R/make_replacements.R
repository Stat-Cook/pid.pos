# Possibly deprecated

prepare_redactions <- function(object) {
  #' @export
  UseMethod("prepare_redactions")
}

prepare_redactions.character <- function(object) {
  #' @exportS3Method
  rules.frm <- read.csv(object)
  
  make_replacements(object)
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
