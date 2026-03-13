# Redact PID

Redact PID

## Usage

``` r
redact(object, redacter, in_batches = T, ...)
```

## Arguments

- object:

  The object to be redacted - either a vector or data frame

- redacter:

  A `data.frame` of redaction rules or a function created by
  [`redaction_function_factory()`](https://stat-cook.github.io/pid.pos/reference/redaction_function_factory.md).

- in_batches:

  Boolean flag - if True the supplied data will be processed in chunks.

- ...:

  Other arguments to control batching. See ... for details.
