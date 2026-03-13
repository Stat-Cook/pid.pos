# Apply a redaction to a list of files.

Apply a redaction to a list of files.

## Usage

``` r
redact_supported_files(
  file_list,
  output_path,
  redacter,
  export_function = NULL
)
```

## Arguments

- file_list:

  File path to location of data sets

- output_path:

  File path to write redacted data to

- redacter:

  A redaction rules data frame or redaction function

- export_function:

  A function to define export
