#' @importFrom udpipe udpipe_load_model
#' @importFrom rappdirs user_data_dir 
function() {}

pid.pos_env <- new.env()

pid.pos_env$deault_model_folder <- user_data_dir("pid.pos")
pid.pos_env$model_folder <- pid.pos_env$deault_model_folder
