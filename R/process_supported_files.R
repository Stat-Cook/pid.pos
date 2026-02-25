process_supported_files <- function(file_list,
                                    report_path,
                                    tagger = "english-ewt",
                                    filter_func = filter_to_proper_nouns,
                                    chunk_size = 100,
                                    to_ignore = c(),
                                    export_function = NULL) {
  if (is.character(tagger)) {
    .tagger <- udpipe_factory(tagger)
  } else {
    .tagger <- tagger
  }


  if (is.null(export_function)) {
    export_function <- export_as_tree
  }

  dir.create(report_path, showWarnings = FALSE)


  purrr::imap(file_list, ~ {
    tryCatch(
      {
        frm <- read_data(.x)

        report <- pid_pos(
          frm,
          tagger = .tagger,
          filter_func = filter_func,
          to_ignore = to_ignore,
          chunk_size = chunk_size
        )

        export_function(report, .y, report_path)
      },
      error = function(e) {
        warning("Failed processing a data frame: ", e$message)
      }
    )
  }, .progress = T)
}
