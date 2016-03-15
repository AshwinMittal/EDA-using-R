library(twitteR)
library(plyr)
library(ggplot2)
library(wordcloud)
library(ggmap)
library(dplyr)
library(plyr)
library(tm)
library(streamR)
rbind

shinyServer(function(input, output) {
  tweets.df <- parseTweets("tweets.json", verbose = FALSE)
  
  
  total_count <- nrow(tweets.df)
  hilary_count <- length(grep("hillary", tweets.df$text, ignore.case = TRUE))
  bernie_count <- length(grep("sanders", tweets.df$text, ignore.case = TRUE))
  trump_count <- length(grep("trump", tweets.df$text, ignore.case = TRUE))
  ted_count <- length(grep("cruz", tweets.df$text, ignore.case = TRUE))
  marco_count <- length(grep("rubio", tweets.df$text, ignore.case = TRUE))
  
  count_list <- c("Hilary"=hilary_count,"Bernie"=bernie_count,"Trump"=trump_count,"Cruz"=ted_count,"Marco"=marco_count)
  
  tweets.df$text_mod <- tweets.df$text
  
  # remove retweet entities
  tweets.df$text_mod = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets.df$text_mod)
  # remove at people
  tweets.df$text_mod = gsub("@\\w+", "", tweets.df$text_mod)
  # remove punctuation
  tweets.df$text_mod = gsub("[[:punct:]]", "", tweets.df$text_mod)
  # remove numbers
  tweets.df$text_mod = gsub("[[:digit:]]", "", tweets.df$text_mod)
  # remove html links
  tweets.df$text_mod = gsub("http\\w+", "", tweets.df$text_mod)
  # remove unnecessary spaces
  tweets.df$text_mod = gsub("[ \t]{2,}", "", tweets.df$text_mod)
  tweets.df$text_mod = gsub("^\\s+|\\s+$", "", tweets.df$text_mod)
  
  # define "tolower error handling" function 
  try.error = function(x)
  {
    # create missing value
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error=function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
      y = tolower(x)
    # result
    return(y)
  }
  # lower case using try.error with sapply 
  tweets.df$text_mod = sapply(tweets.df$text_mod, try.error)
  
  corpus=Corpus(VectorSource(tweets.df$text_mod))
  
  # Convert to lower-case
  corpus=tm_map(corpus,tolower)
  
  # Remove stopwords
  corpus=tm_map(corpus,function(x) removeWords(x,stopwords()))
  
  # convert corpus to a Plain Text Document
  corpus=tm_map(corpus,PlainTextDocument)
  
  col=brewer.pal(6,"Dark2")
  
  output$map <- renderPlot({ 
    if(input$selectCandidate == "Tweet Count"){
      barplot(count_list, main="Who is being most talked about this week..",ylim=c(0,total_count), ylab= "Count", col=c("blue","green","red","yellow","brown"), names.arg=c("Clinton", "Sanders", "Trump", "Cruz", "Rubio"))
    }
    else if(input$selectCandidate == "Word Cloud"){
      
      wordcloud(corpus, min.freq=5, scale=c(4,1), random.order=F,colors=col)
      
    }
    else if(input$selectCandidate == "sentiment"){
      counts <- c(length(grep("positive", sent_df$polarity, ignore.case = TRUE)), length(grep("negative", sent_df$polarity, ignore.case = TRUE)))
      barplot(as.matrix(counts), main="Car Distribution by Gears and VS",
              xlab="Number of Gears", col=c("darkblue","red"),
              legend = c("positive","negative"), beside=TRUE, ylim=c(0,total_count))
    }
  })
})
