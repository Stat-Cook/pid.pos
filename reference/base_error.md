# A custom abort function

A custom abort function

## Usage

``` r
base_error(subclass, message, ..., call)
```

## Arguments

- subclass:

  a vector of inherited error class

- message:

  The error message to display

- ...:

  Additional arguments to pass to `abort()`

- call:

  The call environment to use for the error (defaults to the caller's
  environment)

## Value

An error object with the specified message and classes
