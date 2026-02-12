tagger_factory <- function(model = "english-ewt", 
                           model_dir = pid.pos_env$model_folder,
                           udpipe_repo = pid.pos_env$udpipe_version) {
  #' 
  #' Creates a tagging function using the specified UDPipe model.
  #' 
  #' @param model The UDPipe model to use for tagging.
  #' @param model_dir The directory where the UDPipe model is stored.
  #' @return A function that tags documents using the specified UDPipe model.
  #' 
  #' @importFrom udpipe udpipe
  #' @importFrom dplyr mutate
  #' @export
  #' @examples
  #' ewt_tagger <- tagger_factory("english-ewt")
  #' ewt_tagger(c("This is a test.", "Another sentence."))
  #' 
  #' gum_tagger <- tagger_factory("english-gum")
  #' gum_tagger(c("This is a test.", "Another sentence."))
  #' 
  #' lines_tagger <- tagger_factory("english-lines")
  #' lines_tagger(c("This is a test.", "Another sentence."))
  #' 
  #' 
  function(docs,
           doc_id = NULL) {
    if (is.null(doc_id)) {
      .doc_id <- seq_along(docs)
    }
    
    if (is.numeric(doc_id)) {
      .doc_id <- paste("doc", doc_id, sep = "")
    }
    
    utf8_docs <- utf8_encode(docs)
    names(utf8_docs) <- doc_id

    tagged <- tryCatch(
      udpipe(utf8_docs, model, model_dir = model_dir, udpipe_model_repo=udpipe_repo),
      error = function(e){
        print(e$message)
        stop(
          "UDPipe Model can't be loaded/ downloaded.
                           Please run `browse_model_location()` to see if models are downloaded
                           and if not present download via `browse_udpipe_repo()`."
        )
    })
    
    mutate(tagged, `Token No` = as.numeric(.data$`token_id`))
  }
}


tag_documents <- function(docs,
                          doc_ids=NULL,
                          tagger = tagger_factory(),
                          chunk_size = 100) {
  #' @examples
  #' example.text <- head(the_one_in_massapequa$text, 20)
  #' 
  #' ewt_tagger <- tagger_factory("english-ewt")
  #' tag_documents(example.text, tagger=ewt_tagger)
  #' 
  #' gum_tagger <- tagger_factory("english-gum")
  #' tag_documents(example.text, tagger=gum_tagger)
  #' 
  #' lines_tagger <- tagger_factory("english-lines")
  #' tag_documents(example.text, tagger=lines_tagger)
  #' 
  if (is.null(doc_ids)) {
    doc_ids <- seq_along(docs)
  }
  
  n <- length(docs)
  
  splits <- floor((1:n - 1) / chunk_size)
  jobs <- split(docs, splits)
  ids <- split(doc_ids, splits)
  
  tagged <- map2(jobs, ids, function(docs, ids)
    tagger(docs, id), .progress = T)
  bind_rows(tagged)
}


tag_data_frame <- function(frm,
                           tagger = "english-ewt",
                           chunk_size = 1e2,
                           to_ignore = c()) {
  #' Tags a data frame with part of speech tags
  #'
  #' @param frm A data frame to tag
  #' @param tagger Either a string naming a UDPipe model (see `tagger_factory` for the list of models)
  #'   or a custom tagging function (see `tagger_factory` for details of what is required).
  #' @param chunk_size The number of sentences to tag at a time
  #' @param to_ignore A character vector of column names to remove from the data frame
  #'
  #' @importFrom dplyr group_by group_modify row_number ungroup
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom dplyr where all_of filter
  #' @importFrom purrr simplify
  #' @examples
  #' example.data <- head(the_one_in_massapequa, 20)
  #' 
  #' tag_data_frame(example.data, tagger="english-ewt")
  #' tag_data_frame(example.data, tagger="english-gum")
  #' tag_data_frame(example.data, tagger="english-lines")
  #' 
  #' ewt_tagger <- tagger_factory("english-ewt")
  #' tag_data_frame(example.data, tagger=ewt_tagger)
  #' 
  #' gum_tagger <- tagger_factory("english-gum")
  #' tag_data_frame(example.data, tagger=gum_tagger)
  #' 
  #' lines_tagger <- tagger_factory("english-lines")
  #' tag_data_frame(example.data, tagger=lines_tagger)
  
  UseMethod("tag_data_frame", tagger)
  
}


tag_data_frame.character <- function(frm,
                                     tagger,
                                     chunk_size = 1e2,
                                     to_ignore = c(), catch) {
  tag.f <- tagger_factory(tagger)
  tag_data_frame(frm, tag.f, chunk_size, to_ignore)
}


