# Write a test for report_on_folder


test_that("report_on_folder() ", {
  local({
    
    .tempdir <- local_tempdir("dir")

    for (i in 1:3){
      .file <- local_tempfile(tmpdir = .tempdir, 
                              fileext  = ".csv",
                              pattern = "SentenceFrm_")
      write.csv(sentence_frm, .file)
    }
    for (i in 1:2){
      .file <- local_tempfile(tmpdir = .tempdir, 
                              fileext  = ".xlsx",
                              pattern = "SentenceFrm_")
      openxlsx::write.xlsx(sentence_frm, .file)
    }
    
    report_dir <- local_tempdir("dir")

    .report <- report_on_folder(.tempdir, report_dir = report_dir)

    reports <- list.files(report_dir)

    expect_equal(length(reports), 5)
    
    report.1 <- read.csv(file.path(report_dir, reports)[1])
    
    expect_equal(report.1$Token, c("Peter", "Jane", "John"))
  })
})
