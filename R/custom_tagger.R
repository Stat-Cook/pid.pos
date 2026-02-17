#' Convert a POS tagging function to a tagger for the pid_pos package
#' 
#' This function converts a function for the tagging of a single sentence
#' into a function that can be used for the tagging of a whole document. The function
#' takes a function as an argument, which should have the following signature:
#' `function(sentence)
#' 
#' @param pos_function A function for the tagging of a single sentence, with the signature `function(sentence)`
#' 
#' @return A function that can be used for the tagging of a whole document, with the signature `function(docs, doc_ids=seq_along(docs))`
#' 
#' @examples
#' 
#' # Example of a POS tagging function for a single sentence
#' proper_nouns <- c("Alice", "Bob", "Charlie")
#' 
#' pos_function <- function(sentence){
#'   tokens <- unlist(strsplit(sentence, " "))
#'   
#'   data.frame(
#'     Token = tokens,
#'     upos = ifelse(tokens %in% proper_nouns, "PROPN", "OTHER")
#'   ) |>
#'     mutate(Sentence = sentence)
#'     
#' }
#' 
#' .tagger <- custom_tagger(pos_function)
#' 
#' docs <- c("Alice is here", "Bob is there", "Charlie is everywhere")
#' tagger(docs)
#' 
#' doc.frm <- data.frame(Text = docs)
#' pid_pos(doc.frm, tagger=.tagger, filter_func =  filter_to_proper_nouns)
#' 
custom_tagger <- function(pos_function) {
  if (!is.function(pos_function)) {
    type_error("`pos_function` must be a function.")
  }

  .formals <- formals(pos_function)  
  if (length(.formals) == 0) validation_error("`pos_function` must have at least one argument.")

  required_args <- .formals[names(.formals) != "..."]
  n_required <- sum(sapply(required_args, is.symbol))
  if (n_required > 1) validation_error("`pos_function` can't have more than one required argument.")
  
  function(docs, doc_ids = seq_along(docs)) {
    if (length(docs) == 0 || !is.character(docs)){
      validation_error("`docs` must be a non-empty character vector.")
    }
    
    purrr::map2(
      docs, doc_ids,
      ~ pos_function(.x) |>
          dplyr::mutate(doc_id = .y)
    ) |>
      purrr::list_rbind()
  }
}
