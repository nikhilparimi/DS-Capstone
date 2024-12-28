library(shiny)
library(qdapRegex)
library(dplyr)
library(tidyr)

unigrams <- readRDS("data/unigrams.RDS")
bigrams <- readRDS("data/bigrams.RDS")
trigrams <- readRDS("data/trigrams.RDS")
quadgrams <- readRDS("data/quadgrams.RDS")

# Recursive backoff prediction algorithm
backoff_prediction <- function(x) {
  x <- rm_default(x, pattern = "[^A-Za-z ]")
  x <- tolower(x)
  words <- strsplit(x, "\\s")[[1]]
  if (length(words) >= 3) {
    tail_words <- tail(words, 3)
    match_exact <- quadgrams[quadgrams$word1 == tail_words[1] & 
                               quadgrams$word2 == tail_words[2] & 
                               quadgrams$word3 == tail_words[3], ]
    if (nrow(match_exact) > 0) {
      return(match_exact$word4[1])
    }
    else {
      tail_words <- paste(tail_words[2], tail_words[3])
      backoff_prediction(tail_words)
    }
  }
  else if (length(words) == 2) {
    tail_words <- words
    match_exact <- trigrams[trigrams$word1 == tail_words[1] & 
                              trigrams$word2 == tail_words[2], ]
    if (nrow(match_exact) > 0) {
      return(match_exact$word3[1])
    }
    
    else {
      tail_words <- tail_words[2]
      return(backoff_prediction(tail_words))
    }
  }
  else if (length(words) == 1) {
    tail_word <- words
    match_exact <- bigrams[bigrams$word1 == tail_word, ]
    if (nrow(match_exact) > 0) {
      return(match_exact$word2[1])
    }
    else {
      return(unigrams$phrases[1])
    }
  }
  
  else {
    return(NULL)
  }
}

shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    result <- backoff_prediction(input$incoming)
    output$display <- renderText({msg})
    result
  });
  
  output$info <- renderUI({
    HTML(paste(
      "For more details regarding my implementation, visit my",
      tags$a(href = "https://github.com/nikhilparimi/DS-Capstone", 
             "GitHub Repository!", target = "_blank")
    ))
  })
}
)