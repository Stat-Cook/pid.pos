auto_replace <- function(frm, replacement.f) {
  #' Apply a replacement function to a `rules.frm`. 
  #' 
  #' Several function factories have been implemented to create replacement functions
  #' (`hashing_replacement.f`, `random_replacement.f`, `all_random_replacement.f`)
  #' 
  #' @param frm A `data.frame` with columns `If`, `From`, and `To`.
  #' @param replacement.f A function for transforming the `To` column.
  #'
  #' @return `data.frame`
  #' 
  #' @export
  frm |> 
    mutate(
      To = replacement.f(To)
    )
}


hashing_replacement.f <- function(key, salt="", hash=sha256){
  #' Function factory for hashing replacement.
  #' 
  #' @param key The hash key (passed to `hash`)
  #' @param salt The hash salt
  #' @param hash The desired hash function (default is `sha256` from `openssl` package).  
  #'    NB: other functions can be used, if they take `key` as a kew word argument.
  #'  
  #' @return `function`
  #'
  #' @importFrom openssl sha256
  #' @export

  key <- as.character(key)
  
  hash_function <- function(x) {
    paste(x, salt, sep = "_") |> 
      hash(key=key)
  }
  
  hash_function
} 

#' @importFrom R6 R6Class
RandomReplacer <- R6Class(
  "RandomReplacer",
  list(
    size = NA,
    space = NA,
    max_replacements = NA,
    dictionary = c(),
    
    initialize = function(size, space){
      self$size = size
      self$space = space
      self$max_replacements = length(space)^size
    },
    
    generate_suggestions = function(n){
      sample(self$space, self$size*n, replace = TRUE) |>
        matrix(ncol = self$size, byrow = TRUE) |>
        apply(1, paste0, collapse = "")
    },
    
    learn = function(x){
      x.distinct <- unique(x)
      desired.length <- length(x.distinct)
      
      if (desired.length > self$max_replacements) {
        stop("More replacements than `size` and `space` allow without collisions.
             Please increase either and try again.")
      }
      
      if (desired.length > self$max_replacements / 2){
        warning("You are learning more replacements than half of the maximum allowed.
                This may cause repeated delays due to repeated sampling of the same replacement.
                If performance is poor, increase `size` or `space` to allow for more replacements.")
      }
      
      unique_suggested <- unique(self$generate_suggestions(desired.length))
      unique_length <- length(unique_suggested)
      
      while (unique_length < desired.length) {
        new_suggestions <- self$generate_suggestions(desired.length)
        to_add <- setdiff(new_suggestions, unique_suggested)
  
        unique_suggested <- c(unique_suggested, to_add)
        unique_length <- length(unique_suggested)
      }
      
      self$dictionary <- unique_suggested[1:desired.length]
      names(self$dictionary) <- x.distinct
    },
    
    transform = function(x){
      simplify(self$dictionary[x])
    }
  )
)

random_replacement.f <- function(replacement_size=10, replacement_space=LETTERS){
  #' Function factory for random replacement.
  #' 
  #' It is designed to generate a replacement by a random combination of 
  #' alpha-numeric characters, and apply the same replacement if the input is repeated.
  #' 
  #' 
  #' @param replacement_size The size of the replacement (number of characters in each replacement).
  #' @param replacement_space The space from which to sample replacements (default is `LETTERS`).
  #' 
  #' @return `function`
  
  .replace <- RandomReplacer$new(replacement_size, replacement_space)
  
  function(x){
    x <- as.character(x)
    .replace$learn(x)
    .replace$transform(x)
  }  
}

all_random_replacement.f <- function(replacement_size=10, replacement_space=LETTERS){
  #' Function factory for random replacement.
  #' 
  #' It is designed to generate a replacement by a random combination of 
  #' alpha-numeric characters, and apply a unique replacement to each instance
  #' of the same input.
  #' 
  #' 
  #' @param replacement_size The size of the replacement (number of characters in each replacement).
  #' @param replacement_space The space from which to sample replacements (default is `LETTERS`).
  #' 
  #' @return `function`
    
  .replace <- RandomReplacer$new(replacement_size, replacement_space)
  
  function(x){
    x <- seq_along(x)
    .replace$learn(x)
    .replace$transform(x)
  }  
}
