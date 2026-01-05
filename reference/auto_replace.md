# Apply a replacement function to a \`rules.frm\`.

Several function factories have been implemented to create replacement
functions (\`hashing_replacement.f\`, \`random_replacement.f\`,
\`all_random_replacement.f\`)

## Usage

``` r
auto_replace(frm, replacement.f, filter = F)
```

## Arguments

- frm:

  A \`data.frame\` with columns \`If\`, \`From\`, and \`To\`.

- replacement.f:

  A function for transforming the \`To\` column.

- filter:

  Logical. If \`TRUE\` will only apply to rows where \`From\` and \`To\`
  are different.

## Value

A \`data.frame\` like \`frm\` but with the \`To\` column transformed by
\`replacement.f\`.

## Examples

``` r
replace_by <- random_replacement.f()
auto_replace(raw_redaction_rules, replacement.f = replace_by)
#> # A tibble: 10 × 3
#>    If                                                                From  To   
#>    <chr>                                                             <chr> <chr>
#>  1 "[Scene: Central Perk, everyone is there.]"                       Cent… VNXC…
#>  2 "[Scene: Central Perk, everyone is there.]"                       Perk  WTLM…
#>  3 "Oh, Ross, Mon, is it okay if I bring someone to your parent's a… Ross  LFMZ…
#>  4 "Oh, Ross, Mon, is it okay if I bring someone to your parent's a… Mon   AYRC…
#>  5 "Well, his name is Parker and I met him at the drycleaners."      Park… HFAT…
#>  6 "Every year Ross makes the toast, and it's always really moving,… Ross  LFMZ…
#>  7 "And you wonder why Ross is their favorite?"                      Ross  LFMZ…
#>  8 "Any time Ross makes a toast everyone cries, and hugs him, and p… Ross  LFMZ…
#>  9 "[Scene: Chandler and Monica's, they're getting ready to leave f… Chan… JOBU…
#> 10 "[Scene: Chandler and Monica's, they're getting ready to leave f… Moni… CFDJ…
```
