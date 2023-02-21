get_proper_nouns <- function(pos_frm){
  #' @importFrom dplyr filter

  pos_frm %>% filter(.data$xpos == "NNP")
}

