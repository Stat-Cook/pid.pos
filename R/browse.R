

browse_udpipe_repo <- function(){
  udpipe_repo <- "https://github.com/jwijffels/udpipe.models.ud.2.5/blob/master/inst/udpipe-ud-2.5-191206/english-ewt-ud-2.5-191206.udpipe"
  browseURL(udpipe_repo)
}

browse_model_location <- function(){
  browseURL(pid.pos_env$model_folder)
}

browse_udpipe_repo()
browse_model_location()

udpipe(text2, "english-ewt", )
