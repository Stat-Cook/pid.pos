convert_frame_to_context <- function(noun_frame, tag_frm, margin=4, pb=NULL){
  UseMethod("convert_frame_to_context", noun_frame)
}

convert_frame_to_context.default <- function(noun_frame, tag_frm, margin=4, pb=NULL){
  if (nrow(noun_frame) == 0){
    return(data.frame())
  }

  result_list <- lapply(
    1:nrow(noun_frame),
    function(i) convert_row_to_context(noun_frame[i,], tag_frm, margin)
  )

  data.frame(do.call(rbind, result_list))
}

convert_frame_to_context.list <- function(noun_frame, tag_frm, margin=4, pb=NULL){
  result_list <- lapply(
    1:length(noun_frame),
    function(i) {
      result <- convert_frame_to_context(noun_frame[[i]], tag_frm[[i]], margin, pb)

      if (!is.null(pb)){
        pb$tick()
      }

      result
    }
  )

  data.frame(do.call(rbind, result_list))
}

convert_row_to_context <- function(row, tag_frm, margin = 4){
  #' @importFrom dplyr filter
  #' @importFrom purrr prepend
  #' @noRd

  tid <- row$`Token No`

  interval_start <- max(1, tid - margin)
  interval_end <- tid + margin

  para <- tag_frm %>%
    filter(.data$doc_id == row$doc_id,
           .data$paragraph_id == row$paragraph_id,
           .data$sentence_id == row$sentence_id)

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
