# Convert a POS tagging function to a tagger for the pid_pos package

This function converts a function for the tagging of a single sentence
into a function that can be used for the tagging of a whole document.
The function takes a function as an argument, which should have the
following signature: \`function(sentence)

## Usage

``` r
custom_tagger(pos_function)
```

## Arguments

- pos_function:

  A function for the tagging of a single sentence, with the signature
  \`function(sentence)\`

## Value

A function that can be used for the tagging of a whole document, with
the signature \`function(docs, doc_ids=seq_along(docs))\`

## Examples

``` r
# Example of a POS tagging function for a single sentence
proper_nouns <- c("Alice", "Bob", "Charlie")

pos_function <- function(sentence) {
  tokens <- unlist(strsplit(sentence, " "))

  data.frame(
    Token = tokens,
    upos = ifelse(tokens %in% proper_nouns, "PROPN", "OTHER")
  ) |>
    dplyr::mutate(Sentence = sentence)
}

.tagger <- custom_tagger(pos_function)

docs <- c("Alice is here", "Bob is there", "Charlie is everywhere")
.tagger(docs)
#>        Token  upos              Sentence ID
#> 1      Alice PROPN         Alice is here  1
#> 2         is OTHER         Alice is here  1
#> 3       here OTHER         Alice is here  1
#> 4        Bob PROPN          Bob is there  2
#> 5         is OTHER          Bob is there  2
#> 6      there OTHER          Bob is there  2
#> 7    Charlie PROPN Charlie is everywhere  3
#> 8         is OTHER Charlie is everywhere  3
#> 9 everywhere OTHER Charlie is everywhere  3

doc.frm <- data.frame(Text = docs)
pid_pos(doc.frm, tagger = .tagger, filter_func = filter_to_proper_nouns)
#> # A tibble: 3 × 6
#>   ID             Token   Sentence            Document Repeats `Affected Columns`
#> * <glue>         <chr>   <chr>               <chr>      <int> <chr>             
#> 1 Col:Text Row:1 Alice   Alice is here       Alice i…       1 `Text`            
#> 2 Col:Text Row:2 Bob     Bob is there        Bob is …       1 `Text`            
#> 3 Col:Text Row:3 Charlie Charlie is everywh… Charlie…       1 `Text`            
```
