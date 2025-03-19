longer_than <- function(limit=5){
  #' Produces a function that checks if any strings in a vector is longer than 'limit'
  #' 
  #' @param limit The length to check against
  #' @examples 
  #' longer_than_5 <- longer_than(5)
  #' .str <- c("ABCDE", "ABC", "ABCDEFG")
  #' longer_than_5(.str)
  #' 
  #' @importFrom stringr str_length
  #' 
  #' @export
  function(vec){
    vec <- vec[!is.na(vec)]
    lengths <- str_length(vec)
    any(lengths > limit)
  }
}
