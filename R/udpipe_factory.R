#' Create a UDPipe tagging function
#'
#' Returns a function that tags text documents using a specified UDPipe model.
#' The returned function accepts a character vector of documents and returns
#' a tibble with tokens, sentences, and token metadata.
#'
#' @param model Character. The name of the UDPipe model to use. Defaults to `"english-ewt"`.
#' @param model_dir Character. Directory where UDPipe models are stored. Defaults to `pid.pos_env$model_folder`.
#' @param udpipe_repo Character. URL or path of the UDPipe model repository. Defaults to `pid.pos_env$udpipe_version`.
#'
#' @return A function that takes a character vector of documents and returns a `tibble`
#' with columns:
#' \describe{
#'   \item{ID}{Document identifier}
#'   \item{Token}{Individual token text}
#'   \item{Sentence}{Sentence containing the token}
#'   \item{upos}{The universal parts of speech tag of the token. See https://universaldependencies.org/format.html}
#' }
#' and all columns returned by the `udpipe::udpipe()` function for each token.
#'
#' @export
#'
#' @examples
#' # Create a tagger for the English EWT model
#' ewt_tagger <- udpipe_factory("english-ewt")
#' docs <- c("This is a test.", "Another sentence.")
#' ewt_tagger(docs)
#'
#' # Create a tagger for the English GUM model
#' gum_tagger <- udpipe_factory("english-gum")
#' gum_tagger(docs)
#'
#' # Create a tagger for the English LINES model
#' lines_tagger <- udpipe_factory("english-lines")
#' lines_tagger(docs)

udpipe_factory <- function(model = "english-ewt",
                           model_dir = pid.pos_env$model_folder,
                           udpipe_repo = pid.pos_env$udpipe_repo) {
  function(docs, doc_ids = NULL) {
    if (!is.character(docs) || length(docs) == 0) {
      type_error("`docs` must be a non-empty character vector.", call = caller_env())
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
        msg <- conditionMessage(e)
        if (grepl("File.*does not exist", msg)) {
          file_not_found_error(
            paste0(
              "UDPipe model could not be loaded.\n",
              "Original error: ",
              e$message,
              "\n",
              "Please run `browse_model_location()` to see if models are downloaded.\n",
              "If not present download via `browse_udpipe_repo()."
            ),
            call. = FALSE
          )
        }
        stop(e)
      }
    )
    
    result <- tagged |>
      dplyr::mutate(`TokenNo` = as.numeric(.data$token_id)) |>
      dplyr::rename(ID = doc_id,
                    Token = token,
                    Sentence = sentence) |>
      tibble::as_tibble()
    
    select(result, ID, Token, Sentence, upos, all_of(colnames(result)))
  }
}
