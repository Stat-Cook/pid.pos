# Possibly reprecated


#' load_replacement_rules <- function(object, parse = F) {
#'   #' Read replacement frame into R.
#'   #' 
#'   #' Load the `replacement_rules` (as defined with `report_to_replacement_rules`) 
#'   #' into the R environment, either as a `data.frame` or as 
#'   #' a function that can be used to modify a data frame.
#'   #'
#'   #' @param object The `replacement_rules` (can be a path to a csv file 
#'   #' containing the rules or a `data.frame`).
#'   #' @param parse Binary-flag.  If True the replacement function is parsed.
#'   #'
#'   #' @export
#'   UseMethod("load_replacement_rules")
#' }
#' 
#' 
#' load_replacement_rules.character <- function(object, parse = F) {
#'   #' @exportS3Method
#'   rules.frm <- read.csv(object)
#'   
#'   load_replacement_rules(rules.frm, parse)
#' }
#' 
#' 
#' load_replacement_rules.data.frame <- function(object, parse = F) {
#'   #' @exportS3Method
#'   #' 
#'   if (parse){
#'     redaction_function_factory(object)
#'   } else {
#'     object
#'   }
#' }




#' parse_replacement_rules <- function(rules.frm, parse = F) {
#'   #' @importFrom dplyr group_by group_map
#'   #' @importFrom dplyr case_when
#'   #' @importFrom stringr str_replace_all str_detect
#'   
#'   .rules <- rules.frm |>
#'     mutate(
#'       From = escape_quote_mark(From),
#'       To = escape_quote_mark(To),
#'       If = escape_quote_mark(If),
#'       Replace = sprintf("stringr::str_replace_all('%s', '%s')", From, To)
#'     ) |>
#'     group_by(If) |>
#'     group_map(if_modify) |>
#'     simplify()
#'   
#'   .result <- sprintf(
#'     "function(.x) dplyr::case_when(
#'     %s,
#'     .default=.x
#'   )",
#'     paste0(.rules, collapse = ",\n")
#'   )
#'   
#'   if (parse) {
#'     .result <- parse(text = .result) |>
#'       eval()
#'   }
#'   
#'   .result
#' }
