# Package index

## PID.POS

- [`pid_pos()`](https://stat-cook.github.io/pid.pos/reference/pid_pos.md)
  : Proper Noun Detection
- [`tag_data_frame()`](https://stat-cook.github.io/pid.pos/reference/tag_data_frame.md)
  : Tags a data frame with part of speech tags
- [`udpipe_factory()`](https://stat-cook.github.io/pid.pos/reference/udpipe_factory.md)
  : Create a UDPipe tagging function
- [`custom_tagger()`](https://stat-cook.github.io/pid.pos/reference/custom_tagger.md)
  : Convert a POS tagging function to a tagger for the pid_pos package
- [`filter_to_proper_nouns()`](https://stat-cook.github.io/pid.pos/reference/filter_to_proper_nouns.md)
  : Filter a tagged data frame to proper nouns

## Redaction tools

- [`report_to_redaction_rules()`](https://stat-cook.github.io/pid.pos/reference/report_to_redaction_rules.md)
  : Initialize redaction rules
- [`redact()`](https://stat-cook.github.io/pid.pos/reference/redact.md)
  : Redact PID
- [`parse_redacter()`](https://stat-cook.github.io/pid.pos/reference/parse_redacter.md)
  : Parse a data frame into a redaction function with optional caching.
- [`redaction_function_factory()`](https://stat-cook.github.io/pid.pos/reference/redaction_function_factory.md)
  : Replacement rules to redaction function
- [`batched_redact()`](https://stat-cook.github.io/pid.pos/reference/batched_redact.md)
  : A wrapper for efficient redaction.

## Replacement Utilities

- [`auto_replace()`](https://stat-cook.github.io/pid.pos/reference/auto_replace.md)
  : Apply a replacement function to a \`rules.frm\`.
- [`hashing_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/hashing_replacement.f.md)
  : Function factory for hashing replacement.
- [`random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/random_replacement.f.md)
  : Function factory for random replacement.
- [`all_random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/all_random_replacement.f.md)
  : Function factory for random replacement.

## Folder level API

- [`report_on_folder()`](https://stat-cook.github.io/pid.pos/reference/report_on_folder.md)
  : Folder Report
- [`get_distinct_redaction_rules()`](https://stat-cook.github.io/pid.pos/reference/get_distinct_redaction_rules.md)
  : Title
- [`redact_at_folder()`](https://stat-cook.github.io/pid.pos/reference/redact_at_folder.md)
  : API for redaction across a file structure

## Package Utilities

- [`browse_model_location()`](https://stat-cook.github.io/pid.pos/reference/browse_model_location.md)
  : Browse user to folder for UDPipe models.
- [`browse_udpipe_repo()`](https://stat-cook.github.io/pid.pos/reference/browse_udpipe_repo.md)
  : Open github link to the 'english-ewt-2.5' UD model.
- [`enable_local_models()`](https://stat-cook.github.io/pid.pos/reference/enable_local_models.md)
  : Set the model folder to a local 'pid_pos_models' sub-folder.
- [`enable_package_models()`](https://stat-cook.github.io/pid.pos/reference/enable_package_models.md)
  : Set the model folder to the package data folder.
- [`register_reader()`](https://stat-cook.github.io/pid.pos/reference/register_reader.md)
  : Add a reader function for a specific file extension.
- [`set_udpipe_version()`](https://stat-cook.github.io/pid.pos/reference/set_udpipe_version.md)
  : Set the udpipe model repository version.
- [`reinstate_default_reader()`](https://stat-cook.github.io/pid.pos/reference/reinstate_default_reader.md)
  : Reinstate the default read functionality for csv, tsv, xls, and xlsx
  files.
- [`merge_redactions()`](https://stat-cook.github.io/pid.pos/reference/merge_redactions.md)
  : Remove PID from a data frame via a merge

## Datasets

- [`the_one_in_massapequa`](https://stat-cook.github.io/pid.pos/reference/the_one_in_massapequa.md)
  : The One in Massapequa
- [`sentence_frm`](https://stat-cook.github.io/pid.pos/reference/sentence_frm.md)
  : A short data frame of free text including PID. Used for basic
  examples and tests.
- [`raw_redaction_rules`](https://stat-cook.github.io/pid.pos/reference/raw_redaction_rules.md)
  : raw_redaction_rules An example of a redaction rules produced by the
  \`pid_pos\` function. It is made using the first 20 rows of
  \`the_one_in_massapequa\` data set.
