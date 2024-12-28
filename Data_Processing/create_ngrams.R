library(tidytext)
library(dplyr)
library(tidyr)

cleaned_data <- readRDS("data/cleaned_data.RDS")
tb_cleaned_data <- tibble(txt = cleaned_data)

unigrams <- tb_cleaned_data |> 
  unnest_ngrams(phrases, txt, n = 1) |> 
  filter(!is.na(phrases)) |> 
  count(phrases, sort = TRUE) |> 
  filter(n > 20)

bigrams <- tb_cleaned_data |> 
  unnest_ngrams(phrases, txt, n = 2) |> 
  filter(!is.na(phrases)) |> 
  count(phrases, sort = TRUE) |> 
  filter(n > 40)

bigrams <- bigrams |> 
  separate(phrases, into = c("word1", "word2"), sep = " ", remove = FALSE)

trigrams <- tb_cleaned_data |> 
  unnest_ngrams(phrases, txt, n = 3) |> 
  filter(!is.na(phrases)) |> 
  count(phrases, sort = TRUE) |> 
  filter(n > 30)

trigrams <- trigrams |> 
  separate(phrases, into = c("word1", "word2", "word3"), sep = " ", , remove = FALSE)

quadgrams <- tb_cleaned_data |> 
  unnest_ngrams(phrases, txt, n = 4) |> 
  filter(!is.na(phrases)) |> 
  count(phrases, sort = TRUE) |> 
  filter(n > 10)

quadgrams <- quadgrams |> 
separate(phrases, into = c("word1", "word2", "word3", "word4"), sep = " ", remove = FALSE)

saveRDS(unigrams,file = "data/unigrams.RDS")
saveRDS(bigrams,file = "data/bigrams.RDS")
saveRDS(trigrams,file = "data/trigrams.RDS")
saveRDS(quadgrams,file = "data/quadgrams.RDS")
