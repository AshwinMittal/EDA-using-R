library(streamR)
library(ROAuth)
library(jsonlite)
library(curl)
library(RCurl)
library(twitteR)
library(httr)
library(devtools)
library(sentiment)

requestURL <- "https://api.twitter.com/oauth/request_token"
authURL <- "https://api.twitter.com/oauth/authorize"
accessURL <- "https://api.twitter.com/oauth/access_token"
consumerKey <- "ee8XMo51FXkdIo1wWPhDx1kmZ"
consumerSecret <- "VuZOBe8mYPJICPFaEywVvtnFJMzXoiN92RFE4VwVV7zIumNgoH"
accessToken <- "114718067-vlkFwhwEjfCldbKTy6ZN3HLuAtMkIc34Wzg12Y61"
accessSecret <- "Bn5ckpRRNa7ZH9ZZvRSSwTl3kZnXgzWrSxkBQPL47h6Nd"
my_oauth <- setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessSecret)

search.string_realestate <- "House Buying New York"
search.string_rent <- "Apartment Rent New York"
no.of.tweets <- 1000

realestate <- searchTwitter(search.string_realestate, n=no.of.tweets,lang="en")
realestate.df <- do.call(rbind, lapply(realestate, as.data.frame))

rent <- searchTwitter(search.string_rent, n=no.of.tweets,lang="en")
rent.df <- do.call(rbind, lapply(rent, as.data.frame))

counts <- c(nrow(rent.df), nrow(realestate.df))
barplot(as.matrix(counts), main="Apartment Rental Vs Realestate",
        col=c("darkblue","red"),
        legend = c("Rent","Realestate"), beside=TRUE)

