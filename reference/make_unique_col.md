# Generate a unique column name for a data frame.

This function generates a unique column name for a data frame by
appending a number to a base name until it finds a name that is not
already in the data frame.

## Usage

``` r
make_unique_col(df, base = ".row_index")
```

## Arguments

- df:

  A data frame to check for existing column names.

- base:

  A character string to use as the base for the column name. Default is
  ".row_index".

## Value

A character string that is a unique column name for the data frame.
