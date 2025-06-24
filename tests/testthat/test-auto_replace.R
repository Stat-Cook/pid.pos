test_that("hashing_replacement.f", {
  
  basic.hash.f <- hashing_replacement.f("101", "Barry")
  hashed <- basic.hash.f(letters)
  
  expect_equal(
    length(letters),
    length(hashed)
  )
  expect_true(all(hashed != letters))
  
  other.hash.f <- hashing_replacement.f("101", "Barry", hash=openssl::sha512)
  hashed.2 <- other.hash.f(letters)
  
  expect_equal(
    length(letters),
    length(hashed.2)
  )
  expect_true(all(hashed.2 != letters))
  
})


test_that("random_replacement.f default", {
  
  basic.replacement.f <- random_replacement.f()
  hashed <- basic.replacement.f(letters)
  
  expect_equal(
    length(letters),
    length(hashed)
  )
  expect_true(all(hashed != letters))
})

test_that("random_replacement.f with args", {
  other.hash.f <- random_replacement.f(50, c(letters, LETTERS, 0:9))
  hashed.2 <- other.hash.f(letters)
  
  expect_equal(
    length(letters),
    length(hashed.2)
  )
  expect_true(all(hashed.2 != letters))

})

test_that("random_replacement.f on numerics", {  
  
  other.hash.f <- random_replacement.f(5, c(letters, LETTERS, 0:9))
  .x <- 0:10
  hashed.3 <- other.hash.f(.x)

  expect_equal(
    length(.x),
    length(hashed.3)
  )
  expect_true(all(.x != hashed.3))
  
})

test_that("random_replacement.f with repeats", {  
  
  .x <- sample(letters[1:3], 50, T)
  replacement.f <- random_replacement.f()

  hashed <- replacement.f(.x)
  
  expect_equal(length(unique(hashed)), 3)
})

test_that("all_random_replacement.f default", {
  
  basic.replacement.f <- all_random_replacement.f()
  hashed <- basic.replacement.f(letters)
  
  expect_equal(
    length(letters),
    length(hashed)
  )
  expect_true(all(hashed != letters))
})


test_that("all_random_replacement.f with args", {
  other.hash.f <- all_random_replacement.f(50, c(letters, LETTERS, 0:9))
  hashed.2 <- other.hash.f(letters)
  
  expect_equal(
    length(letters),
    length(hashed.2)
  )
  expect_true(all(hashed.2 != letters))
  
})

test_that("all_random_replacement.f on numerics", {  
  
  other.hash.f <- all_random_replacement.f(5, c(letters, LETTERS, 0:9))
  .x <- 0:10
  hashed.3 <- other.hash.f(.x)
  
  expect_equal(
    length(.x),
    length(hashed.3)
  )
  expect_true(all(.x != hashed.3))
  
})

test_that("all_random_replacement.f with repeats", {  
  
  .x <- sample(letters[1:3], 50, T)
  replacement.f <- all_random_replacement.f()
  
  hashed <- replacement.f(.x)
  
  expect_equal(length(unique(hashed)), 50)
})
