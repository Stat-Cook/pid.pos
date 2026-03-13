# Tag a set of documents

\`tag_documents()\` applies a tagging function (defaulting to a
\`udpipe_factory()\`) to a vector of text documents, optionally
splitting them into chunks for memory efficiency. The function returns a
tibble containing tokens, sentences, and token-level metadata.

## Usage

``` r
tag_documents(docs, doc_ids = NULL, tagger = NULL, chunk_size = 100)
```

## Arguments

- docs:

  Character vector. The text documents to tag. Must be non-empty.

- doc_ids:

  Character vector or NULL. Optional document identifiers; if NULL,
  default IDs will be generated.

- tagger:

  Function. A tagging function, typically created with
  \`udpipe_factory()\`.

- chunk_size:

  Integer. Number of documents to process per batch. Defaults to 100.

## Value

A tibble (\`tbl_df\`) with columns depending on \`tagger\`s output.

## Examples

``` r
# Sample text
example_text <- c(
  "This is a test sentence.",
  "Here is another sentence."
)

# Create a tagger for the English EWT model
ewt_tagger <- udpipe_factory("english-ewt")
ewt_result <- pid.pos:::tag_documents(example_text, tagger = ewt_tagger)

# Create a tagger for the English GUM model
gum_tagger <- udpipe_factory("english-gum")
gum_result <- pid.pos:::tag_documents(example_text, tagger = gum_tagger)

# Create a tagger for the English LINES model
lines_tagger <- udpipe_factory("english-lines")
lines_result <- pid.pos:::tag_documents(example_text, tagger = lines_tagger)
```
