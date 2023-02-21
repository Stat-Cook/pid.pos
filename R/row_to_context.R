convert_row_to_context <- function(row, tag_frm, margin = 4){
  #' @importFrom dplyr filter
  #' @importFrom purrr prepend
  row$token_id

  tid <- as.numeric(row$token_id)

  interval_start <- max(1, tid - margin)
  interval_end <- tid + margin

  para <- tag_frm %>%
    filter(.data$doc_id == row$doc_id,
           .data$paragraph_id == row$paragraph_id)

  context_window <- para %>%
    filter(.data$`Token No` <= interval_end,
           .data$`Token No` >= interval_start)

  context_tokens <- context_window$token

  if (interval_start > 1){
    context_tokens <- prepend(context_tokens, "...")
  }
  if (interval_end < max(para$`Token No`)){
    context_tokens <- append(context_tokens, "...")
  }

  c(Token = row$token,
    doc_id = row$doc_id,
    paragraph_id = row$paragraph_id,
    Context = paste(context_tokens, collapse=" ")
    )
}
