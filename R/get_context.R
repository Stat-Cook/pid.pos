#  #' Get the context of a token in a sentence.
#'
#' NB: to set the context window size, use `set_context_window()`.
#'
#' @param sentences A character vector of sentences.
#' @param tokens A character vector of tokens.
#' @param context_window The width of window around the token to be taken.
#'
#' @importFrom dplyr mutate
#' @importFrom stringr str_locate str_sub
#' @importFrom tibble as_tibble
#'
#' @keywords internal

get_context <- function(sentence, token,
                        context_window = getOption("pid_pos_context_window")) {
  loc <- stringr::str_locate(sentence, token)

  # If token not found, return NA
  if (any(is.na(loc))) {
    return(NA_character_)
  }

  start <- loc[1]
  end <- loc[2]
  sent_len <- stringr::str_length(sentence)

  from <- max(start - context_window, 1)
  to <- min(end + context_window, sent_len)

  ctx <- stringr::str_sub(sentence, from, to)
  ctx <- paste0(if (from > 1) "..." else "", ctx, if (to < sent_len) "..." else "")

  ctx
}

# get_context <- function(sentences, tokens) {
#
#   context_window <- getOption("pid.pos.context_window")
#
#   context.frm <- str_locate(sentences, tokens) |>
#     as_tibble() |>
#     mutate(
#       Sentence = sentences,
#       Token = tokens,
#       SentenceLength = str_length(Sentence),
#       ContextFrom = pmax(start - context_window, 1),
#       ContextTo = pmin(end + context_window, SentenceLength),
#       Context = str_sub(Sentence, start = ContextFrom, end = ContextTo),
#       Prepend = ifelse(ContextFrom == 1, "", "..."),
#       Append = ifelse(ContextTo == SentenceLength, "", "..."),
#       Context = sprintf("%s%s%s", Prepend, Context, Append)
#     )
#
#   context.frm$Context
# }


set_context_window <- function(x) {
  #' Set the context window size for the `get_context` function.
  #'
  #' @param x  An integer specifying the number of characters to include
  #'   before and after the token in the context.
  #'
  #' @keywords internal
  .opt <- list("pid_pos_context_window" = x)

  options(.opt)
}
