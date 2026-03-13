# NB: to set the context window size, use `set_context_window()`.

NB: to set the context window size, use
[`set_context_window()`](https://stat-cook.github.io/pid.pos/reference/set_context_window.md).

## Usage

``` r
get_context(
  sentence,
  token,
  context_window = getOption("pid_pos_context_window")
)
```

## Arguments

- sentence:

  A character vector of sentences.

- token:

  A character vector of tokens.

- context_window:

  The width of window around the token to be taken.
