start_app <- function(){
  #' Launch the PID app
  #'
  #' @export
  app.dir <- system.file("app", package="pid.pos")
  shiny::runApp(app.dir)
}
