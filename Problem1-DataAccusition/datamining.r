library(streamR)
library(ROAuth)
library(jsonlite)
library(curl)
library(RCurl)
library(twitteR)

requestURL <- "https://api.twitter.com/oauth/request_token"
authURL <- "https://api.twitter.com/oauth/authorize"
accessURL <- "https://api.twitter.com/oauth/access_token"
consumerKey <- "ee8XMo51FXkdIo1wWPhDx1kmZ"
consumerSecret <- "VuZOBe8mYPJICPFaEywVvtnFJMzXoiN92RFE4VwVV7zIumNgoH"

download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")
Myoauth <- OAuthFactory$new(consumerKey=consumerKey, consumerSecret=consumerSecret, requestURL=requestURL, accessURL=accessURL, authURL=authURL)
Myoauth$handshake(cainfo="cacert.pem")
save(Myoauth, file="authdata.Rdata")
load("authdata.Rdata")

#c("Presidential Elections", "US Elections", "Hilary Clinton","Bernie Sanders","Donald Trump","Ted Cruz","Marco Rubio")
#c("House Rent","House Rental","Apartment Rent","Apartment Rental")
filterStream(file.name = "ashwinmi_tweets.json",
             track = c("Presidential Elections", "US Elections", "Hilary Clinton","Bernie Sanders","Donald Trump","Ted Cruz","Marco Rubio"),
             language = "en",
             locations= c(-74,40,-73,41),
             tweets  = 200,
             oauth = Myoauth)
