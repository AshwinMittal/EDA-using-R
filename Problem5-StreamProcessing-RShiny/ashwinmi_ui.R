
library(shiny)

shinyUI(fluidPage(
  
  titlePanel("USA Presidential Elections 2017"),
  
  sidebarLayout(
    
    sidebarPanel(
        selectInput("selectCandidate",label = "",
          choices = list("Tweet Count", "Word Cloud"),
          selected = "All",
          width = "200px"
        ),
        #textInput("searchTxt","",placeholder="Search..",value = "",width ="200px"),
        submitButton("Submit")
    ),
    
    mainPanel(
      #textOutput("text1")
      plotOutput("map")
    )
  )
))
