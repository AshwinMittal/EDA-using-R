library("doBy")
library(ggplot2)

i <- 1:31
file_name<-paste0("nyt",i,".csv")
f <- file.path("dds_ch2_nyt",file_name)
data2 <- do.call(rbind, lapply(f, read.csv))
head(data2)

data2$agecat <- cut(data2$Age,c(-Inf,0,18,24,34,44,54,64,Inf))
data2$gencat <-cut(data2$Gender,c(-Inf,0,Inf))
data2$usrcat <-cut(data2$Signed_In,c(-Inf,0,Inf))

# view
summary(data2)

# brackets
siterange <- function(x){c(length(x), min(x), mean(x), max(x))}
summaryBy(Age~agecat, data =data2, FUN=siterange)

# so only signed in users have ages and genders
summaryBy(Gender+Signed_In+Impressions+Clicks~agecat,data =data2)

# create click thru rate
data2$CTR =  as.numeric(data2$Clicks)/as.numeric(data2$Impressions)
data2$hasimps <-cut(data2$Impressions,c(-Inf,0,Inf))
summaryBy(Clicks~hasimps, data =data2, FUN=siterange)

# create categories
data2$scode[data2$Impressions==0] <- "NoImps"
data2$scode[data2$Impressions >0] <- "Imps"
data2$scode[data2$Clicks >0] <- "Clicks"
data2$sgen[data2$Gender ==0] <- "Female"
data2$sgen[data2$Gender ==1] <- "Male"
data2$susr[data2$Signed_In ==0] <- "Public"
data2$susr[data2$Signed_In ==1] <- "SignedIn"

F_under18 <- data2[ which(data2$sgen =='Female' & data2$Age < 18 & data2$Age > 0),]
M_under18 <- data2[ which(data2$sgen =='Male' & data2$Age < 18 & data2$Age > 0),]
U_under18 <- rbind(F_under18,M_under18)

# Convert the column to a factor
data2$scode <- factor(data2$scode)
data2$sgen <- factor(data2$sgen)
data2$susr <- factor(data2$susr)

# plot
ggplot(data2, aes(x=Impressions, fill=agecat))+geom_histogram(binwidth=0.5)
ggplot(data2, aes(x=agecat, y=Impressions, fill=agecat))+geom_boxplot()

ggplot(data2, aes(x=Impressions, fill=sgen))+geom_histogram(binwidth=1)
ggplot(data2, aes(x=Impressions, fill=susr))+geom_histogram(binwidth=1)
ggplot(data2, aes(x=sgen, y=Impressions, fill=sgen))+geom_boxplot()
ggplot(data2, aes(x=susr, y=Impressions, fill=susr))+geom_boxplot()

ggplot(subset(data2, Impressions>0), aes(x=CTR,colour=agecat)) + geom_density()
ggplot(subset(data2, Clicks>0), aes(x=CTR,colour=agecat)) + geom_density()
ggplot(subset(data2, Clicks>0), aes(x=agecat, y=Clicks,fill=agecat)) + geom_boxplot()
ggplot(subset(data2, Clicks>0), aes(x=Clicks, colour=agecat))+ geom_density()

ggplot(subset(data2, CTR>0), aes(x=CTR,colour=sgen)) + geom_density()
ggplot(subset(U_under18, Clicks>0 & Signed_In==1), aes(x=Clicks, colour=sgen))+ geom_density()
ggplot(subset(U_under18, CTR>0 & Signed_In==1), aes(x=CTR,colour=sgen)) + geom_density()
ggplot(subset(data2, CTR>0), aes(x=sgen, y=CTR,fill=agecat)) + geom_boxplot()

counts <- c(nrow(subset(F_under18, CTR>0)), nrow(subset(M_under18, CTR>0)))
barplot(as.matrix(counts), main="<18-year-old males versus < 18-year-old females",
        col=c("darkblue","red"),
        legend = c("Female","Male"), beside=TRUE)

#look at levels
clen <- function(x){c(length(x))}
etable<-summaryBy(Impressions~scode+Gender+agecat,data = data1, FUN=clen)
etable
