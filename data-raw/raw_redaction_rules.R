
{
  example.data <- head(the_one_in_massapequa, 20)
  report <- data_frame_report(example.data, to_remove="speaker")
  raw_redaction_rules <- report_to_redaction_rules(report)
}

usethis::use_data(raw_redaction_rules, overwrite = T)
