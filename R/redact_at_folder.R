#' API for redaction across a file structure
#' 
#' @inheritParams find_supported_files 
#' @inheritParams redact_supported_files 
#' 
#' @export
#' 
redact_at_folder <- function(data_path,
                             redacter,
                             output_path = "Redacted Data",
                             extensions = get_implemented_extensions(),
                             export_function = NULL,
                             verbose = FALSE) {
  files_to_redact <- find_supported_files(data_path, extensions, verbose)
  redact_supported_files(files_to_redact, output_path, redacter, export_function)
}