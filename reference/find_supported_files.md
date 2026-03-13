# Read all supported files in a folder into a named list of data.frames

Read all supported files in a folder into a named list of data.frames

## Usage

``` r
find_supported_files(
  data_path,
  extensions = get_implemented_extensions(),
  verbose = FALSE
)
```

## Arguments

- data_path:

  The file path at which data is stored

- extensions:

  Optional. The set of file extensions to scanned for.

- verbose:

  Boolean flag - if TRUE will...
