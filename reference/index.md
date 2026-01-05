# Package index

## PID.POS

- [`data_frame_report()`](https://stat-cook.github.io/pid.pos/reference/data_frame_report.md)
  : Proper Noun Detection
- [`data_frame_tagger()`](https://stat-cook.github.io/pid.pos/reference/data_frame_tagger.md)
  : Tags a data frame with part of speech tags
- [`report_on_folder()`](https://stat-cook.github.io/pid.pos/reference/report_on_folder.md)
  : Folder Report
- [`report_to_redaction_rules()`](https://stat-cook.github.io/pid.pos/reference/report_to_redaction_rules.md)
  : Initialize redaction rules

## Redaction tools

- [`prepare_redactions()`](https://stat-cook.github.io/pid.pos/reference/prepare_redactions.md)
  : Prepare a function from redaction rules.
- [`frame_replacement()`](https://stat-cook.github.io/pid.pos/reference/frame_replacement.md)
  : Remove PID from a data frame.
- [`redaction_function_factory()`](https://stat-cook.github.io/pid.pos/reference/redaction_function_factory.md)
  : Create a redaction function from a \`data.frame\` of replacement
  rules.
- [`efficient_redaction()`](https://stat-cook.github.io/pid.pos/reference/efficient_redaction.md)
  : A wrapper for efficient redaction.
- [`efficient_redact_factory()`](https://stat-cook.github.io/pid.pos/reference/efficient_redact_factory.md)
  : Stateful recoding template function
- [`merge_redactions()`](https://stat-cook.github.io/pid.pos/reference/merge_redactions.md)
  : Remove PID from a data frame via a merge/

## UDpipe Utilities

- [`browse_model_location()`](https://stat-cook.github.io/pid.pos/reference/browse_model_location.md)
  : Browse user to folder for UDPipe models.
- [`browse_udpipe_repo()`](https://stat-cook.github.io/pid.pos/reference/browse_udpipe_repo.md)
  : Open github link to the 'english-ewt-2.5' UD model.

## Automatic Replacement Utilities

- [`auto_replace()`](https://stat-cook.github.io/pid.pos/reference/auto_replace.md)
  : Apply a replacement function to a \`rules.frm\`.
- [`hashing_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/hashing_replacement.f.md)
  : Function factory for hashing replacement.
- [`random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/random_replacement.f.md)
  : Function factory for random replacement.
- [`all_random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/all_random_replacement.f.md)
  : Function factory for random replacement.

## Datasets

- [`the_one_in_massapequa`](https://stat-cook.github.io/pid.pos/reference/the_one_in_massapequa.md)
  : The One in Massapequa
- [`sentence_frm`](https://stat-cook.github.io/pid.pos/reference/sentence_frm.md)
  : A short data frame of free text including PID. Used for basic
  examples and tests.
- [`raw_redaction_rules`](https://stat-cook.github.io/pid.pos/reference/raw_redaction_rules.md)
  : raw_redaction_rules An example of a redaction rules produced by the
  \`data_frame_report\` function. It is made using the first 20 rows of
  \`the_one_in_massapequa\` data set.
