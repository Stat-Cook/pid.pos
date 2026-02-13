#' Creates a tagging function using the specified UDPipe model.
#'
#' @param model The UDPipe model to use.
#' @param model_dir Directory where models are stored.
#' @param udpipe_repo Repository URL for UDPipe models.
#' @return A function that tags documents.
#' @export
#' @examples
#' ewt_tagger <- udpipe_factory("english-ewt")
#' ewt_tagger(c("This is a test.", "Another sentence."))
#' 
#' gum_tagger <- udpipe_factory("english-gum")
#' gum_tagger(c("This is a test.", "Another sentence."))
#' 
#' lines_tagger <- udpipe_factory("english-lines")
#' lines_tagger(c("This is a test.", "Another sentence."))
#' 
udpipe_factory <- function(model = "english-ewt",
                           model_dir = pid.pos_env$model_folder,
                           udpipe_repo = pid.pos_env$udpipe_version) {
  
  function(docs, doc_ids = NULL) {
    
    if (!is.character(docs) || length(docs) == 0) {
      stop("`docs` must be a non-empty character vector.", call. = FALSE)
    }
    
    doc_ids <- format_doc_id(docs, doc_ids)
    
    utf8_docs <- utf8_encode(docs)
    names(utf8_docs) <- doc_ids
    
    tagged <- tryCatch(
      udpipe::udpipe(
        utf8_docs,
        model,
        model_dir = model_dir,
        udpipe_model_repo = udpipe_repo
      ),
      error = function(e) {
        stop(
          paste0(
            "UDPipe model could not be loaded.\n",
            "Original error: ", e$message, "\n",
            "Please run `browse_model_location()` to see if models are downloaded\n",
            "If not present download via `browse_udpipe_repo()."
          ),
          call. = FALSE
        )
      }
    )
    
    tagged |>
      dplyr::mutate(`TokenNo` = as.numeric(.data$token_id)) |>
      dplyr::rename(
        ID = doc_id,
        Token = token,
        Sentence = sentence
      ) |>
      tibble::as_tibble()
  }
}
