longer_than <- function(limit = 5) {
  #' Produces a function that checks if any strings in a vector is longer than 'limit'
devt  #'
  #' @param limit The length to check against
  #'
  #' @importFrom stringr str_length
  function(vec) {
    vec <- vec[!is.na(vec)]
    lengths <- str_length(vec)
    any(lengths > limit)
  }
}
