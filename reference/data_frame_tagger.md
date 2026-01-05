# Tags a data frame with part of speech tags

Tags a data frame with part of speech tags

## Usage

``` r
data_frame_tagger(frm, chunk_size = 100, to_remove = c())
```

## Arguments

- frm:

  A data frame to tag

- chunk_size:

  The number of sentences to tag at a time

- to_remove:

  A character vector of column names to remove from the data frame
