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
EPI.old
NAs_old <- is.na(EPI.old) # records true values if the value is NA
EPI.old.noNAs <- EPI.old[!NAs_old] # filters out NA values, New array

# Data Exploration
summary(EPI.old)
fivenum(EPI.old,na.rm=TRUE)
stem(EPI.old)
hist(EPI.old)
hist(EPI.old, seq(10., 80., 1.0), prob=TRUE)
line(density(EPI.old,na.rm=TRUE,bw=1))
rug(EPI.old)
boxplot(EPI.new, EPI.old, names = c("EPI.new", "EPI.old"), main = "Boxplot of EPI.new and EPI.old", ylab = "Values", col = c("lightblue", "pink"))

line(density(EPI.old,na.rm=TRUE,bw="SJ"))
X<-seq(10,80,1)
q<-dnorm(X,mean=41, sd=4,log = FALSE)
lines(X,q)
lines(X,.4*q)
q<-dnorm(X,mean=62, sd=4,log=FALSE)
lines(X,.12*q)

# Cumulative density function 
plot(ecdf(EPI.old), do.points=FALSE, verticals = TRUE)

#Quantile 
qqnorm(EPI.old);qqline(EPI.old)
qqplot(rnorm(250), EPI.old, xlab="Q-Q plot for norm dsn")
qqline(EPI.old)
qqplot(rt(250, df=5),EPI.old, xlab = "Q-Q plot for t dsn")
qqline(EPI.old)
