

proper_noun_report <- function(text, context_margin=4, chunk_size = 100, progress_bar=NULL,
                               verbose = FALSE){
  #' Detect examples of proper nouns in free text via natural language processing
  #'
  #' Given a passage of text or a vector of multiple documents - perform part of speech (POS)
  #' tagging and return any example of proper nouns with context.  Default POS taging is via
  #' the udpipe package and the 'English EWT 2.5' library
  #'
  #' @param text A passage of free text or vector of free text.
  #' @param context_margin The number of tokens either side of proper nouns to report
  #' @param chunk_size The no. of docs per batche to process
  #' @param progress_bar An object with method 'tick()' for tracking progress
  #' @param verbose Boolean flag to print results
  #'
  #' @return list with `Proper Noun`, `All Tags` and `Raw Text` data frames
  #' @importFrom dplyr mutate
  #' @importFrom magrittr %>%
  #' @importFrom rlang .data
  #' @export
  raw_text <- data.frame(Document = text, doc_id=1:length(text))

  tag_frm <- chunked_pos_tag(text, chunk_size=chunk_size, pb=progress_bar,
                             doc_ids=raw_text$doc_id)

  pns <- get_proper_nouns(tag_frm)

  result <- convert_frame_to_context(pns, tag_frm, 4, pb=progress_bar)

  .lis <- list(`Proper Nouns` = result, `All Tags` = tag_frm,
               `Raw Text` = raw_text)

  if (verbose){
    print(result)
  }
  invisible(.lis)

}
