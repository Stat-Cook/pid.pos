pos_tag <- function(docs, 
                    model="english-ewt", 
                    .doc_id = NULL, 
                    catch=T){
  #' @importFrom udpipe udpipe
  #' @importFrom utf8 utf8_encode
  #' @noRd
  if (is.null(.doc_id)){
    .doc_id <- seq_along(docs)
  }

  if (is.numeric(.doc_id)){
    .doc_id <- paste("doc", .doc_id, sep = "")
  }

  utf8_docs <- utf8_encode(docs)
  names(utf8_docs) <- .doc_id
  
  if (catch){
    tagged <- tryCatch(
      udpipe(utf8_docs, model,
             model_dir = pid.pos_env$model_folder
      ),
      error = function(e) stop("UDPipe Model can't be loaded/ downloaded.
                             Please run `browse_model_location()` to see if models are downloaded
                             and if not present download via `browse_udpipe_repo()`.")
    )
  } else {
    tagged <- udpipe(utf8_docs, model,
                     model_dir = pid.pos_env$model_folder
    )
  }

  mutate(tagged, `Token No` = as.numeric(.data$`token_id`))

}

chunked_pos_tag <- function(docs, model="english-ewt", chunk_size=100,
                            doc_ids = NULL){
  #' @importFrom purrr map2
  #' @noRd

  if (is.null(doc_ids)){
    doc_ids <- seq_along(docs)
  }

  n <- length(docs)

  splits <- floor((1:n - 1) / chunk_size)
  jobs <- split(docs, splits)
  ids <- split(doc_ids, splits)

  pos_tagged <- map2(
    jobs, ids, 
    function(docs, ids) pos_tag(docs, model, ids),
    .progress=T
  )

  pos_tagged
}




