vector_merge_redactions <- function(vec, cached_redactions, preprocess = utf8_encode) {
  #' @importFrom dplyr left_join join_by
  frm <- data.frame(Old = preprocess(vec)) |>
    left_join(cached_redactions, by = dplyr::join_by(Old == If)) |>
    mutate(New = ifelse(is.na(Then), Old, Then))

  frm$New
}


merge_redactions <- function(frm, cached_redactions, preprocess = utf8_encode) {
  #' Remove PID from a data frame via a merge/
  #'
  #' @param frm The data frame to be redacted
  #' @param cached_redactions A data frame with `If` and `Then` columns
  #' @param preprocess A function of preprocessing steps to be applied to the text columns.
  #'
  #' @export
  frm |>
    mutate(across(
      where(is.character),
      ~ vector_merge_redactions(.x, cached_redactions, preprocess = preprocess)
    ))
}
