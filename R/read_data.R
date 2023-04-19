read_data <- function(file_path, ...){
  #' @export
  UseMethod("read_data")
}

read_data.csv_path <- function(file_path, ...){
  #' @exportS3Method
  frm <- read.csv(file_path, check.names = F, ...)
  fix_colnames(frm)
}

read_data.xls_path <- function(file_path, ...){
  #' @importFrom readxl read_xls
  #' @exportS3Method
  readxl::read_excel(file_path, ...)
}

read_data.xlsx_path <- function(file_path, ...){
  #' @importFrom readxl read_xls
  #' @exportS3Method
  readxl::read_excel(file_path, ...)
}

read_data.tsv_path <- function(file_path, ...){
  #' @exportS3Method
  frm <- read.csv(file_path, sep = "\t", check.names = F, ...)
  fix_colnames(frm)
}


fix_colnames <- function(frm, pattern="V{.x}"){
  .cols <- colnames(frm)

  fix_index <- which((.cols == "") | (length(.cols) == 0))
  .x <- 1

  for (index in fix_index){
    proposal <- glue(pattern)
    while (proposal %in% .cols){
      .x <- .x + 1
      proposal <- glue(pattern)
    }

    .cols[index] <- proposal
  }

  colnames(frm) <- .cols
  handle_duplicates(frm)
}

handle_duplicates <- function(frm){
  #' @importFrom  glue glue
  .cols <- colnames(frm)
  .tab <- table(.cols)
  duplicated <- names(which(.tab > 1))
  dupe <- duplicated[1]

  for (dupe in duplicated){
    index <- which(.cols == dupe)
    .cols[index] <- glue::glue("{dupe}.{seq_len(length(index))}")
  }
  colnames(frm) <- .cols
  frm
}
