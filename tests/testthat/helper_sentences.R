{
  test_sentences <- c(
    "His name was Peter",
    "He was a",
    "She was a",
    "She was named Jane",
    "He was named John"
  )
  
  sentences_length <- length(test_sentences)
  
  sentence_frm <- data.frame(
    ID = 1:sentences_length,
    Sentence = test_sentences,
    Numeric = c(1, 2, 3, 4, 5),
    Random = rnorm(sentences_length)
  )
}
  
