empty.report <- data.frame(
  `ID` = character(0),
  Token = character(0),
  Sentence = character(0),
  Repeats = integer(0),
  "Affected Columns" = character(0)
)

#' Folder Report
#'
#' Iterates over a folder of data files and produces a proper noun report for each.
#' The reports are saved in the specified `report directory`.
#'
#' @inheritParams find_supported_files
#' @inheritParams pid_pos
#' @param export_function A function to control exporting the reports to disk.  Current 
#'  options  are `export_as_tree` and `export_flat`
#'
#' @return NULL
#'
#' @export
#'
#' @examples
#' {
#'   input_dir <- withr::local_tempdir()
#'   output_dir <- withr::local_tempdir()
#'
#'   dir.create(input_dir, recursive = TRUE, showWarnings = FALSE)
#'   dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
#'
#'   example_data <- data.frame(text = "Joey went to London",
#'                              stringsAsFactors = FALSE)
#'
#'   utils::write.csv(example_data,
#'                    file.path(input_dir, "example.csv"),
#'                    row.names = FALSE)
#'
#'   paths <- report_on_folder(input_dir, report_dir = output_dir)
#'
#'   paths
#' }
#'
#' @importFrom dplyr arrange
#' @importFrom stringr str_replace str_replace_all
report_on_folder <- function(data_path,
                             report_dir = "Proper Noun Reports",
                             tagger = "english-ewt",
                             filter_func = filter_to_proper_nouns,
                             chunk_size = 100,
                             to_ignore = c(),
                             export_function = NULL,
                             verbose = FALSE) {


  if (!dir.exists(data_path)) {
    stop("data_path does not exist: ", data_path)
  }

  supported_files <- find_supported_files(data_path,
    extensions = get_implemented_extensions(),
    verbose = verbose
  )

  if (!dir.exists(report_dir)) {
    report_dir <- normalizePath(report_dir, mustWork = FALSE)
    dir.create(report_dir, recursive = TRUE)
  }


  output_paths <- process_supported_files(supported_files,
    report_dir,
    tagger = tagger,
    filter_func = filter_func,
    chunk_size = chunk_size,
    to_ignore = to_ignore,
    export_function = export_function
  )

  invisible(output_paths)
}
