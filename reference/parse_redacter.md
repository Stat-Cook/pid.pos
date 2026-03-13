# Parse a data frame into a redaction function with optional caching.

Parse a data frame into a redaction function with optional caching.

## Usage

``` r
parse_redacter(redacter, with_cache = T)
```

## Arguments

- redacter:

  A data.frame containing \`From\`, \`To\` and \`If\` or a file path to

- with_cache:

  \[Default True\] A binary flag to control if memoization is required.
