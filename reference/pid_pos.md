# Proper Noun Detection

For a given data set, the function reports each detected instance of a
proper noun and reports the location in the data set, the \`Document\`
containing the proper noun, and how often the \`Document\` occurs.

## Usage

``` r
pid_pos(
  frm,
  tagger = "english-ewt",
  filter_func = filter_to_proper_nouns,
  chunk_size = 100,
  to_ignore = c(),
  warn_if_missing = FALSE
)
```

## Arguments

- frm:

  A data frame to check for proper nouns

- tagger:

  \[optional\] Either a string naming a UDPipe model (see
  [udpipe_download_model](https://rdrr.io/pkg/udpipe/man/udpipe_download_model.html)
  for the list of models) or a custom tagging function (see
  [`vignette("custom-functions")`](https://stat-cook.github.io/pid.pos/articles/custom-functions.md)
  for details of what is required).

- filter_func:

  \[optional\] A function to filter the tagged instances. See the
  'Custom Filtering Functions' section of
  [`vignette("custom-functions")`](https://stat-cook.github.io/pid.pos/articles/custom-functions.md)
  for more details.

- chunk_size:

  \[optional\] The number of sentences to tag at a time. The optimal
  value has yet to be determined.

- to_ignore:

  \[optional\] A vector of column names to be ignored by the algorithm.
  Intended to be used for variables that are giving strong false
  positives, such as IDs or ICD-10 codes.

- warn_if_missing:

  \[optional\] Raise a warning if the \`to_ignore\` columns are not in
  the data frame.

## Value

A \`pid_report\` (inheriting from tibble) containing:

- \`ID\`: The location of the sentence in the data frame in the form
  \`Col:\<colname\> Row:\<rownumber\>\`.

- \`Token\`: The detected proper noun.

- \`Sentence\`: The sentence in which the proper noun occurs.

- \`Document\`: The source string (data frame cell) containing the
  sentence.

- \`Repeats\`: The number of times the \`Document\` occurs in the data
  frame.

- \`Affected Columns\`: The columns in the data frame where the
  \`Document\` occurs.

If no proper nouns are detected, an empty data frame is returned.

## Examples

``` r
data(the_one_in_massapequa)
example.data <- head(the_one_in_massapequa, 50)
try(
  pid_pos(example.data, to_ignore = c("scene", "utterance"))
)
#> # A tibble: 52 × 6
#>    ID                Token   Sentence        Document Repeats `Affected Columns`
#>  * <glue>            <chr>   <chr>           <chr>      <int> <chr>             
#>  1 Col:text Row:1    Central [Scene: Centra… [Scene:…       1 `text`            
#>  2 Col:text Row:1    Perk    [Scene: Centra… [Scene:…       1 `text`            
#>  3 Col:speaker Row:2 Phoebe  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  4 Col:speaker Row:2 Buffay  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  5 Col:text Row:2    Ross    Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  6 Col:text Row:2    Mon     Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  7 Col:speaker Row:3 Monica  Monica Geller   Monica …      12 `speaker`         
#>  8 Col:speaker Row:3 Geller  Monica Geller   Monica …      12 `speaker`         
#>  9 Col:speaker Row:4 Ross    Ross Geller     Ross Ge…       8 `speaker`         
#> 10 Col:speaker Row:4 Geller  Ross Geller     Ross Ge…       8 `speaker`         
#> # ℹ 42 more rows

