pid.pos_app <- function(){
  #' Launch the PID app
  #' @importFrom purrr map2
  #' @importFrom dplyr select
  #' @importFrom shiny runApp
  #' @export
  app.dir <- system.file("app", package="pid.pos")
  runApp(app.dir)
}

# TODO: Rename shiny start function to a project dependent name.

# null.init <- function(...){
#   for (i in c(...)){
#     assign(i, NULL, pos=sys.frame(-1))
#   }
# }
