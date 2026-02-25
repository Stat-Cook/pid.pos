CachedRedact <- R6::R6Class("CachedRedact", list(
  redacted = character(),
  redact_function = NA,
  
  initialize = function(redact_function) {
    self$redact_function <- redact_function
  },
  recode = function(vec) {
   
    keys <- unique(vec[!is.na(vec)])
    uncoded <- self$get_uncoded_keys(keys)

    if (length(uncoded) > 0) {
      new <- self$redact_function(uncoded)
      names(new) <- uncoded

      self$redacted <- c(self$redacted, new)
    }

    out <- self$redacted[vec]
    out[is.na(vec)] <- NA_character_
    unname(out)
    
  },
  get_uncoded_keys = function(vec) {
    setdiff(vec, names(self$redacted))
  }
))

#' @exportS3Method 
print.CachedRedact <- function(x, ...){
  sprintf("CachedRedact Object [size=%s]", length(x$redacted)) |>
    print()
}


cached_redact_factory <- function(redact.function) {
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

  structure(
    .f,
    class = "cached_redact_function",
    cache = cr
  )
}

#' @exportS3Method 
print.cached_redact_function <- function(x, ...){

  sprintf("`cached_redact_function` [size=%s]", 
          length(attr(x, "cache")$redacted)) |>
    print()
}

