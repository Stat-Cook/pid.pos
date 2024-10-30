longer_than <- function(limit=5){
  #' Produces a function that checks if any strings in a vector is longer than 'limit'
  #' 
  #' @param limit The length to check against
  #' @examples 
  #' longer_than_5 <- longer_than(5)
  #' .str <- c("ABCDE", "ABC", "ABCDEFG")
  #' longer_than_5(.str)
  #' 
  #' @importFrom stringr str_length
  #' 
  #' @export
  function(vec){
    vec <- vec[!is.na(vec)]
    lengths <- str_length(vec)
    any(lengths > limit)
  }
}

first <- function(frm, ...){
  #' @importFrom utils head read.csv write.csv
  first <- head(frm, 1)
  first$Repeats <- nrow(frm)
  first$`Affected Columns` <- paste(
    glue("`{unique(frm$Column)}`"),
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
  #' Tags a data frame with part of speech tags.
  #' 
  #' @param frm A data frame to tag
  #' @param chunk_size The number of sentences to tag at a time
  #' @param to_remove A character vector of column names to remove from the data frame
  #'
  #' @export
  #'
  #' @importFrom dplyr group_by group_modify
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom dplyr where all_of
  
  Sentence <- upos <- doc_id <- NA
  
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

  sentence.frm <- group_by(sentence.frm.raw, Sentence) %>%
    group_modify(first)
  sentence.frm$ID <- glue("Doc{sentence.frm$Index} Row:{sentence.frm$Row} Col:{sentence.frm$Column}")

  max.ticks <- ceiling(nrow(sentence.frm) / chunk_size)
  pb <- progress_bar$new(total = max.ticks)

  tag_frm <- chunked_pos_tag(sentence.frm$Sentence,
                             chunk_size=chunk_size,
                             doc_ids=sentence.frm$ID,
                             pb=pb)

  tag_frm <- do.call(rbind, tag_frm)

  pnouns <- tag_frm %>%
    filter(upos == "PROPN") %>%
    select('doc_id', 'token', 'sentence')

  list(
    `All Tags` = tag_frm,
    `Proper Nouns` = pnouns,
    `Sentences` = sentence.frm
  )

}


