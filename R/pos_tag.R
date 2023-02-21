
pos_tag <- function(docs, model=pid.pos_env$model){
  #' @importFrom udpipe udpipe_annotate
  as.data.frame(udpipe_annotate(model, docs))
}
