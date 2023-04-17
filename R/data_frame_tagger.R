longer_than <- function(limit=5){
  function(vec){
    vec <- vec[!is.na(vec)]
    lengths <- stringr::str_length(vec)
    any(lengths > limit)
  }
}


first <- function(frm, ...){
  first <- head(frm, 1)
  first$Repeats <- nrow(frm)
  first
}


data_frame_tagger <- function(frm, chunk_size = 1e2, ..., str_length_limit=3){
  #' @export
  characters <- frm %>%
      select(where(is.character))%>%
      select(where(longer_than(str_length_limit=str_length_limit))) # %>% TODO: exclude columns


  doc.id.grid <- expand.grid(rows=rownames(characters), cols = colnames(characters))

  doc.id <- glue::glue("Doc{seq_len(nrow(doc.id.grid))} \\
                       Col:{doc.id.grid$cols} \\
                       Row:{doc.id.grid$rows}")

  sent <- characters[!is.na(characters)]
  sentence.id <- doc.id[!is.na(characters)]

  sentence.frm <- data.frame(ID = sentence.id, Sentence = sent) %>%
    group_by(Sentence) %>% group_modify(first)


  max.ticks <- ceiling(nrow(sentence.frm) / chunk_size)
  pb <- progress::progress_bar$new(total = max.ticks)

  tag_frm <- chunked_pos_tag(sentence.frm$Sentence,
                             chunk_size=chunk_size,
                             doc_ids=sentence.frm$ID,
                             pb=pb)

  tag_frm <- do.call(rbind, tag_frm)

  pnouns <- tag_frm %>%
    filter(upos == "PROPN") %>%
    select(doc_id, token, sentence)

  list(
    `All Tags` = tag_frm,
    `Proper Nouns` = pnouns
  )

}


