library(friends)

{
  the_one_in_massapequa <- friends |>
    filter(
      season==8,
      episode==18
    ) |>
    select(scene, utterance, speaker, text)
}

usethis::use_data(the_one_in_massapequa, overwrite = TRUE)