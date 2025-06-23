report_as_rules_template <- function(report, path = NULL) {
  #' @export
  .frm <- report |>
    mutate(
      If = Sentence,
      From = Token,
      To = Token,
      .keep = "none"
    )

  if (is.null(path)) {
    return(.frm)
  }

  write.csv(.frm, path)
  .frm
}

template_to_rules <- function(path, parse = F) {
  #' @export
  rules.frm <- read.csv(path)

  frame_to_rules(rules.frm, parse)
}


frame_to_rules <- function(rules.frm, parse = F) {
  #' @importFrom dplyr group_by group_map
  #' @importFrom dplyr case_when
  #' @importFrom stringr str_replace_all str_detect

  .rules <- rules.frm |>
    mutate(
      From = escape_quote_mark(From),
      To = escape_quote_mark(To),
      If = escape_quote_mark(If),
      Replace = sprintf("stringr::str_replace_all('%s', '%s')", From, To)
    ) |>
    group_by(If) |>
    group_map(if_modify) |>
    simplify()

  .result <- sprintf(
    "function(.x) dplyr::case_when(
    %s,
    .default=.x
  )",
    paste0(.rules, collapse = ",\n")
  )

  if (parse) {
    .result <- parse(text = .result) |>
      eval()
  }

  .result
}


if_modify <- function(frm, group) {
  .if <- group$If

  .left <- sprintf("stringr::str_detect(.x, '%s')", .if)
  .right <- paste(c(".x", frm$Replace), collapse = " |> ")


  sprintf("%s ~ %s", .left, .right)
}

escape_quote_mark <- function(vec) {
  str_replace_all(vec, "'", "\\\\'")
}
