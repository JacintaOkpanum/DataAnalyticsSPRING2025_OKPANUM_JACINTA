library("ggplot2")
library("readr")
library(readr)
library(class)      # For kNN
library(caret)      # For confusion matrix
library(dplyr)      # For data manipulation
library(caret)
library(ggfortify)
library(e1071)
library(readr)
wine <- read_csv("C:/Users/jacin/OneDrive/Desktop/DATA ANALYTICS 2025/wine.data")


colnames(wine) <- c("class.wine","Alcohol","Malic acid","Ash","Alcalinity of ash","Magnesium","Total phenols","Flavanoids","Nonflavanoid phenols","Proanthocyanins","Color intensity","Hue","OD280/OD315 of diluted wines","Proline")
View(wine)

Y <- wine[, 1]            # the class column
wine_numeric <- wine[, -1]  # Remove the first column (class.wine)

# Scale the dataset to avoid bias in PCA evaluation 

wine_scaled <- scale(wine_numeric)  # Standardize data

# Check for the mean and std of the scaled dataset
apply(wine_scaled, 2, mean)  # Should be ~ 0
apply(wine_scaled, 2, sd)    # Should be ~ 1

####### PCA #######

principal_components <- princomp(wine_scaled, cor = TRUE, score = TRUE)
principal_components$scores

summary(principal_components)

principal_components$loadings

# using the plot() function, we can plot the principal components.
plot(principal_components)

# plotting the principal_components using the a line in plot() functions 
plot(principal_components, type = "l")

################# Plot the dataset using the 1st and 2nd PC ###############

# Convert PCA results to a dataframe
pca_data <- as.data.frame(principal_components$scores)  # Extract PC scores
pca_data$class <- wine$class.wine  # Add back class labels

# Scatter plot of first two principal components
ggplot(pca_data, aes(x = Comp.1, y = Comp.2, color = as.factor(class))) +
  geom_point(size = 3, alpha = 0.8) +
  labs(title = "PCA: PC1 vs PC2", x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()

###### Identify and drop the list contributing variables ###########

pc1_loadings <- abs(principal_components$loadings[,1])  # Get absolute loadings for PC1
pc1_loadings_sorted <- sort(pc1_loadings, decreasing = TRUE)  # Sort in descending order
print(pc1_loadings_sorted)

# Select variables to drop 
least_contributing_vars <- names(tail(pc1_loadings_sorted, 2))  # Adjust based on results
least_contributing_vars

# Create a new dataset without the least contributing variables
wine_reduced <- wine_numeric[, !(colnames(wine_numeric) %in% least_contributing_vars)]
wine_reduced
# Scale the new dataset
wine_scaled_reduced <- scale(wine_reduced)

# Rerun PCA
pca_reduced <- prcomp(wine_scaled_reduced, center = TRUE, scale. = FALSE)

# Check variance explained again
summary(pca_reduced)

############# kNN Classification ###########

# sample create list  
n = 177
s_data <- sample(n,n*.7)

wine_scaled_df <- as.data.frame(wine_scaled)  # Convert matrix to data frame
wine_scaled_df$class <- as.factor(wine$class.wine)       # Add class column


## create train & test sets based on sampled indexes 
dataset.train <- wine_scaled_df[s_data,]

dataset.test <- wine_scaled_df[-s_data,]

# simple estimate of k
k = round(sqrt(n))

########################
# Train & Evaluate knn #
########################

################### Model 1: Original Dataset #####################

## train model & predict in one step ('knn' function from 'class' library)
knn.predicted <- knn(train = dataset.train, test = dataset.test, cl = dataset.train$class, k = 13)

# create contingency table/ confusion matrix 
contingency.table <- table(knn.predicted, dataset.test$class, dnn=list('predicted','actual'))

contingency.table

# calculate classification accuracy
sum(diag(contingency.table))/length(dataset.test$class)


########## Model 2:  using the data projected into the first 3 PCs #################

# Convert PCA scores to a dataframe
pca_data <- as.data.frame(pca_reduced$x)  # Extract transformed data

# Keep only the first 3 PCs
pca_knn_data <- pca_data[, 1:3]

# Add class labels (wine type)
pca_knn_data$class <- as.factor(wine$class.wine)  # Ensure it's a factor for classification

## create train & test sets based on sampled indexes 
dataset.train <- pca_knn_data[s_data,]

dataset.test <- pca_knn_data[-s_data,]

## train model & predict in one step ('knn' function from 'class' library)
knn.predicted <- knn(train = dataset.train, test = dataset.test, cl = dataset.train$class, k = 13)

# create contingency table/ confusion matrix 
contingency.table <- table(knn.predicted, dataset.test$class, dnn=list('predicted','actual'))

contingency.table

# calculate classification accuracy
sum(diag(contingency.table))/length(dataset.test$class)


############### Precision/ Recall/ F1 score Metrics ##################################

# Initialize vectors to store metrics
precision <- c()
recall <- c()
f1_score <- c()

# Loop over each class
classes <- colnames(contingency.table)

for (class in classes) {
  TP <- contingency.table[class, class]  # True Positives
  FP <- sum(contingency.table[class, ]) - TP  # False Positives
  FN <- sum(contingency.table[, class]) - TP  # False Negatives
  
  # Compute metrics
  prec <- TP / (TP + FP)  # Precision
  rec <- TP / (TP + FN)  # Recall
  f1 <- 2 * (prec * rec) / (prec + rec)  # F1 Score
  
  # Store values
  precision <- c(precision, prec)
  recall <- c(recall, rec)
  f1_score <- c(f1_score, f1)
}

# Create a summary data frame
metrics_df <- data.frame(Class = classes, Precision = precision, Recall = recall, F1_Score = f1_score)
print(metrics_df)



