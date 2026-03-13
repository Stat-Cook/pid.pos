# Folder Report

Iterates over a folder of data files and produces a proper noun report
for each. The reports are saved in the specified `report directory`.

## Usage

``` r
report_on_folder(
  data_path,
  report_dir = "Proper Noun Reports",
  tagger = "english-ewt",
  filter_func = filter_to_proper_nouns,
  chunk_size = 100,
  to_ignore = c(),
  export_function = NULL,
  verbose = FALSE
)
```

## Arguments

- data_path:

  The file path at which data is stored

- report_dir:

  The location to write PID reports to

- tagger:

  Either a string naming a UDPipe model (see
  [udpipe::udpipe_download_model](https://rdrr.io/pkg/udpipe/man/udpipe_download_model.html)
  for the list of models) or a custom tagging function (see [Custom
  Functions](https://stat-cook.github.io/pid.pos/articles/custom-functions.md)
  for details of what is required).

- filter_func:

  A function to filter the tagged instances. See the 'Custom Filtering
  Functions' section of
  [`vignette("custom-functions")`](https://stat-cook.github.io/pid.pos/articles/custom-functions.md)
  for more details.

- chunk_size:

  The number of sentences to tag at a time. The optimal value has yet to
  be determined.

- to_ignore:

  A vector of column names to be ignored by the algorithm. Intended to
  be used for variables that are giving strong false positives, such as
  IDs or ICD-10 codes.

- export_function:

  A function to control exporting the reports to disk. Current options
  are `export_as_tree` and `export_flat`

- verbose:

  Boolean flag - if TRUE will...

## Examples

``` r
{
  input_dir <- withr::local_tempdir()
  output_dir <- withr::local_tempdir()

  dir.create(input_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  example_data <- data.frame(
    text = "Joey went to London",
    stringsAsFactors = FALSE
  )

  utils::write.csv(example_data,
    file.path(input_dir, "example.csv"),
    row.names = FALSE
  )

  paths <- report_on_folder(input_dir, report_dir = output_dir)

  paths
}
#> $example
#> [1] "/tmp/RtmppegJbj/file1c367e50ad3f/example.csv"
#> 
```
