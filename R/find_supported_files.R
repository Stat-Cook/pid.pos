get_implemented_extensions <- function() {
  #' @importFrom stringr str_remove
  names(pid.pos_env$file_readers)
}


find_supported_files <- function(data_path,
                                 extensions = get_implemented_extensions(),
                                 verbose = FALSE) {
  #' Read all supported files in a folder into a named list of data.frames
  
  if (!dir.exists(data_path)) {
    stop("data_path does not exist: ", data_path)
  }
  
  root <- normalizePath(data_path, winslash = "/", mustWork = TRUE)
  
  all_files <- list.files(root, recursive = TRUE, full.names = TRUE)
  ext <- tolower(tools::file_ext(all_files))
  
  matched <- all_files[ext %in% tolower(extensions)]
  ignored <- setdiff(all_files, matched)
  
  if (verbose && length(ignored) > 0) {
    message("Ignored files (unsupported extensions):\n", paste(ignored, collapse = "\n"))
  }
  
  files <- normalizePath(matched, winslash = "/", mustWork = TRUE)
  
  if (length(files) == 0) {
    warning("No supported files found in: ", root)
  }
  
  stubs <- tools::file_path_sans_ext(files)
  names(files) <- sub(paste0("^", root, "/?"), "", stubs)
  
  files
}






