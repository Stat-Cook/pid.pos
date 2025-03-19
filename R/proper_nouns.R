get_proper_nouns <- function(pos_frm){
  #' This is a generic method that dispatches based on the first argument.
  #'
  #' @param pos_frm The data to be tagged for part of sentence
  #'
  UseMethod("get_proper_nouns", pos_frm)
}

get_proper_nouns.data.frame <- function(pos_frm){
  #' @importFrom dplyr filter

  noun_frame <- pos_frm %>% filter(.data$xpos == "NNP")

}

get_proper_nouns.list <- function(pos_frm){
  #' @importFrom dplyr filter

  lapply(pos_frm, get_proper_nouns)
}