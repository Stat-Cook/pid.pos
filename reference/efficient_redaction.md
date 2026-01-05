# A wrapper for efficient redaction.

An experimental function for the efficient application of the redaction
functions. This function wraps a redaction function in a dynamic
programming class which stores previously redacted values and reuses
them when the same value is encountered again.

## Usage

``` r
efficient_redaction(frm, redact, n = NULL, .progress = T)
```

## Arguments

- frm:

  The data frame to be redacted

- redact:

  A function which converts free text to redacted text.

- n:

  The number of chunks to split the data frame into for processing.

- .progress:

  Whether to show a progress bar.

## Value

A data frame with the same structure as \`frm\` but with redacted text.

## Details

This function splits the data frame into chunks and processes each chunk
separately. This is useful for large data frames where the redaction
function may be slow.

## Examples

``` r
if (FALSE) { # \dontrun{
example.data <- head(the_one_in_massapequa)
report <- data_frame_report(example.data, to_remove="speaker")
redactions.raw <- report_to_redaction_rules(report)

replace_by <- random_replacement.f()
redactions <- auto_replace(redactions.raw, replacement.f = replace_by)
redaction.f <- prepare_redactions(redactions)
efficient_redaction(example.data, redaction.f)
} # }

```
