redact_supported_files <- function(file_list,
                                    output_path,
                                    redacter,
                                    export_function = NULL){

  if (is.null(export_function)){
    export_function <- export_as_tree
  }
  
  dir.create(output_path, showWarnings = FALSE)
  
  redacter <- parse_redacter(redacter)
  
  purrr::imap(file_list, ~ {
    tryCatch({
      frm <- read_data(.x)
      
      redacted <- redact(frm, redacter)
      
      export_function(redacted, .y, report_path)
      
    }, error = function(e) {
      warning("Failed processing a data frame: ", e$message)
    })
  }, .progress = T)
}