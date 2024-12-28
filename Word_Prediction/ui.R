library(shiny)

shinyUI(fluidPage(
  titlePanel("Word Prediction App"),
  sidebarLayout(
    sidebarPanel(
      textInput("incoming", 
                "Type your phrase:", 
                value = "", 
                placeholder = "Enter a sentence..."),
      
      h4("Predicted Next Word:"),
      verbatimTextOutput("prediction"),
      
      br(),
      h4("App Information:"),
      uiOutput("info")
    ),
    
    # Main panel where output (predictions and app info) will be displayed
    mainPanel(
      # Display the app description or usage instructions
      h4("How to Use This App:"),
      p("This app predicts the next word based on the last few words typed by the user."),
      p("It utilises a backoff prediction model that starts with quadgrams (n-gram with n = 4) and moves steadily downards to a bigram (n=2) if necessary."),
      p("Try typing a phrase like 'for the first' to see a prediction!")
    )
  )
))
