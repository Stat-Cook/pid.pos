proper_noun_report <- function(text){
  #' Detect examples of proper nouns in free text via natural language processing
  #'
  #' Given a passage of text or a vector of multiple documents - perform part of speech (POS)
  #' tagging and return any example of proper nouns with context.  Default POS taging is via
  #' the udpipe package and the 'English EWT 2.5' library
  #'
  #' @param text A passage of free text or vector of free text.
  #'
  #' @return list with `Proper Noun`, `All Tags` and `Raw Text` data frames
  #' @importFrom dplyr mutate
  #' @importFrom magrittr %>%
  #' @importFrom rlang .data
  #' @export
  raw_text <- data.frame(Document = text, doc_id=1:length(text))

  tag_frm <- pos_tag(text)  %>%
    mutate(`Token No` = as.numeric(.data$`token_id`))
  pns <- get_proper_nouns(tag_frm)
  n <- nrow(pns)

  if (n == 0){
    return(data.frame())
  }

  result_list <- lapply(
    1:nrow(pns), function(i) convert_row_to_context(pns[i,], tag_frm, 4)
  )
  result <- do.call(rbind, result_list) %>% data.frame()

  .lis <- list(`Proper Nouns` = result, `All Tags` = tag_frm,
               `Raw Text` = raw_text)

  print(result)
  invisible(.lis)

}
