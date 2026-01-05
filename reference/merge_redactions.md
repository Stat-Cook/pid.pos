# Remove PID from a data frame via a merge/

Remove PID from a data frame via a merge/

## Usage

``` r
merge_redactions(frm, cached_redactions, preprocess = utf8_encode)
```

## Arguments

- frm:

  The data frame to be redacted

- cached_redactions:

  A data frame with \`If\` and \`Then\` columns

- preprocess:

  A function of preprocessing steps to be applied to the text columns.
