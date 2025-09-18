CachedRedact <- R6::R6Class("CachedRedact", list(
  redacted = NA,
  redact_function = NA,
  initialize = function(redact_function) {
    self$redact_function <- redact_function
  },
  recode = function(vec) {
    .unique <- unique(vec)
    uncoded <- self$get_uncoded_keys(.unique)

    if (length(uncoded) > 0) {
      new <- self$redact_function(uncoded)
      names(new) <- uncoded

      self$redacted <- c(self$redacted, new)
    }

    .vec <- self$redacted[vec]
    .vec <- unname(.vec)
    .vec
  },
  get_uncoded_keys = function(vec) {
    setdiff(vec, names(self$redacted))
  }
))



efficient_redact_factory <- function(redact.function) {
  #' Stateful recoding template function
  #'
  #' Dynamic programming wrapper to a mono-variable function - performs
  #' given recoding function on unique values and recycles previous states.
  #'
  #' @param redact.function A single input function to perform variable recoding.
  #'
  #' @returns A function
  #'
  #'
  cr <- CachedRedact$new(redact.function)

  .f <- function(vec) {
    cr$recode(vec)
  }

  class(.f) <- c("efficient.redact.function", class(.f))
  .f
}


divide_map <- function(frm, func, n = NULL, .progress = T) {
  if (is.null(n)) {
    n <- round(sqrt(nrow(frm)))
  }

  .split <- seq(0, 1, by = 1 / nrow(frm))
  .split <- ceiling(n * .split)
  .split <- .split[-1]

  .grps <- split(frm, .split)

  map(.grps, func, .progress = .progress) |>
    bind_rows()
}


efficient_redaction <- function(frm, redact, n = NULL, .progress = T) {
  #' A wrapper for efficient redaction.
  #' 
  #' @param frm The data frame to be redacted
  #' @param redact A  function which converts free text to redacted text.
  #' @param n The number of chunks to split the data frame into for processing.
  #' @param .progress Whether to show a progress bar.
  #' 
  #' 
  #' @export 
  UseMethod("efficient_redaction", redact)
}

efficient_redaction.efficient.redact.function <- function(frm, redact, n = NULL, .progress = T) {
  #' @exportS3Method
  #'

  .mutate <- function(frm) {
    mutate(frm, across(where(is.character), \(i) redact(i)))
  }

  divide_map(frm, .mutate, n, .progress)
}

efficient_redaction.default <- function(frm, redact, n = NULL, .progress = T) {
  #' @exportS3Method
  #'

  efficient.f <- efficient_redact_factory(redact)
  efficient_redaction(frm, efficient.f, n = n, .progress = .progress)
}
