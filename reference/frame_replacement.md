# Remove PID from a data frame.

Applied the replacement rules (as defined in a \`data.frame\` with
columns \`If\`, \`From\` and \`To\`) to all character columns in a data
frame.

## Usage

``` r
frame_replacement(frm, rules.frm)
```

## Arguments

- frm:

  The data frame containing text

- rules.frm:

  The \`data.frame\` containing \`If\`, \`From\` and \`To\` rules.

## Value

A data.frame with the same structure as

## Examples

``` r
if (FALSE) { # \dontrun{
example.data <- head(the_one_in_massapequa)
report <- data_frame_report(example.data)
redactions.raw <- report_to_redaction_rules(report)

replace_by <- random_replacement.f()
redactions <- auto_replace(redactions.raw, replacement.f = replace_by)

frame_replacement(example.data, redactions)
} # }
```
