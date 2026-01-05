# Stateful recoding template function

Dynamic programming wrapper to a mono-variable function - performs given
recoding function on unique values and recycles previous states.

## Usage

``` r
efficient_redact_factory(redact.function)
```

## Arguments

- redact.function:

  A single input function to perform variable recoding.

## Value

A function
