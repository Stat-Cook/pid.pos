export_as_tree <- function(report, name, report_path) {
  output_file <- file.path(report_path, paste0(name, ".csv"))
  output.dir <- dirname(output_file)

  if (!dir.exists(output.dir)) {
    dir.create(output.dir, recursive = TRUE)
  }

  write.csv(report, output_file, row.names = FALSE)
  output_file
}

export_flat <- function(report, name, report_path) {
  flat_name <- stringr::str_replace_all(name, "/", "_")
  export_as_tree(report, flat_name, report_path)
}
