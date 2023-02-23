pos_tag <- function(docs, model="english-ewt", pb=NULL, doc_id = NULL){
  #' @importFrom udpipe udpipe
  if (is.null(doc_id)){
    doc_id <- seq_along(docs)
  }
  tagged <- tryCatch(
    udpipe(docs, model,
           model_dir = pid.pos_env$model_folder,
           doc_id = paste("doc", doc_id, sep = "")
    ),
    error = function(e) stop("UDPipe Model can't be loaded/ downloaded.
                             Please run `browse_model_location()` to see if models are downloaded
                             and if not present download via `browse_udpipe_repo()`.")
  )

  if (!is.null(pb)){
    pb$tick()
  }

  mutate(tagged, `Token No` = as.numeric(.data$`token_id`))

}

chunked_pos_tag <- function(docs, model="english-ewt", chunk_size=100, pb=NULL,
                            doc_ids = NULL){

  if (is.null(doc_ids)){
    doc_ids <- seq_along(docs)
  }

  n <- length(docs)

  splits <- floor((1:n - 1) / chunk_size)
  jobs <- split(docs, splits)
  ids <- split(doc_ids, splits)

  pos_tagged <- map2(
    jobs, ids, function(docs, ids) pos_tag(docs, model, pb, ids)
  )

  pos_tagged
}




