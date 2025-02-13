# Lab 1

# Read the CSV file 

EPI_data <- epi2024results06022024

View(EPI_data)
attach(EPI_data)
EPI.new
NAs <- is.na(EPI.new) # records true values if the value is NA
EPI.new.noNAs <- EPI.new[!NAs] # filters out NA values, New array

# Data Cleaning 
# Data Exploration
summary(EPI.new)
fivenum(EPI.new,na.rm=TRUE)
stem(EPI.new)
hist(EPI.new)
hist(EPI.new, seq(20., 80., 1.0), prob=TRUE)
line(density(EPI.new,na.rm=TRUE,bw=1))
rug(EPI.new)
boxplot(EPI.new, APO.new, names = c("EPI", "APO"), main = "Boxplot of EPI and APO", ylab = "Values", col = c("lightblue", "lightgreen"))
hist(EPI.new, seq(20., 80., 1.0), prob=TRUE)
line(density(EPI.new,na.rm=TRUE,bw="SJ"))
rug(EPI.new)
X<-seq(20,80,1)
q<-dnorm(X,mean=42, sd=5,log = FALSE)
lines(X,q)
lines(X,.4*q)
q<-dnorm(X,mean=65, sd=5,log=FALSE)
lines(X,.12*q)

# Exercise 2: Fitting a Distribution beyond Histogram
# Cumulative density function 
plot(ecdf(EPI.new), do.points=FALSE, verticals = TRUE)

#Quantile 
qqnorm(EPI.new);qqline(EPI.new)
qqplot(rnorm(250), EPI.new, xlab="Q-Q plot for norm dsn")
qqline(EPI.new)
qqplot(rt(250, df=5),EPI.new, xlab = "Q-Q plot for t dsn")
qqline(EPI.new)

# Exercise 2a 
ECO.old
NAs_old <- is.na(ECO.old) # records true values if the value is NA
ECO.old.noNAs <- ECO.old[!NAs_old] # filters out NA values, New array

# Data Exploration
summary(ECO.old.noNAs)
fivenum(ECO.old.noNAs,na.rm=TRUE)
stem(ECO.old.noNAs)
hist(ECO.old.noNAs)
hist(ECO.old.noNAs, seq(10., 100., 1.0), prob=TRUE)
line(density(ECO.old.noNAs,na.rm=TRUE,bw=1))
rug(ECO.old.noNAs)
boxplot(PAR.new, ECO.old.noNAs, names = c("PAR.new", "ECO.old"), main = "Boxplot of PAR.new and ECO.old", ylab = "Values", col = c("lightblue", "pink"))

line(density(ECO.old.noNAs,na.rm=TRUE,bw="SJ"))
X<-seq(10,100,1)
q<-dnorm(X,mean=50, sd=10,log = FALSE)
lines(X,q)
lines(X,1.55*q)

# Cumulative density function 
plot(ecdf(ECO.old.noNAs), do.points=FALSE, verticals = TRUE)

#Quantile 
qqnorm(ECO.old.noNAs);qqline(ECO.old.noNAs)
qqplot(rnorm(250), ECO.old.noNAs, xlab="Q-Q plot for norm dsn")
qqline(ECO.old.noNAs)
qqplot(rt(250, df=5),ECO.old.noNAs, xlab = "Q-Q plot for t dsn")
qqline(ECO.old.noNAs)
