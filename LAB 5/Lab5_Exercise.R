library("ggplot2")
library("readr")
library(readr)
library(class)      # For kNN
library(caret)      # For confusion matrix
library(dplyr)      # For data manipulation
library(caret)
library(ggfortify)

library(e1071)

wine <- read_csv("C:/Users/jacin/OneDrive/Desktop/DATA ANALYTICS 2025/wine.data")
colnames(wine) <- c("class.wine","Alcohol","Malic acid","Ash","Alcalinity of ash","Magnesium","Total phenols","Flavanoids","Nonflavanoid phenols","Proanthocyanins","Color intensity","Hue","OD280/OD315 of diluted wines","Proline")

wine_class <- wine[, 1]            # the class column
wine_numeric <- wine[, -1]  # Remove the first column (class.wine)

# Scale the dataset to avoid bias in analysis 

wine_scaled <- scale(wine_numeric)  # Standardize data
# Check for the mean and std of the scaled dataset
apply(wine_scaled, 2, mean)  # Should be ~ 0
apply(wine_scaled, 2, sd)    # Should be ~ 1

wine_scaled <- as.data.frame(wine_scaled)
wine_scaled$wine.class <- factor(wine_class$class.wine)


# ## split train/test
n <- nrow(wine)
train.indexes <- sample(n,0.7*n)

## separate x (features) & y (class labels)
X_train <- wine_scaled[train.indexes,]
X_test <- wine_scaled[-train.indexes,]

Y_train <- wine_class[train.indexes,]
Y_test <- wine_class[-train.indexes,]

## feature boxplots
boxplot(X_train[, 1:13], main="wine features")

## class label distributions
plot(Y_train)

ggplot(X_train, aes(x = Alcohol, y = Hue, colour = wine.class)) +
  geom_point()

###############################
### Support Vector Machines ###
###############################

################    MODEL 1   ###########################
##train SVM model - linear kernel
svm.mod0 <- svm(
  wine.class ~ Alcohol + `Malic acid` + Ash + `Alcalinity of ash` +
    `Total phenols` + Flavanoids + `Color intensity`,
  data = X_train,
  kernel = "linear"
)

svm.mod0

train.pred <- predict(svm.mod0, X_train)

cm = as.matrix(table(Actual = X_train$wine.class, Predicted = train.pred))

cm

################    MODEL 2   ###########################
##train SVM model - radial

svm.mod1 <- svm(
  wine.class ~ Alcohol + `Malic acid` + Ash + `Alcalinity of ash` +
    `Total phenols` + Flavanoids + `Color intensity`,
  data = X_train,
  kernel = "radial"
)

svm.mod1

train.pred <- predict(svm.mod1, X_train)

cm = as.matrix(table(Actual = X_train$wine.class, Predicted = train.pred))

cm

n = sum(cm) # number of instances
nc = nrow(cm) # number of classes
diag = diag(cm) # number of correctly classified instances per class 
rowsums = apply(cm, 1, sum) # number of instances per class
colsums = apply(cm, 2, sum) # number of predictions per class
p = rowsums / n # distribution of instances over the actual classes
q = colsums / n # distribution of instances over the predicted 

recall = diag / rowsums 
precision = diag / colsums
f1 = 2 * precision * recall / (precision + recall) 

data.frame(precision, recall, f1)

################### Tuned SVM - radial ########################

tuned.svm <- tune.svm(wine.class ~ Alcohol + `Malic acid` + Ash + `Alcalinity of ash` +
                        `Total phenols` + Flavanoids + `Color intensity`,
                      data = X_train,
                      kernel = "radial",gamma = seq(1/2^nrow(X_train),1, .01), cost = 2^seq(-6, 4, 2))

tuned.svm

svm.mod2 <- svm(wine.class ~ Alcohol + `Malic acid` + Ash + `Alcalinity of ash` +
                  `Total phenols` + Flavanoids + `Color intensity`,
                data = X_train,
                kernel = "radial", gamma = .01, cost = 1)

svm.mod2

train.pred <- predict(svm.mod2, X_train)

cm = as.matrix(table(Actual = X_train$wine.class, Predicted = train.pred))

cm

n = sum(cm) # number of instances
nc = nrow(cm) # number of classes
diag = diag(cm) # number of correctly classified instances per class 
rowsums = apply(cm, 1, sum) # number of instances per class
colsums = apply(cm, 2, sum) # number of predictions per class
p = rowsums / n # distribution of instances over the actual classes
q = colsums / n # distribution of instances over the predicted 

recall = diag / rowsums 
precision = diag / colsums
f1 = 2 * precision * recall / (precision + recall) 

data.frame(precision, recall, f1)




################    MODEL 3   ###########################
############ Train kNN 

# simple estimate of k
k = round(sqrt(n))

## train model & predict in one step ('knn' function from 'class' library)
knn.predicted <- knn(train = X_train, test = X_train, cl = X_train$wine.class, k = 13)

# create contingency table/ confusion matrix 
contingency.table <- table(knn.predicted, X_train$wine.class, dnn=list('predicted','actual'))

contingency.table <- cm
cm

n = sum(cm) # number of instances
nc = nrow(cm) # number of classes
diag = diag(cm) # number of correctly classified instances per class 
rowsums = apply(cm, 1, sum) # number of instances per class
colsums = apply(cm, 2, sum) # number of predictions per class
p = rowsums / n # distribution of instances over the actual classes
q = colsums / n # distribution of instances over the predicted 

recall = diag / rowsums 
precision = diag / colsums
f1 = 2 * precision * recall / (precision + recall) 

data.frame(precision, recall, f1)




