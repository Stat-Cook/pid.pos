# Automatic Replacement Tools

This package intends to aid the user in identifying and removing PID
from the data set. The `report_to_replacement_rules` function is used to
generate a `replacement_rules` table, which contains the rules for
replacing PID in the data set. In the first instance it is intended for
the user to manually define the `To` column of the `replacement_rules`
and then parse the file back into R.

If the data set contains a large quantity of PID, and hence it is not
practical to define all replacements, the `auto_replace` utility may be
beneficial. This function operates on the `replacement_rules` table
produced by `report_to_replacement_rules` and encodes the `To` column.
The precise replacement method can be defined by the user, with three
methods supplied by the package:

- `hashing_replacement.f` - hashes the `To` column using a key and salt,
  producing a unique replacement for each value.
- `random_replacement.f` - replaces the `To` column with a random value
  from a defined space.
- `all_random_replacement.f` - replaces the `To` column with a random
  value from a defined space, but ensures that all replacements are
  unique.

The basic workflow is hence:

``` r
library(pid.pos)

report <- data_frame_report(the_one_in_massapequa)
replacement_rules <- report_to_redaction_rules(report)

replacement_rules
```

    #> # A tibble: 5 × 3
    #>   If            From   To    
    #>   <chr>         <chr>  <chr> 
    #> 1 Phoebe Buffay Phoebe Phoebe
    #> 2 Phoebe Buffay Buffay Buffay
    #> 3 Monica Geller Monica Monica
    #> 4 Monica Geller Geller Geller
    #> 5 Ross Geller   Ross   Ross

To fill in the `To` column we initialize a replacement function (in this
case `random_replacement.f`):

``` r
replacement.f <- random_replacement.f(
  replacement_size = 5,
  replacement_space = LETTERS
)
```

and then apply it to the `replacement_rules` table:

``` r
set.seed(101)
updated.replacement_rules <- auto_replace(replacement_rules, replacement.f)
updated.replacement_rules
```

    #> # A tibble: 5 × 3
    #>   If            From   To   
    #>   <chr>         <chr>  <chr>
    #> 1 Phoebe Buffay Phoebe IYNWQ
    #> 2 Phoebe Buffay Buffay ZVCCI
    #> 3 Monica Geller Monica CCBTU
    #> 4 Monica Geller Geller QNLAM
    #> 5 Ross Geller   Ross   FXZPU

The `updated.replacement_rules` can then converted to a replacement
function via `redaction_function_factory`:

``` r
redact_function <- prepare_redactions(updated.replacement_rules)
```

which if parsed, can be used to modify the original data set:

``` r
head(the_one_in_massapequa, 5) |>
  dplyr::mutate(
    across(where(is.character), redact_function)
  )
#> # A tibble: 5 × 4
#>   scene utterance speaker          text                                         
#>   <int>     <int> <chr>            <chr>                                        
#> 1     1         1 Scene Directions [Scene: YIYLU MRGYZ, everyone is there.]     
#> 2     1         2 IYNWQ ZVCCI      Oh, FXZPU, EHUFY, is it okay if I bring some…
#> 3     1         3 CCBTU QNLAM      Yeah.                                        
#> 4     1         4 FXZPU QNLAM      Sure. Yeah.                                  
#> 5     1         5 JZKUZ UTNHH      So, who's the guy?
```
