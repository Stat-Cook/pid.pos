# Tags a data frame with part of speech tags

Tags a data frame with part of speech tags

## Usage

``` r
tag_data_frame(
  frm,
  tagger = "english-ewt",
  chunk_size = 100,
  to_ignore = character()
)
```

## Arguments

- frm:

  A data frame to tag

- tagger:

  Either a string naming a UDPipe model (see \`udpipe_factory\` for the
  list of models) or a custom tagging function (see \`udpipe_factory\`
  for details of what is required).

- chunk_size:

  The number of sentences to tag at a time

- to_ignore:

  A character vector of column names to remove from the data frame

## Value

A list with two elements:

- AllTags:

  A tibble of token-level annotations

- Documents:

  A tibble describing the processed documents

## Examples

``` r
example.data <- head(the_one_in_massapequa, 20)

tag_data_frame(example.data, tagger = "english-ewt")
#> $AllTags
#> # A tibble: 354 × 18
#>    ID          Token Sentence upos  paragraph_id sentence_id start   end term_id
#>    <chr>       <chr> <chr>    <chr>        <int>       <int> <int> <int>   <int>
#>  1 Col:text R… And   And you… CCONJ            1           1     1     3       1
#>  2 Col:text R… you   And you… PRON             1           1     5     7       2
#>  3 Col:text R… wond… And you… VERB             1           1     9    14       3
#>  4 Col:text R… why   And you… ADV              1           1    16    18       4
#>  5 Col:text R… Ross  And you… PROPN            1           1    20    23       5
#>  6 Col:text R… is    And you… AUX              1           1    25    26       6
#>  7 Col:text R… their And you… PRON             1           1    28    32       7
#>  8 Col:text R… favo… And you… NOUN             1           1    34    41       8
#>  9 Col:text R… ?     And you… PUNCT            1           1    42    42       9
#> 10 Col:text R… Are   Are you… AUX              1           1     1     3       1
#> # ℹ 344 more rows
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
#> 
#> $Documents
#> # A tibble: 26 × 5
#>    Document                               ID    Repeats `Affected Columns`    PK
#>    <chr>                                  <glu>   <int> <chr>              <int>
#>  1 "And you wonder why Ross is their fav… Col:…       1 `text`                28
#>  2 "Are you kidding me? Watch! Well I ca… Col:…       1 `text`                36
#>  3 "Chandler Bing"                        Col:…       3 `speaker`             13
#>  4 "Joey Tribbiani"                       Col:…       3 `speaker`              9
#>  5 "Monica Geller"                        Col:…       6 `speaker`              5
#>  6 "No! Really! Any time Ross makes a to… Col:…       1 `text`                30
#>  7 "Oh, Ross, Mon, is it okay if I bring… Col:…       1 `text`                 4
#>  8 "Oh, by the way. Would it be okay if … Col:…       1 `text`                18
#>  9 "Okay, hopefully this time mom won't … Col:…       1 `text`                24
#> 10 "Oooh, did he put a little starch in … Col:…       1 `text`                14
#> # ℹ 16 more rows
#> 
tag_data_frame(example.data, tagger = "english-gum")
#> $AllTags
#> # A tibble: 353 × 18
#>    ID          Token Sentence upos  paragraph_id sentence_id start   end term_id
#>    <chr>       <chr> <chr>    <chr>        <int>       <int> <int> <int>   <int>
#>  1 Col:text R… And   And you… CCONJ            1           1     1     3       1
#>  2 Col:text R… you   And you… DET              1           1     5     7       2
#>  3 Col:text R… wond… And you… NOUN             1           1     9    14       3
#>  4 Col:text R… why   And you… SCONJ            1           1    16    18       4
#>  5 Col:text R… Ross  And you… PROPN            1           1    20    23       5
#>  6 Col:text R… is    And you… AUX              1           1    25    26       6
#>  7 Col:text R… their And you… PRON             1           1    28    32       7
#>  8 Col:text R… favo… And you… ADJ              1           1    34    41       8
#>  9 Col:text R… ?     And you… PUNCT            1           1    42    42       9
#> 10 Col:text R… Are   Are you… AUX              1           1     1     3       1
#> # ℹ 343 more rows
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
#> 
#> $Documents
#> # A tibble: 26 × 5
#>    Document                               ID    Repeats `Affected Columns`    PK
#>    <chr>                                  <glu>   <int> <chr>              <int>
#>  1 "And you wonder why Ross is their fav… Col:…       1 `text`                28
#>  2 "Are you kidding me? Watch! Well I ca… Col:…       1 `text`                36
#>  3 "Chandler Bing"                        Col:…       3 `speaker`             13
#>  4 "Joey Tribbiani"                       Col:…       3 `speaker`              9
#>  5 "Monica Geller"                        Col:…       6 `speaker`              5
#>  6 "No! Really! Any time Ross makes a to… Col:…       1 `text`                30
#>  7 "Oh, Ross, Mon, is it okay if I bring… Col:…       1 `text`                 4
#>  8 "Oh, by the way. Would it be okay if … Col:…       1 `text`                18
#>  9 "Okay, hopefully this time mom won't … Col:…       1 `text`                24
#> 10 "Oooh, did he put a little starch in … Col:…       1 `text`                14
#> # ℹ 16 more rows
#> 
tag_data_frame(example.data, tagger = "english-lines")
#> Downloading udpipe model from https://raw.githubusercontent.com/jwijffels/udpipe.models.ud.2.5/master/inst/udpipe-ud-2.5-191206/english-lines-ud-2.5-191206.udpipe to /home/runner/.cache/R/pid.pos/english-lines-ud-2.5-191206.udpipe
#>  - This model has been trained on version 2.5 of data from https://universaldependencies.org
#>  - The model is distributed under the CC-BY-SA-NC license: https://creativecommons.org/licenses/by-nc-sa/4.0
#>  - Visit https://github.com/jwijffels/udpipe.models.ud.2.5 for model license details.
#>  - For a list of all models and their licenses (most models you can download with this package have either a CC-BY-SA or a CC-BY-SA-NC license) read the documentation at ?udpipe_download_model. For building your own models: visit the documentation by typing vignette('udpipe-train', package = 'udpipe')
#> Downloading finished, model stored at '/home/runner/.cache/R/pid.pos/english-lines-ud-2.5-191206.udpipe'
#> $AllTags
#> # A tibble: 354 × 18
#>    ID          Token Sentence upos  paragraph_id sentence_id start   end term_id
#>    <chr>       <chr> <chr>    <chr>        <int>       <int> <int> <int>   <int>
#>  1 Col:text R… And   And you… CCONJ            1           1     1     3       1
#>  2 Col:text R… you   And you… PRON             1           1     5     7       2
#>  3 Col:text R… wond… And you… VERB             1           1     9    14       3
#>  4 Col:text R… why   And you… ADV              1           1    16    18       4
#>  5 Col:text R… Ross  And you… ADV              1           1    20    23       5
#>  6 Col:text R… is    And you… VERB             1           1    25    26       6
#>  7 Col:text R… their And you… PRON             1           1    28    32       7
#>  8 Col:text R… favo… And you… NOUN             1           1    34    41       8
#>  9 Col:text R… ?     And you… PUNCT            1           1    42    42       9
#> 10 Col:text R… Are   Are you… AUX              1           1     1     3       1
#> # ℹ 344 more rows
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
#> 
#> $Documents
#> # A tibble: 26 × 5
#>    Document                               ID    Repeats `Affected Columns`    PK
#>    <chr>                                  <glu>   <int> <chr>              <int>
#>  1 "And you wonder why Ross is their fav… Col:…       1 `text`                28
#>  2 "Are you kidding me? Watch! Well I ca… Col:…       1 `text`                36
#>  3 "Chandler Bing"                        Col:…       3 `speaker`             13
#>  4 "Joey Tribbiani"                       Col:…       3 `speaker`              9
#>  5 "Monica Geller"                        Col:…       6 `speaker`              5
#>  6 "No! Really! Any time Ross makes a to… Col:…       1 `text`                30
#>  7 "Oh, Ross, Mon, is it okay if I bring… Col:…       1 `text`                 4
#>  8 "Oh, by the way. Would it be okay if … Col:…       1 `text`                18
#>  9 "Okay, hopefully this time mom won't … Col:…       1 `text`                24
#> 10 "Oooh, did he put a little starch in … Col:…       1 `text`                14
#> # ℹ 16 more rows
#> 

ewt_tagger <- udpipe_factory("english-ewt")
tag_data_frame(example.data, tagger = ewt_tagger)
#> $AllTags
#> # A tibble: 354 × 18
#>    ID          Token Sentence upos  paragraph_id sentence_id start   end term_id
#>    <chr>       <chr> <chr>    <chr>        <int>       <int> <int> <int>   <int>
#>  1 Col:text R… And   And you… CCONJ            1           1     1     3       1
#>  2 Col:text R… you   And you… PRON             1           1     5     7       2
#>  3 Col:text R… wond… And you… VERB             1           1     9    14       3
#>  4 Col:text R… why   And you… ADV              1           1    16    18       4
#>  5 Col:text R… Ross  And you… PROPN            1           1    20    23       5
#>  6 Col:text R… is    And you… AUX              1           1    25    26       6
#>  7 Col:text R… their And you… PRON             1           1    28    32       7
#>  8 Col:text R… favo… And you… NOUN             1           1    34    41       8
#>  9 Col:text R… ?     And you… PUNCT            1           1    42    42       9
#> 10 Col:text R… Are   Are you… AUX              1           1     1     3       1
#> # ℹ 344 more rows
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
#> 
#> $Documents
#> # A tibble: 26 × 5
#>    Document                               ID    Repeats `Affected Columns`    PK
#>    <chr>                                  <glu>   <int> <chr>              <int>
#>  1 "And you wonder why Ross is their fav… Col:…       1 `text`                28
#>  2 "Are you kidding me? Watch! Well I ca… Col:…       1 `text`                36
#>  3 "Chandler Bing"                        Col:…       3 `speaker`             13
#>  4 "Joey Tribbiani"                       Col:…       3 `speaker`              9
#>  5 "Monica Geller"                        Col:…       6 `speaker`              5
#>  6 "No! Really! Any time Ross makes a to… Col:…       1 `text`                30
#>  7 "Oh, Ross, Mon, is it okay if I bring… Col:…       1 `text`                 4
#>  8 "Oh, by the way. Would it be okay if … Col:…       1 `text`                18
#>  9 "Okay, hopefully this time mom won't … Col:…       1 `text`                24
#> 10 "Oooh, did he put a little starch in … Col:…       1 `text`                14
#> # ℹ 16 more rows
#> 

gum_tagger <- udpipe_factory("english-gum")
tag_data_frame(example.data, tagger = gum_tagger)
#> $AllTags
#> # A tibble: 353 × 18
#>    ID          Token Sentence upos  paragraph_id sentence_id start   end term_id
#>    <chr>       <chr> <chr>    <chr>        <int>       <int> <int> <int>   <int>
#>  1 Col:text R… And   And you… CCONJ            1           1     1     3       1
#>  2 Col:text R… you   And you… DET              1           1     5     7       2
#>  3 Col:text R… wond… And you… NOUN             1           1     9    14       3
#>  4 Col:text R… why   And you… SCONJ            1           1    16    18       4
#>  5 Col:text R… Ross  And you… PROPN            1           1    20    23       5
#>  6 Col:text R… is    And you… AUX              1           1    25    26       6
#>  7 Col:text R… their And you… PRON             1           1    28    32       7
#>  8 Col:text R… favo… And you… ADJ              1           1    34    41       8
#>  9 Col:text R… ?     And you… PUNCT            1           1    42    42       9
#> 10 Col:text R… Are   Are you… AUX              1           1     1     3       1
#> # ℹ 343 more rows
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
#> 
#> $Documents
#> # A tibble: 26 × 5
#>    Document                               ID    Repeats `Affected Columns`    PK
#>    <chr>                                  <glu>   <int> <chr>              <int>
#>  1 "And you wonder why Ross is their fav… Col:…       1 `text`                28
#>  2 "Are you kidding me? Watch! Well I ca… Col:…       1 `text`                36
#>  3 "Chandler Bing"                        Col:…       3 `speaker`             13
#>  4 "Joey Tribbiani"                       Col:…       3 `speaker`              9
#>  5 "Monica Geller"                        Col:…       6 `speaker`              5
#>  6 "No! Really! Any time Ross makes a to… Col:…       1 `text`                30
#>  7 "Oh, Ross, Mon, is it okay if I bring… Col:…       1 `text`                 4
#>  8 "Oh, by the way. Would it be okay if … Col:…       1 `text`                18
#>  9 "Okay, hopefully this time mom won't … Col:…       1 `text`                24
#> 10 "Oooh, did he put a little starch in … Col:…       1 `text`                14
#> # ℹ 16 more rows
#> 

lines_tagger <- udpipe_factory("english-lines")
tag_data_frame(example.data, tagger = lines_tagger)
#> $AllTags
#> # A tibble: 354 × 18
#>    ID          Token Sentence upos  paragraph_id sentence_id start   end term_id
#>    <chr>       <chr> <chr>    <chr>        <int>       <int> <int> <int>   <int>
#>  1 Col:text R… And   And you… CCONJ            1           1     1     3       1
#>  2 Col:text R… you   And you… PRON             1           1     5     7       2
#>  3 Col:text R… wond… And you… VERB             1           1     9    14       3
#>  4 Col:text R… why   And you… ADV              1           1    16    18       4
#>  5 Col:text R… Ross  And you… ADV              1           1    20    23       5
#>  6 Col:text R… is    And you… VERB             1           1    25    26       6
#>  7 Col:text R… their And you… PRON             1           1    28    32       7
#>  8 Col:text R… favo… And you… NOUN             1           1    34    41       8
#>  9 Col:text R… ?     And you… PUNCT            1           1    42    42       9
#> 10 Col:text R… Are   Are you… AUX              1           1     1     3       1
#> # ℹ 344 more rows
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
#> 
#> $Documents
#> # A tibble: 26 × 5
#>    Document                               ID    Repeats `Affected Columns`    PK
#>    <chr>                                  <glu>   <int> <chr>              <int>
#>  1 "And you wonder why Ross is their fav… Col:…       1 `text`                28
#>  2 "Are you kidding me? Watch! Well I ca… Col:…       1 `text`                36
#>  3 "Chandler Bing"                        Col:…       3 `speaker`             13
#>  4 "Joey Tribbiani"                       Col:…       3 `speaker`              9
#>  5 "Monica Geller"                        Col:…       6 `speaker`              5
#>  6 "No! Really! Any time Ross makes a to… Col:…       1 `text`                30
#>  7 "Oh, Ross, Mon, is it okay if I bring… Col:…       1 `text`                 4
#>  8 "Oh, by the way. Would it be okay if … Col:…       1 `text`                18
#>  9 "Okay, hopefully this time mom won't … Col:…       1 `text`                24
#> 10 "Oooh, did he put a little starch in … Col:…       1 `text`                14
#> # ℹ 16 more rows
#> 
```
