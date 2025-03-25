library("ggplot2")
library("readr")
library(readr)
library(class)      # For kNN
library(caret)      # For confusion matrix
library(dplyr)      # For data manipulation

library(readr)
abalone_dataset <- read_csv("C:/Users/jacin/OneDrive/Desktop/DATA ANALYTICS 2025/abalone_dataset.csv")
View(abalone_dataset)


dataset <- abalone_dataset

## add new column age.group with 3 values based on the number of rings 
dataset$age.group <- cut(dataset$rings, br=c(0,8,11,35), labels = c("young", 'adult', 'old'))


## alternative way of setting age.group
dataset$age.group[dataset$rings<=8] <- "young"
dataset$age.group[dataset$rings>8 & dataset$rings<=11] <- "adult"
dataset$age.group[dataset$rings>11 & dataset$rings<=35] <- "old"

View(dataset)

#Exercise 1: Classification - kNN 

# sample create list (70% of 4176) numbers randomly sampled from 1 - 4176
n = 4176
s_data <- sample(n,n*.7)

## create train & test sets based on sampled indexes 
dataset.train <- dataset[s_data,]

dataset.test <- dataset[-s_data,]

# simple estimate of k
k = round(sqrt(n))


########################
# Train & Evaluate knn #
########################

# Model 1

## train model & predict in one step ('knn' function from 'class' library)
knn.predicted <- knn(train = dataset.train[,2:4], test = dataset.test[,2:4], cl = dataset.train$age.group, k = 65)

# create contingency table/ confusion matrix 
contingency.table <- table(knn.predicted, dataset.test$age.group, dnn=list('predicted','actual'))

contingency.table

# calculate classification accuracy
sum(diag(contingency.table))/length(dataset.test$age.group)

# Model 2

knn.predicted <- knn(train = dataset.train[,5:8], test = dataset.test[,5:8], cl = dataset.train$age.group, k = 65)

# create contingency table/ confusion matrix 
contingency.table <- table(knn.predicted, dataset.test$age.group, dnn=list('predicted','actual'))

contingency.table

# calculate classification accuracy
sum(diag(contingency.table))/length(dataset.test$age.group)


##################
# Find optimal k #
##################


## train knn models for multiple values of k and plot accuracies

# list of k
k.list <- c(45,55,60,65,75,85,105,155,205)

# empty list for accuracy
accuracy.list <- c()

# loop: train&predict model for each k, compute accuracy and append it to list
for (k in k.list) {
  
  knn.predicted <- knn(train = dataset.train[,5:8], test = dataset.test[,5:8], cl = dataset.train$age.group, k = k)
  
  contingency.table <- table(knn.predicted, dataset.test$age.group, dnn=list('predicted','actual'))
  
  accuracy <- sum(diag(contingency.table))/length(dataset.test$age.group)
  
  accuracy.list <- c(accuracy.list,accuracy)
  
}


# plot acccuracy with k, limiting values of y axis between .9 & 1
plot(k.list,accuracy.list,type = "b")


####################################################################################
# Exercise 2: Classification- Kmeans

## plot dataset colored by class
ggplot(dataset, aes(x = whole_weight, y = viscera_wieght, colour = age.group)) +
  geom_point()

## set random number generator start value
# set.seed(123)

## run kmeans
k = 3
data.km <- kmeans(dataset[,5:8], centers = k)


## get and plot clustering output 

assigned.clusters <- as.factor(data.km$cluster)

ggplot(dataset, aes(x = whole_weight, y = viscera_wieght, colour = age.group)) +
  geom_point()


## WCSS: total within cluster sum of squares
data.km$tot.withinss

data.km$cluster


## run tests with multiple k values and plot WCSS
k.list <- c(2,3,4,5,6)

wcss.list <- c()

for (k in k.list) {
  
  data.km<- kmeans(dataset[,5:8], centers = k)
  
  wcss <- data.km$tot.withinss
  
  wcss.list <- c(wcss.list,wcss)
  
  ## get and plot clustering output 
  assigned.clusters <- as.factor(data.km$cluster)
  
  ggplot(dataset, aes(x = whole_weight, y = viscera_wieght, colour = age.group)) +
    geom_point()
  
  
}

plot(k.list,wcss.list,type = "b")


#### END ####


