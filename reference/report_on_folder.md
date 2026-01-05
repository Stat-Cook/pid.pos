# Folder Report

Itterates over a folder of data files and produces a proper noun report
for each. The reports are saved in the specified \`report directory\`.

## Usage

``` r
report_on_folder(
  data_path,
  report_dir = "Proper Noun Reports",
  to_remove = c()
)
```

## Arguments

- data_path:

  The path to the data files

- report_dir:

  The directory to save the reports

- to_remove:

  A character vector of column names to remove from the data frame

## Examples

``` r
if (FALSE) { # \dontrun{
report_on_folder("path/to/data", report_dir="Proper Noun Reports")
} # }
```
