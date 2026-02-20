#' Proper Noun Detection
#'
#' For a given data set, the function reports each detected instance of a proper
#' noun and reports the location in the data set, the sentence containing the
#' proper noun, and how often the sentence occurs.
#'
#' @param frm A data frame to check for proper nouns
#' @param tagger [optional] Either a string naming a UDPipe model (see ... for the list of models)
#'   or a custom tagging function (see ... for details of what is required).
#' @param filter_func [optional] A function that takes a tagged data frame and returns
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
#'   pid_pos(example.data, to_ignore = c("scene", "utterance"))
#' )
#'
#' pid_pos(example.data, to_ignore = c("scene", "utterance"), tagger = "english-gum")
#'
#' tag_ewt <- udpipe_factory("english-ewt")
#' pid_pos(example.data, to_ignore = c("scene", "utterance"), tagger = tag_ewt)
#'
#'
#' filter_to_long_proper_nouns <- function(frm) {
#'   frm |>
#'     dplyr::filter(nchar(Token) > 1)
#'     filter_to_proper_nouns(frm) 
#' }
#' 
#' pid_pos(example.data,
#'   to_ignore = c("scene", "utterance"),
#'   tagger = tag_ewt, filter = filter_to_long_proper_nouns
#' )
#'
#' @export
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by group_modify left_join where all_of
#' @importFrom dplyr rename select mutate
#' @importFrom glue glue
#' @importFrom progress progress_bar
#' @importFrom tibble as_tibble
#'
pid_pos <- function(frm,
                    tagger = "english-ewt",
                    filter_func = filter_to_proper_nouns,
                    chunk_size = 1e2,
                    to_ignore = c(),
                    warn_if_missing = FALSE) {
  if (!is.data.frame(frm)) {
    stop("`frm` must be a data frame.", call. = FALSE)
  }

  if (!is.function(filter_func)) {
    stop("`filter_func` must be a function.", call. = FALSE)
  }

  frm_cols <- colnames(frm)
  cant_remove <- setdiff(to_ignore, frm_cols)

  if (warn_if_missing && (length(cant_remove) > 0)) {
    warning(
      glue(
        "The following columns to remove were not found in the data frame: {paste(cant_remove, collapse=', ')}",
        call. = FALSE
      )
    )
  }

  tagged <- tag_data_frame(frm, tagger, chunk_size, to_ignore)

  if (is.null(tagged$AllTags) || is.null(tagged$Documents)) {
    return(structure(
      tibble::tibble(),
      class = c("pid_report", "tbl_df", "tbl", "data.frame")
    ))
  }

  filtered_tags <- filter_func(tagged$AllTags)

  report <- left_join(filtered_tags, tagged$Documents, by = "ID") %>%
    as_tibble() |>
    arrange(.data$PK) |>
    select(-.data$PK)

  structure(
    report,
    class = c("pid_report", class(report))
  )
}
