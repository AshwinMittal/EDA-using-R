library(streamR)
library(ROAuth)
library(jsonlite)
library(curl)
library(RCurl)
library(twitteR)

requestURL <- "https://api.twitter.com/oauth/request_token"
authURL <- "https://api.twitter.com/oauth/authorize"
accessURL <- "https://api.twitter.com/oauth/access_token"
consumerKey <- YOUR_CONSUMER_KEY
consumerSecret <- YOUR_CONSUMER_SECRET

download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")
Myoauth <- OAuthFactory$new(consumerKey=consumerKey, consumerSecret=consumerSecret, requestURL=requestURL, accessURL=accessURL, authURL=authURL)
Myoauth$handshake(cainfo="cacert.pem")
save(Myoauth, file="authdata.Rdata")
load("authdata.Rdata")

filterStream(file.name = "tweets.json",
             track = c("Presidential Elections", "US Elections", "Hilary Clinton","Bernie Sanders","Donald Trump","Ted Cruz","Marco Rubio"),
             language = "en",
             locations= c(-74,40,-73,41),
             tweets  = 200,
             oauth = Myoauth)
