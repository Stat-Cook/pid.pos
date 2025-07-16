most_common <- function(cnt, names){
  names(cnt) <- names
  names(which.max(cnt))
}


summary.pid_report <- function(object, ...){
  #' Summary mehtod for class `pid_report`.
  #' 
  #' @param object An object of class `pid_report`.  
  #' 
  #' @return A data frame describing any column determined to contain PID.
  #' \itemize{
  #'   \item Column
  #'   \item Cases of Proper Nouns - the number of sentences with proper nouns in the column
  #'   \item Unique Cases of Proper Nouns - the number of unique sentences with proper nouns in the column
  #'   \item Most Common Proper Noun Sentence - the most commonly occurring sentence containing proper nouns.
  #' }
  #' 
  #' 
  #' @importFrom dplyr distinct bind_rows summarise
  #' @importFrom dplyr n
  #' @importFrom purrr map
  #' @importFrom stringr str_detect str_extract_all
  #' @exportS3Method 
  #' @keywords internal
  
  object <- as_tibble(object)

  .distinct <- distinct(object, Sentence, Repeats, `Affected Columns`) 
  .uni <- unique(object$`Affected Columns`)
  affected.cols <- unique(simplify(str_extract_all(.uni, "`.*?`")))
  
  map(
    affected.cols,
    ~ object |>
        filter(str_detect(`Affected Columns`, .x)) |>
        distinct(Sentence, Repeats) |>
        summarise(
          `Column` = .x,
          `Cases of Proper Nouns` = sum(Repeats),
          `Unique Cases of Proper Nouns` = n(),
          `Most Common Proper Noun Sentence` = most_common(Repeats, Sentence)
        )
  ) |>
    bind_rows() 
}

