browse_udpipe_repo <- function(model = "english-ewt") {
  #' Open github link to the 'english-ewt-2.5' UD model.
  #'
  #' Intended for user download where `udpipe` fails to download automatically.
  #'
  #'
  #' @export
  #' @importFrom utils browseURL
  
  url_root <- "https://github.com/jwijffels/udpipe.models.ud.2.5/blob/master/inst/udpipe-ud-2.5-191206"
  url_path <- sprintf("%s-ud-2.5-191206.udpipe", model)
  udpipe_repo <- paste(url_root, url_path, sep = "/")
  browseURL(udpipe_repo)
}


browse_model_location <- function() {
  #' Browse user to folder for UDPipe models.
  #'
  #' Intended for usage in `udpipe` fails to download automatically.
  #'
  #' @export

  browseURL(pid.pos_env$model_folder)
}
