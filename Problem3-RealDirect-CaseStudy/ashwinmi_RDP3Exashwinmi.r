require(gdata)
library(plyr)
library(ggplot2)
library("doBy")

quns <- read.csv("dds_ch2_rollingsales/rollingsales_queens.csv")
head(quns)
summary(quns)

quns$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","",quns$SALE.PRICE))
count(is.na(quns$SALE.PRICE.N))
names(quns) <- tolower(names(quns))

## clean/format the data with regular expressions
quns$gross.sqft <- as.numeric(gsub("[^[:digit:]]","",quns$gross.square.feet))
quns$land.sqft <- as.numeric(gsub("[^[:digit:]]","",quns$land.square.feet))
#quns$sale.date <- as.Date(quns$sale.date)
quns$year.built <- as.numeric(as.character(quns$year.built))

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
attach(quns)
hist(sale.price.n)
hist(sale.price.n[sale.price.n>0])
hist(gross.sqft[sale.price.n==0])
detach(quns)

## keep only the actual sales
quns.sale <- quns[quns$sale.price.n!=0,]
plot(quns.sale$gross.sqft,quns.sale$sale.price.n)
plot(log(quns.sale$gross.sqft),log(quns.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
quns.homes <- quns.sale[which(grepl("FAMILY",quns.sale$building.class.category)),]
plot(log(quns.homes$gross.sqft),log(quns.homes$sale.price.n))

quns.homes[which(quns.homes$sale.price.n<100000),][order(quns.homes[which(quns.homes$sale.price.n<100000),]$sale.price.n),]

## remove outliers that seem like they weren't actual sales
quns.homes$outliers <- (log(quns.homes$sale.price.n) <=5) + 0
quns.homes <- quns.homes[which(quns.homes$outliers==0),]
plot(log(quns.homes$gross.sqft),log(quns.homes$sale.price.n))

# create categories
quns.homes$build.cat[grepl("01",quns.homes$building.class.category)] <- 1
quns.homes$build.cat[grepl("02",quns.homes$building.class.category)] <- 2
quns.homes$build.cat[grepl("03",quns.homes$building.class.category)] <- 3
quns.homes$build.cat <- factor(quns.homes$build.cat)

siterange <- function(x){c(length(x), min(x), mean(x), max(x))}
summaryBy(quns.homes$sale.price.n~quns.homes$build.cat, data =quns.homes, FUN=siterange)
summaryBy(quns.homes$gross.sqft~quns.homes$build.cat, data =quns.homes, FUN=siterange)
summaryBy(quns.homes$sale.price.n~quns.homes$neighborhood, data =quns.homes, FUN=siterange)

quns.homes$gross.sqft.cat <- cut(quns.homes$gross.sqft,c(-Inf,0,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,Inf))

xrange <- range(quns.homes$year.built) 
yrange <- range(quns.homes$sale.price.n) 

#ggplot(quns.homes, aes(x=quns.homes$gross.sqft.cat, y=quns.homes$sale.price.n,fill=quns.homes$build.cat)) + geom_boxplot()
boxplot(sale.price.n~build.cat,data=quns.homes, main="Building Category Price Data", xlab="Number of Units", ylab="Sale Price")
boxplot(gross.sqft~build.cat,data=quns.homes, main="Building Category Sqft Data", xlab="Number of Units", ylab="Gross Sqft")

boxplot(sale.price.n~year.built,data=subset(quns.homes,quns.homes$build.cat==1), main="Price vs Year for houses with 1 unit", xlab="Years", ylab="Sale Price")
boxplot(sale.price.n~year.built,data=subset(quns.homes,quns.homes$build.cat==2), main="Price vs Year for houses with 2 units", xlab="Years", ylab="Sale Price")
boxplot(sale.price.n~year.built,data=subset(quns.homes,quns.homes$build.cat==3), main="Price vs Year for houses with 3 units", xlab="Years", ylab="Sale Price")

boxplot(log(sale.price.n)~neighborhood,data=subset(quns.homes,quns.homes$build.cat==1), main="Price vs Neighbourhood for houses with 1 unit", xlab="Neighbourhood", ylab="Sale Price")
boxplot(log(sale.price.n)~neighborhood,data=subset(quns.homes,quns.homes$build.cat==2), main="Price vs Neighbourhood for houses with 2 units", xlab="Neighbourhood", ylab="Sale Price")
boxplot(log(sale.price.n)~neighborhood,data=subset(quns.homes,quns.homes$build.cat==3), main="Price vs Neighbourhood for houses with 3 units", xlab="Neighbourhood", ylab="Sale Price")

ggplot(quns.homes, aes(x=quns.homes$building.class.category, y=log(quns.homes$sale.price.n), fill=quns.homes$neighborhood))+geom_boxplot()
