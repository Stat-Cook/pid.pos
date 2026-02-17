test_that("make_unique_col - expected behaviour", {
  df <- data.frame(
    A = c("a", "b", "c"),
    B = c("d", "e", "f")
  )

  expect_equal(make_unique_col(df), ".row_index")
  expect_equal(make_unique_col(df, ".temp"), ".temp")

  empty.df <- data.frame()
  expect_equal(make_unique_col(empty.df), ".row_index")
})

test_that("make_unique_col - check output", {
  df <- data.frame()

  new.col <- make_unique_col(df)
  expect_type(new.col, "character")
  expect_equal(length(new.col), 1)
})

test_that("make_unique_col - existing rowindex", {
  df <- tibble::tibble(
    `.row_index` = character()
  )

  expect_equal(make_unique_col(df), ".row_index1")

  df <- df |>
    mutate(`.row_index1` = character())
  unique_col <- make_unique_col(df)
  expect_equal(unique_col, ".row_index2")

  df <- df |>
    mutate(
      `.row_index2` = character(),
      `.row_index3` = character(),
      `.row_index4` = character()
    )

  unique_col <- make_unique_col(df)
  expect_equal(unique_col, ".row_index5")
})

test_that("make_unique_col - check failure", {
  expect_error(make_unique_col("Bob"), "`df` must be")

  expect_error(
    make_unique_col(data.frame(), base = 12),
    "`base` must be a"
  )
})

test_that("make_unique_col - check non-sequential", {
  df <- tibble::tibble(
    `.row_index` = character(),
    `.row_index2` = character(),
  )

  new.col <- make_unique_col(df)
  expect_equal(new.col, ".row_index1")
})


test_that("make_unique_col - does not modify df", {
  df <- data.frame(a = 1)
  df_copy <- df

  make_unique_col(df)

  expect_identical(df, df_copy)
})
