#' Generate a unique column name for a data frame.
#'
#' This function generates a unique column name for a data frame by appending a number to a base name until it finds a name that is not already in the data frame.
#'
#' @param df A data frame to check for existing column names.
#' @param base A character string to use as the base for the column name. Default is ".row_index".
#'
#' @return A character string that is a unique column name for the data frame.
#' 
#' @keywords internal
#' 
#' 
make_unique_col <- function(df, base = ".row_index") {


  # Check that df is a data frame and base is a single character string
  if (!is.data.frame(df)) {
    type_error("`df` must be a data frame.",
      var = "df", value = df
    )
  }
  if (!is.character(base) || length(base) > 1) {
    type_error("`base` must be a single character string.",
      var = "base", value = base
    )
  }

  name <- base
  i <- 1
  while (name %in% names(df)) {
    name <- paste0(base, i)
    i <- i + 1
  }
  name
}
