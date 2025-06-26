summarize_repeated_setences <- function(frm, ...) {
  #' @importFrom utils head read.csv write.csv
  first <- head(frm, 1)
  first$Repeats <- nrow(frm)
  first$`Affected Columns` <- paste(
    glue("`{unique(frm$Column)}`"),
    collapse = ", "
  )
  first
}


remove_if_exists <- function(frm, to_remove) {
  to_remove <- intersect(colnames(frm), to_remove)
  frm %>% select(-all_of(to_remove))
}


data_frame_tagger <- function(frm, chunk_size = 1e2,
                              to_remove = c()) {
  #' Tags a data frame with part of speech tags
  #'
  #' @param frm A data frame to tag
  #' @param chunk_size The number of sentences to tag at a time
  #' @param to_remove A character vector of column names to remove from the data frame
  #'
  #' @export
  #'
  #' @importFrom dplyr group_by group_modify row_number ungroup
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom dplyr where all_of filter
  #' @importFrom purrr simplify

  Sentence <- upos <- doc_id <- NA

  character.frm <- frm %>%
    select(where(is.character)) %>%
    remove_if_exists(to_remove)


  if (any(dim(character.frm) == 0)) {
    return(list(
      `All Tags` = NULL,
      `Proper Nouns` = NULL,
      `Sentences` = NULL
    ))
  }

  doc.grid <- expand.grid(
    Row = rownames(character.frm),
    Column = colnames(character.frm)
  ) |>
    mutate(
      Sentence = simplify(character.frm),
      PK = row_number()
    )


  sentence.frm <- group_by(doc.grid, Sentence) %>%
    group_modify(summarize_repeated_setences) |>
    ungroup() |>
    mutate(
      ID = glue("Col:{Column} Row:{Row}")
    )

  tag_frm <- chunked_pos_tag(sentence.frm$Sentence,
    chunk_size = chunk_size,
    doc_ids = sentence.frm$ID
  )

  tag_frm <- do.call(rbind, tag_frm)

  pnouns <- tag_frm %>%
    filter(upos == "PROPN") %>%
    rename(ID = doc_id) |>
    select("ID", "token", "sentence")

  list(
    `All Tags` = tag_frm,
    `Proper Nouns` = pnouns,
    `Sentences` = sentence.frm
  )
}
