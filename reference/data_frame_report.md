# Proper Noun Detection

For a given data set, the function reports each detected instance of a
proper noun and reports the location in the data set, the sentence
containing the proper noun, and how often the sentence occurs.

## Usage

``` r
data_frame_report(frm, chunk_size = 100, to_remove = c())
```

## Arguments

- frm:

  A data frame to check for proper nouns

- chunk_size:

  \[optional\] The number of sentences to tag at a time. The optimal
  value has yet to be determined.

- to_remove:

  \[optional\] A character vector of column names to remove from the
  data frame

## Value

A tibble containing:

- \`ID\`: The location of the sentence in the data frame in the form
  \`Col:\<colname\> Row:\<rownumber\>\`.

- \`Token\`: The detected proper noun.

- \`Sentence\`: The sentence containing the proper noun.

- Repats: The number of times the sentence occurs in the data frame.

- \`Affected Columns\`: The columns in the data frame where the sentence
  occurs.

If no proper nouns are detected, an empty data frame is returned.

## Examples

``` r
if (FALSE) { # \dontrun{
example.data <- head(the_one_in_massapequa, 10)
data_frame_report(example.data, to_remove=c("scene", "utterance"))
} # }
```
