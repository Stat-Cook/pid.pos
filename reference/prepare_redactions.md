# Prepare a function from redaction rules.

Convert the \`replacement_rules\` (as defined with
\`report_to_redaction_rules\`) to a function that can be applied to a
data frame.

## Usage

``` r
prepare_redactions(object)
```

## Arguments

- object:

  The \`replacement_rules\` (can be a path to a csv file or a
  \`data.frame\`).

## Value

A function that can be applied to a data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
example.data <- head(the_one_in_massapequa)
report <- data_frame_report(example.data, to_remove="speaker")
redactions.raw <- report_to_redaction_rules(report)

replace_by <- random_replacement.f()
redactions <- auto_replace(redactions.raw, replacement.f = replace_by)

f <- prepare_redactions(redactions)
f(example.data$text)
} # }
```
