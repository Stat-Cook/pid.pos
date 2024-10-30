browse_udpipe_repo <- function(){
  #' Open github link to the 'english-ewt-2.5' UD model.
  #'
  #' Intended for user download where `udpipe` fails to download automatically.
  #'
  #'
  #' @export
  #' @importFrom utils browseURL
  udpipe_repo <- "https://github.com/jwijffels/udpipe.models.ud.2.5/blob/master/inst/udpipe-ud-2.5-191206/english-ewt-ud-2.5-191206.udpipe"
  browseURL(udpipe_repo)
}

browse_model_location <- function(){
  #' Browse user to folder for UDPipe models.
  #'
  #' Intended for usage in `udpipe` fails to download automatically.
  #'
  #' @export

  browseURL(pid.pos_env$model_folder)
}
