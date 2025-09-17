vector_merge_redactions <- function(vec, cached_redactions, preprocess = utf8_encode) {
  #' @importFrom dplyr left_join join_by
  frm <- data.frame(Old = preprocess(vec)) |>
    left_join(cached_redactions, by = dplyr::join_by(Old == If)) |>
    mutate(New = ifelse(is.na(Then), Old, Then))

  frm$New
}


merge_redactions <- function(frm, replacements, preprocess = utf8_encode) {
  #' @export
  frm |>
    mutate(across(
      where(is.character),
      ~ vector_merge_redactions(.x, replacements, preprocess = preprocess)
    ))
}