tag_data_frame.function <- function(frm,
                                    tagger,
                                    chunk_size = 1e2,
                                    to_ignore = c(),catch) {
  
  Sentence <- upos <- doc_id <- NA
  
  character_frm <- frm %>%
    select(where(is.character)) %>%
    remove_if_exists(to_ignore)
  
  
  if (any(dim(character_frm) == 0)) {
    return(list(
      `All Tags` = NULL,
      `Proper Nouns` = NULL,
      `Sentences` = NULL
    ))
  }
  
  doc_grid <- expand.grid(Row = rownames(character_frm),
                          Column = colnames(character_frm)) |>
    mutate(Document = simplify(character_frm), PK = row_number())
  
  document_frm <- group_by(doc_grid, Document) %>%
    group_modify(summarize_repeated_setences) |>
    ungroup() |>
    mutate(ID = glue("Col:{Column} Row:{Row}")) |>
    select(Document, ID, Repeats, `Affected Columns`, PK)
  
  tag_frm <- tag_documents(
    document_frm$Document,
    doc_ids = document_frm$ID,
    tagger = tagger,
    chunk_size = chunk_size
  ) |>
    rename(ID = doc_id,
           Token = token,
           Sentence = sentence)
  
  list(`All Tags` = tag_frm, `Documents` = document_frm)
}


filter_to_proper_nouns <- function(tag_frm) {
  #' Filters tagged data frame to only proper nouns
  #' 
  #' @param tag_frm A tagged data frame
  #' @return A data frame containing only proper nouns
  #' 
  #' @examples
  #' example.data <- head(the_one_in_massapequa, 20)
  #' tagged <- tag_data_frame(example.data, tagger="english-ewt")
  #' filter_to_proper_nouns(tagged$`All Tags`)
  
  tag_frm %>%
    filter(upos == "PROPN") %>%
    # rename(ID = doc_id) |>
    select(ID, Token, Sentence)
}


pid_pos <- function(frm,
                    tagger = "english-ewt",
                    filter = filter_to_proper_nouns,
                    chunk_size = 1e2,
                    to_ignore = c(),
                    warn_if_missing = F,
                    catch=F) {
  #' Proper Noun Detection
  #'
  #' For a given data set, the function reports each detected instance of a proper
  #' noun and reports the location in the data set, the sentence containing the
  #' proper noun, and how often the sentence occurs.
  #'
  #' @param frm A data frame to check for proper nouns
  #' @param tagger [optional] Either a string naming a UDPipe model (see ... for the list of models)
  #'   or a custom tagging function (see ... for details of what is required).
  #' @param filter [optional] A function that takes a tagged data frame and returns
  #'   
  #' @param chunk_size [optional] The number of sentences to tag at a time.  The optimal value
  #'   has yet to be determined.
  #' @param to_ignore [optional] A vector of column names to be ignored by the algorithm.
  #'   Intended to be used for variables that are giving strong false positives, such as
  #'   IDs or ICD-10 codes.
  #' @param warn_if_missing [optional] Raise a warning if the `to_ignore` columns are
  #'   not in the data frame.
  #'
  #' @return A `pid_report` (inheriting from tibble) containing:
  #' \itemize{
  #'   \item `ID`: The location of the sentence in the data frame in the form `Col:<colname> Row:<rownumber>`.
  #'   \item `Token`: The detected proper noun.
  #'   \item `Sentence`: The sentence containing the proper noun.
  #'   \item `Repeats`: The number of times the sentence occurs in the data frame.
  #'   \item `Affected Columns`: The columns in the data frame where the sentence occurs.
  #' }
  #' If no proper nouns are detected, an empty data frame is returned.
  #'
  #' @examples
  #' data(the_one_in_massapequa)
  #' example.data <- head(the_one_in_massapequa, 20)
  #' try(
  #'   pid_pos(example.data, to_ignore=c("scene", "utterance"))
  #' )
  #' 
  #' pid_pos(example.data, to_ignore=c("scene", "utterance"), tagger="english-gum")
  #' 
  #' tag_ewt <- tagger_factory("english-ewt")
  #' pid_pos(example.data, to_ignore=c("scene", "utterance"), tagger=tag_ewt)
  #' 
  #' filter_to_long_proper_nouns <- function(frm){
  #'   filter_to_proper_nouns(frm) |>
  #'     filter(nchar(Token) > 1)
  #' }
  #' pid_pos(example.data, to_ignore=c("scene", "utterance"), 
  #'   tagger=tag_ewt, filter=filter_to_long_proper_nouns)
  #' 
  #' @export
  #' @importFrom magrittr %>%
  #' @importFrom dplyr group_by group_modify left_join where all_of
  #' @importFrom dplyr rename select mutate
  #' @importFrom glue glue
  #' @importFrom progress progress_bar
  #' @importFrom tibble as_tibble
  #'
  
  frm_cols <- colnames(frm)
  cant_remove <- setdiff(to_ignore, frm_cols)
  
  if (warn_if_missing & (length(cant_remove) > 0)) {
    warning(
      glue(
        "The following columns to remove were not found in the data frame: {paste(cant_remove, collapse=', ')}"
      )
    )
  }
  
  tagged <- tag_data_frame(frm, tagger, chunk_size, to_ignore)
  filtered_tags <- filter(tagged$`All Tags`)
  
  report <- left_join(filtered_tags, tagged$Documents, by = "ID") %>%
    as_tibble() |>
    arrange(PK) |>
    select(-PK)
  
  class(report) <- c("pid_report", class(report))
  report
}


