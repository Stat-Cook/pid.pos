get_context <- function(sentences, tokens) {
  #' Get the context of a token in a sentence.
  #'
  #' NB: to set the context window size, use `set_context_window()`.
  #'
  #' @param sentences A character vector of sentences.
  #' @param tokens A character vector of tokens.
  #'
  #'
  #' @importFrom dplyr mutate
  #' @importFrom stringr str_locate str_sub
  #' @importFrom tibble as_tibble
  #'
  #' @keywords internals
  context_window <- getOption("pid.pos.context_window")

  context.frm <- str_locate(sentences, tokens) |>
    as_tibble() |>
    mutate(
      Sentence = sentences,
      Token = tokens,
      SentenceLength = str_length(Sentence),
      ContextFrom = pmax(start - context_window, 1),
      ContextTo = pmin(end + context_window, SentenceLength),
      Context = str_sub(Sentence, start = ContextFrom, end = ContextTo),
      Prepend = ifelse(ContextFrom == 1, "", "..."),
      Append = ifelse(ContextTo == SentenceLength, "", "..."),
      Context = sprintf("%s%s%s", Prepend, Context, Append)
    )

  context.frm$Context
}

set_context_window <- function(x) {
  #' Set the context window size for the `get_context` function.
  #'
  #' @param x  An integer specifying the number of characters to include
  #'   before and after the token in the context.
  #'
  #' @keywords internals
  .opt <- list("pid.pos.context_window" = x)
  options(.opt)
}
