report_as_rules_template <- function(report, path=NULL) {
  .frm <- report |>
    mutate(
      If = Sentence,
      From = Token,
      To = Token,
      .keep = "none"
    )
  
  if (is.null(path)){
    return(.frm)
  }
  
  write.csv(.frm, path)
  .frm
}

template_to_rules <- function(path, parse=F){
  rules.frm <- read.csv(path)
  
  frame_to_rules(rules.frm, parse)
  
}


frame_to_rules <- function(rules.frm, parse=F) {
  
  .rules <- rules.frm |>
    mutate(Replace = sprintf("str_replace_all('%s', '%s')", From, To)) |>
    group_by(If) |>
    group_map(if_modify) |>
    simplify()
  
  .result <- sprintf(
  "function(.x) case_when(
    %s,
    .default=.x
  )",
  paste0(.rules, collapse = ",\n"))

  if (parse){
    .result <- parse(text=.result) |> 
      eval() 
  } 
  
  .result
}


if_modify <- function(frm, group) {
  .if <- group$If
  
  .left <- sprintf("str_detect(.x, '%s')", .if)
  .right <- paste(c(".x", frm$Replace), collapse = " |> ")
  
  
  sprintf("%s ~ %s", .left, .right)
}