# Replacement rules to redaction function

Convert a \`data.frame\` of redaction rules into a function that can be
applied to a character vector.

## Usage

``` r
redaction_function_factory(rules.frm)
```

## Arguments

- rules.frm:

  A data.frame with columns \`If\`, \`From\` and \`To\`.

## Examples

``` r
data(the_one_in_massapequa)
example.data <- head(the_one_in_massapequa)

raw_rules <- pid_pos(example.data) |>
  report_to_redaction_rules()

redaction_rules <- auto_replace(raw_rules,
  replacement.f = random_replacement.f()
)

redaction_func <- redaction_function_factory(redaction_rules)

redaction_func(example.data)
#> # A tibble: 6 × 4
#>   scene utterance speaker                                                  text 
#>   <int>     <int> <chr>                                                    <chr>
#> 1     1         1 "c(\"c(\\\"c(\\\\\\\"Scene Directions\\\\\\\", \\\\\\\"… "c(\…
#> 2     1         2 "c(\"c(\\\"c(\\\\\\\"Scene Directions\\\\\\\", \\\\\\\"… "c(\…
#> 3     1         3 "c(\"c(\\\"c(\\\\\\\"Scene Directions\\\\\\\", \\\\\\\"… "c(\…
#> 4     1         4 "c(\"c(\\\"c(\\\\\\\"Scene Directions\\\\\\\", \\\\\\\"… "c(\…
#> 5     1         5 "c(\"c(\\\"c(\\\\\\\"Scene Directions\\\\\\\", \\\\\\\"… "c(\…
#> 6     1         6 "c(\"c(\\\"c(\\\\\\\"Scene Directions\\\\\\\", \\\\\\\"… "c(\…
```
