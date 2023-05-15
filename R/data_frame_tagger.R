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
  first$`Affected Columns` <- paste(
    glue::glue("`{unique(frm$Column)}`"),
    collapse = ", "
  )
  first
}

remove_if_exists <- function(frm, to_remove){
  to_remove <- intersect(colnames(frm), to_remove)
  frm %>% select(-all_of(to_remove))
}

data_frame_tagger <- function(frm, chunk_size = 1e2,
                              to_remove = c()){
  #' @export
  characters <- frm %>%
      select(where(is.character))%>%
      remove_if_exists(to_remove)
      # select(where(longer_than(limit=str_length_limit))) # %>% TODO: exclude columns


  doc.id.grid <- expand.grid(rows=rownames(characters), cols = colnames(characters))

  # doc.id <- glue::glue("Doc{seq_len(nrow(doc.id.grid))} \\
  #                      Col:{doc.id.grid$cols} \\
  #                      Row:{doc.id.grid$rows}")

  index <- seq_len(nrow(doc.id.grid))
  sel <- !is.na(characters)
  sent <- characters[sel]
  rows <- doc.id.grid$rows[sel]
  cols <- doc.id.grid$cols[sel]
  index <- index[sel]

  if (length(sent) == 0){
    return(  list(
      `All Tags` = NULL,
      `Proper Nouns` = NULL
    ))
  }

  sentence.frm.raw <- data.frame(Sentence = sent, Column = cols, Row = rows, Index=index)

  sentence.frm <- group_by(sentence.frm.raw, Sentence) %>% group_modify(pid.pos:::first)
  sentence.frm$ID <- glue::glue("Doc{sentence.frm$Index} Row:{sentence.frm$Row} Col:{sentence.frm$Column}")

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


