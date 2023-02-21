#' @importFrom udpipe udpipe_load_model
#' @importFrom rappdirs user_data_dir

pid.pos_env <- new.env()

pid.pos_env$deault_model_location <- system.file("english-ewt-ud-2.5-191206.udpipe", package="pid.pos")
pid.pos_env$model_location <- pid.pos_env$deault_model_location

load_udpipe <- function(model.location=pid.pos_env$deault_model_location){
  model <- udpipe_load_model(model.location)
  pid.pos_env$model <- model
  model
}

pid.pos_env$default_model <- load_udpipe()
pid.pos_env$app_data_dir <- user_data_dir("pid.pos")
