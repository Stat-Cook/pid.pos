pos_tag <- function(docs, model="english-ewt"){
  #' @importFrom udpipe udpipe

  tagged <- tryCatch(
    udpipe(docs, model, model_dir = pid.pos_env$model_folder),
    error = function(e) stop("UDPipe Model can't be loaded/ downloaded.
                             Please run `browse_model_location()` to see if models are downloaded
                             and if not present download via `browse_udpipe_repo()`.")
  )
  tagged

}
