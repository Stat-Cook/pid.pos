

Ticker <- R6Class("Ticker", list(
  #' @importFrom R6 R6Class
  X = NA,
  initialize = function(){
    self$reset()
  },
  reset = function() self$X = 0,
  tick = function() {
    self$X <- self$X + 1
    print(self$X)
  }
))
