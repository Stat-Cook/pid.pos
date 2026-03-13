# Set the model folder to a local 'pid_pos_models' sub-folder.

Intended if you want to use local udpipe models for a specific R
project.

## Usage

``` r
enable_local_models(sub_folder = TRUE)
```

## Arguments

- sub_folder:

  Logical. If TRUE, use a 'pid_pos_models' sub-folder of the current
  working directory. If FALSE use the current working directory.

## Value

The path to the model folder.

## Examples

``` r
if (FALSE) { # \dontrun{
  tmp <- withr::local_tempdir()
  withr::local_dir(tmp)

  enable_local_models()
  enable_local_models(sub_folder=FALSE)
} # }
```
