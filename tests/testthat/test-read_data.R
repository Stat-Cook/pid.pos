test_that("read_data() works with csv files", {
  local({
    .file <- local_tempfile(fileext = ".csv")
    write.csv(sentence_frm, .file, row.names = FALSE)

    class(.file) <- "csv_path"

    frm <- read_data(.file)

    expect_equal(nrow(frm), 5)
    expect_equal(colnames(frm), c("ID", "Sentence", "Numeric", "Random"))
  })
})


test_that("read_data() works with tsv files", {
  local({
    .file <- local_tempfile(fileext = ".tsv")
    write.table(sentence_frm, .file, row.names = FALSE, sep = "\t")

    class(.file) <- "tsv_path"

    frm <- read_data(.file)

    expect_equal(nrow(frm), 5)
    expect_equal(colnames(frm), c("ID", "Sentence", "Numeric", "Random"))
  })
})


test_that("read_data() works with xlsx files", {
  local({
    .file <- local_tempfile(fileext = ".xlsx")
    openxlsx::write.xlsx(sentence_frm, .file)

    class(.file) <- "xls_path"

    frm <- read_data(.file)

    expect_equal(nrow(frm), 5)
    expect_equal(colnames(frm), c("ID", "Sentence", "Numeric", "Random"))
  })
})

# TODO: `fix_colnames` and  `handle_duplicates` format names in different ways.
# This is not ideal. We should have a single function that does both.

# test fix_colnames
test_that("fix_colnames() works", {
  local({
    .file <- local_tempfile(fileext = ".csv")
    writeLines(
      c("A, B, ", "1,2,3", "4, 5, 6"),
      .file
    )

    frm <- read.csv(.file, check.names = FALSE)
    frm <- fix_colnames(frm)

    expect_equal(colnames(frm), c("A", "B", "V1"))
  })
})


test_that("handle_duplicates() works", {
  local({
    .file <- local_tempfile(fileext = ".csv")
    writeLines(
      c("A, B, B", "1,2,3", "4, 5, 6"),
      .file
    )

    frm <- read.csv(.file, check.names = FALSE)
    frm <- handle_duplicates(frm)

    expect_equal(colnames(frm), c("A", "B.1", "B.2"))
  })
})
