browse_udpipe_repo <- function(model = "english-ewt") {
  #' Open github link to the 'english-ewt-2.5' UD model.
  #'
  #' Intended for user download where `udpipe` fails to download automatically.
  #'
  #'
  #' @export
  #' @importFrom utils browseURL
  #'

  udpipe_repo <- with(
    pid.pos_env,
    {
      .date <- repo_dates[[udpipe_version]]
      .version <- udpipe_version
      .version.number <- stringr::str_extract(.version, "\\d.\\d$")

      url_root <- sprintf(
        "https://github.com/%s/blob/master/inst/udpipe-ud-%s-%s",
        .version, .version.number, .date
      )
      url_path <- sprintf("%s-ud-%s-%s.udpipe", model, .version.number, .date)
      paste(url_root, url_path, sep = "/")
    }
  )

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
