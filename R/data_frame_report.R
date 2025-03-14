
data_frame_report <- function(frm, 
                              chunk_size = 1e2,
                              to_remove = c()){
  #' Tags a data frame with part of speech tags.
  #' 
  #' @param frm A data frame to tag
  #' @param chunk_size The number of sentences to tag at a time
  #' @param to_remove A character vector of column names to remove from the data frame
  #'
  #' @export
  #'
  #' @importFrom dplyr group_by group_modify
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom dplyr where all_of
  tags <- data_frame_tagger(frm, chunk_size, to_remove)
  
  merge(
    tags$`Proper Nouns`,
    tags$Sentences,
    by.x = "doc_id", by.y = "ID"
  ) %>%
    select('doc_id', 'token', 'sentence', 'Repeats', 'Affected Columns') %>%
    arrange(doc_id)
}


