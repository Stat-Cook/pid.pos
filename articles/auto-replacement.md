# Automatic Replacement Tools

This package is designed to support the identification and redaction of
personally identifiable data (PID) within textual datasets.

The
[`report_to_redaction_rules()`](https://stat-cook.github.io/pid.pos/reference/report_to_redaction_rules.md)
function generates a `replacement_rules` table from the output of
[`pid_pos()`](https://stat-cook.github.io/pid.pos/reference/pid_pos.md).
This table specifies candidate values for redaction and provides a `To`
column in which users can define replacement values.

In many cases, users may wish to manually populate the `To` column (for
example, replacing names with consistent pseudonyms). However, when a
dataset contains a large volume of PID, manual specification may be
impractical. In such cases, the
[`auto_replace()`](https://stat-cook.github.io/pid.pos/reference/auto_replace.md)
utility can be used to automatically generate replacement values.

[`auto_replace()`](https://stat-cook.github.io/pid.pos/reference/auto_replace.md)
operates on a `replacement_rules` table and encodes the `To` column
according to a user-defined replacement function. The package provides
three built-in replacement strategies:

- [`hashing_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/hashing_replacement.f.md)
  — hashes values using a key and salt, producing deterministic and
  reproducible replacements.
- [`random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/random_replacement.f.md)
  — generates random replacements from a defined character space.
- [`all_random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/all_random_replacement.f.md)
  — generates random replacements while ensuring all outputs are unique.

------------------------------------------------------------------------

## Basic Workflow

We begin by generating a PID report and converting it into redaction
rules:

``` r
library(pid.pos)

report <- pid_pos(the_one_in_massapequa)
replacement_rules <- report_to_redaction_rules(report)
replacement_rules
```

    #> # A tibble: 5 × 3
    #>   If                                                                 From  To   
    #>   <chr>                                                              <chr> <chr>
    #> 1 [Scene: Central Perk, everyone is there.]                          Cent… Cent…
    #> 2 [Scene: Central Perk, everyone is there.]                          Perk  Perk 
    #> 3 Phoebe Buffay                                                      Phoe… Phoe…
    #> 4 Phoebe Buffay                                                      Buff… Buff…
    #> 5 Oh, Ross, Mon, is it okay if I bring someone to your parent's ann… Ross  Ross

To automatically populate the `To` column, we first initialise a
replacement function.  
In this example, we use
[`random_replacement.f()`](https://stat-cook.github.io/pid.pos/reference/random_replacement.f.md)
to generate five-character replacements drawn from uppercase letters:

``` r
replacement.f <- random_replacement.f(
  replacement_size = 5,
  replacement_space = LETTERS
)
```

We then apply this function using
[`auto_replace()`](https://stat-cook.github.io/pid.pos/reference/auto_replace.md):

``` r
set.seed(101)
updated_replacement_rules <- auto_replace(
  replacement_rules,
  replacement.f
)

updated_replacement_rules
```

    #> # A tibble: 5 × 3
    #>   If                                                                 From  To   
    #>   <chr>                                                              <chr> <chr>
    #> 1 [Scene: Central Perk, everyone is there.]                          Cent… IYNWQ
    #> 2 [Scene: Central Perk, everyone is there.]                          Perk  ZVCCI
    #> 3 Phoebe Buffay                                                      Phoe… CCBTU
    #> 4 Phoebe Buffay                                                      Buff… QNLAM
    #> 5 Oh, Ross, Mon, is it okay if I bring someone to your parent's ann… Ross  FXZPU

The resulting `updated_replacement_rules` can then be used alongside the
original data in the `redact` function to adjust the data:

``` r
redact(
  head(the_one_in_massapequa, 5),
  updated_replacement_rules
)
#> # A tibble: 5 × 4
#>   scene utterance speaker          text                                         
#>   <int>     <int> <chr>            <chr>                                        
#> 1     1         1 Scene Directions [Scene: IYNWQ ZVCCI, everyone is there.]     
#> 2     1         2 CCBTU QNLAM      Oh, FXZPU, JZKUZ, is it okay if I bring some…
#> 3     1         3 UTNHH TFXGJ      Yeah.                                        
#> 4     1         4 FXZPU TFXGJ      Sure. Yeah.                                  
#> 5     1         5 JYZIE QLCZI      So, who's the guy?
```

If the quantity of text being redacted is large, and documents are
regularly repeated, the user may wish to parse the replacement rules
into a caching redaction function:

``` r
cached_redacter <- parse_redacter(updated_replacement_rules, with_cache = T)
cached_redacter
#> [1] "`cached_redact_function` [size=0]"
```

This new function has a `memoization` layer built in, so that if the
same document is presented - replacements are called from memory. This
may speed up data processing if the same passage of text is presented
multiple times, but comes at the cost of memory. The
`cached_redact_function` can be used in `redact` in the same way:

``` r
redacted_docs <- redact(
  the_one_in_massapequa,
  cached_redacter
)
cached_redacter
#> [1] "`cached_redact_function` [size=264]"
```

And its representation tracks the number of unique documents stored.

------------------------------------------------------------------------

## Summary

The automatic replacement tools allow users to:

- Rapidly generate redaction mappings for large datasets
- Choose between deterministic or randomised replacement strategies
- Convert replacement rules into reusable redaction functions

This approach separates PID identification from transformation, enabling
reproducible and auditable redaction workflows.