pid_pos(example.data, to_ignore = c("scene", "utterance"), tagger = "english-gum")
#> Downloading udpipe model from https://raw.githubusercontent.com/jwijffels/udpipe.models.ud.2.5/master/inst/udpipe-ud-2.5-191206/english-gum-ud-2.5-191206.udpipe to /home/runner/.cache/R/pid.pos/english-gum-ud-2.5-191206.udpipe
#>  - This model has been trained on version 2.5 of data from https://universaldependencies.org
#>  - The model is distributed under the CC-BY-SA-NC license: https://creativecommons.org/licenses/by-nc-sa/4.0
#>  - Visit https://github.com/jwijffels/udpipe.models.ud.2.5 for model license details.
#>  - For a list of all models and their licenses (most models you can download with this package have either a CC-BY-SA or a CC-BY-SA-NC license) read the documentation at ?udpipe_download_model. For building your own models: visit the documentation by typing vignette('udpipe-train', package = 'udpipe')
#> Downloading finished, model stored at '/home/runner/.cache/R/pid.pos/english-gum-ud-2.5-191206.udpipe'
#> # A tibble: 46 × 6
#>    ID                Token   Sentence        Document Repeats `Affected Columns`
#>  * <glue>            <chr>   <chr>           <chr>      <int> <chr>             
#>  1 Col:text Row:1    Central [Scene: Centra… [Scene:…       1 `text`            
#>  2 Col:text Row:1    Perk    [Scene: Centra… [Scene:…       1 `text`            
#>  3 Col:speaker Row:2 Phoebe  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  4 Col:speaker Row:2 Buffay  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  5 Col:text Row:2    Ross    Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  6 Col:text Row:2    Mon     Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  7 Col:speaker Row:3 Monica  Monica Geller   Monica …      12 `speaker`         
#>  8 Col:speaker Row:3 Geller  Monica Geller   Monica …      12 `speaker`         
#>  9 Col:speaker Row:4 Ross    Ross Geller     Ross Ge…       8 `speaker`         
#> 10 Col:speaker Row:4 Geller  Ross Geller     Ross Ge…       8 `speaker`         
#> # ℹ 36 more rows

tag_ewt <- udpipe_factory("english-ewt")
pid_pos(example.data, to_ignore = c("scene", "utterance"), tagger = tag_ewt)
#> # A tibble: 52 × 6
#>    ID                Token   Sentence        Document Repeats `Affected Columns`
#>  * <glue>            <chr>   <chr>           <chr>      <int> <chr>             
#>  1 Col:text Row:1    Central [Scene: Centra… [Scene:…       1 `text`            
#>  2 Col:text Row:1    Perk    [Scene: Centra… [Scene:…       1 `text`            
#>  3 Col:speaker Row:2 Phoebe  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  4 Col:speaker Row:2 Buffay  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  5 Col:text Row:2    Ross    Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  6 Col:text Row:2    Mon     Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  7 Col:speaker Row:3 Monica  Monica Geller   Monica …      12 `speaker`         
#>  8 Col:speaker Row:3 Geller  Monica Geller   Monica …      12 `speaker`         
#>  9 Col:speaker Row:4 Ross    Ross Geller     Ross Ge…       8 `speaker`         
#> 10 Col:speaker Row:4 Geller  Ross Geller     Ross Ge…       8 `speaker`         
#> # ℹ 42 more rows


filter_to_long_proper_nouns <- function(frm) {
  frm |>
    dplyr::filter(nchar(Token) > 1)
  filter_to_proper_nouns(frm)
}

pid_pos(example.data,
  to_ignore = c("scene", "utterance"),
  tagger = tag_ewt, filter = filter_to_long_proper_nouns
)
#> # A tibble: 52 × 6
#>    ID                Token   Sentence        Document Repeats `Affected Columns`
#>  * <glue>            <chr>   <chr>           <chr>      <int> <chr>             
#>  1 Col:text Row:1    Central [Scene: Centra… [Scene:…       1 `text`            
#>  2 Col:text Row:1    Perk    [Scene: Centra… [Scene:…       1 `text`            
#>  3 Col:speaker Row:2 Phoebe  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  4 Col:speaker Row:2 Buffay  Phoebe Buffay   Phoebe …       5 `speaker`         
#>  5 Col:text Row:2    Ross    Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  6 Col:text Row:2    Mon     Oh, Ross, Mon,… Oh, Ros…       1 `text`            
#>  7 Col:speaker Row:3 Monica  Monica Geller   Monica …      12 `speaker`         
#>  8 Col:speaker Row:3 Geller  Monica Geller   Monica …      12 `speaker`         
#>  9 Col:speaker Row:4 Ross    Ross Geller     Ross Ge…       8 `speaker`         
#> 10 Col:speaker Row:4 Geller  Ross Geller     Ross Ge…       8 `speaker`         
#> # ℹ 42 more rows
```
