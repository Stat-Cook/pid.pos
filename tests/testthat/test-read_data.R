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
    writexl::write_xlsx(sentence_frm, .file)

    class(.file) <- "xls_path"

    frm <- read_data(.file)

    expect_equal(nrow(frm), 5)
    expect_equal(colnames(frm), c("ID", "Sentence", "Numeric", "Random"))
  })
})

# TODO: `fix_colnames` and  `handle_duplicates` format names in different ways.
# This is not ideal. We should have a single function that does both.
