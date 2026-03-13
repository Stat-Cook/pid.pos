# Create a UDPipe tagging function

Returns a function that tags text documents using a specified UDPipe
model. The returned function accepts a character vector of documents and
returns a tibble with tokens, sentences, and token metadata.

## Usage

``` r
udpipe_factory(
  model = "english-ewt",
  model_dir = pid.pos_env$model_folder,
  udpipe_repo = pid.pos_env$udpipe_repo
)
```

## Arguments

- model:

  Character. The name of the UDPipe model to use. Defaults to
  `english-ewt`.

- model_dir:

  Character. Directory where UDPipe models are stored.

- udpipe_repo:

  Character. URL or path of the UDPipe model repository.

## Value

A function that takes a character vector of documents and returns a
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- ID:

  Document identifier

- Token:

  Individual token text

- Sentence:

  Sentence containing the token

- upos:

  The universal parts of speech tag of the token. See
  https://universaldependencies.org/format.html

and all columns returned by the
[udpipe()](https://rdrr.io/pkg/udpipe/man/udpipe.html) function for each
token.

## See also

[`enable_local_models()`](https://stat-cook.github.io/pid.pos/reference/enable_local_models.md),
[`enable_package_models()`](https://stat-cook.github.io/pid.pos/reference/enable_package_models.md)
and
[`set_udpipe_version()`](https://stat-cook.github.io/pid.pos/reference/set_udpipe_version.md)
for control of the configuration environment.

## Examples

``` r
# Create a tagger for the English EWT model
ewt_tagger <- udpipe_factory("english-ewt")
docs <- c("This is a test.", "Another sentence.")
ewt_tagger(docs)
#> # A tibble: 8 × 18
#>   ID    Token    Sentence     upos  paragraph_id sentence_id start   end term_id
#>   <chr> <chr>    <chr>        <chr>        <int>       <int> <int> <int>   <int>
#> 1 doc1  This     This is a t… PRON             1           1     1     4       1
#> 2 doc1  is       This is a t… AUX              1           1     6     7       2
#> 3 doc1  a        This is a t… DET              1           1     9     9       3
#> 4 doc1  test     This is a t… NOUN             1           1    11    14       4
#> 5 doc1  .        This is a t… PUNCT            1           1    15    15       5
#> 6 doc2  Another  Another sen… DET              1           1     1     7       1
#> 7 doc2  sentence Another sen… NOUN             1           1     9    16       2
#> 8 doc2  .        Another sen… PUNCT            1           1    17    17       3
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>

# Create a tagger for the English GUM model
gum_tagger <- udpipe_factory("english-gum")
gum_tagger(docs)
#> # A tibble: 8 × 18
#>   ID    Token    Sentence     upos  paragraph_id sentence_id start   end term_id
#>   <chr> <chr>    <chr>        <chr>        <int>       <int> <int> <int>   <int>
#> 1 doc1  This     This is a t… PRON             1           1     1     4       1
#> 2 doc1  is       This is a t… AUX              1           1     6     7       2
#> 3 doc1  a        This is a t… DET              1           1     9     9       3
#> 4 doc1  test     This is a t… NOUN             1           1    11    14       4
#> 5 doc1  .        This is a t… PUNCT            1           1    15    15       5
#> 6 doc2  Another  Another sen… DET              1           1     1     7       1
#> 7 doc2  sentence Another sen… NOUN             1           1     9    16       2
#> 8 doc2  .        Another sen… PUNCT            1           1    17    17       3
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>

# Create a tagger for the English LINES model
lines_tagger <- udpipe_factory("english-lines")
lines_tagger(docs)
#> # A tibble: 8 × 18
#>   ID    Token    Sentence     upos  paragraph_id sentence_id start   end term_id
#>   <chr> <chr>    <chr>        <chr>        <int>       <int> <int> <int>   <int>
#> 1 doc1  This     This is a t… PRON             1           1     1     4       1
#> 2 doc1  is       This is a t… AUX              1           1     6     7       2
#> 3 doc1  a        This is a t… DET              1           1     9     9       3
#> 4 doc1  test     This is a t… NOUN             1           1    11    14       4
#> 5 doc1  .        This is a t… PUNCT            1           1    15    15       5
#> 6 doc2  Another  Another sen… ADJ              1           1     1     7       1
#> 7 doc2  sentence Another sen… NOUN             1           1     9    16       2
#> 8 doc2  .        Another sen… PUNCT            1           1    17    17       3
#> # ℹ 9 more variables: token_id <chr>, lemma <chr>, xpos <chr>, feats <chr>,
#> #   head_token_id <chr>, dep_rel <chr>, deps <chr>, misc <chr>, TokenNo <dbl>
```
