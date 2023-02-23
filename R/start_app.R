start_app <- function(){
  #' Launch the PID app
  #' @importFrom purrr map2
  #' @importFrom dplyr select
  #' @export
  app.dir <- system.file("app", package="pid.pos")
  shiny::runApp(app.dir)
}
