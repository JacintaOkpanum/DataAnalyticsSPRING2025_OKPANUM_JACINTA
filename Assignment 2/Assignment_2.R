library("ggplot2")
library("readr")
library(readr)
library(class)      # For kNN
library(caret)      # For confusion matrix
library(dplyr)      # For data manipulation
epi_results_2024_pop_gdp <- read_csv("C:/Users/jacin/OneDrive/Desktop/DATA ANALYTICS 2025/epi_results_2024_pop_gdp.csv")
View(epi_results_2024_pop_gdp)

My_dataset <- epi_results_2024_pop_gdp
attach(My_dataset)
View(My_dataset)

# Check for NAN
sum(is.na(My_dataset$population))
sum(is.na(My_dataset$gdp))
sum(is.na(My_dataset$EPI.new))
sum(is.na(My_dataset$ECO.new))
sum(is.na(My_dataset$BDH.new))
sum(is.na(My_dataset$SPI.new))
sum(is.na(My_dataset$BER.new))
sum(is.na(My_dataset$RLI.new))


# Remove rows where population or gdp is NA

My_dataset <- My_dataset[!is.na(My_dataset$population) & 
                           !is.na(My_dataset$gdp) & 
                           !is.na(My_dataset$SPI.new) & 
                           !is.na(My_dataset$BER.new) & 
                           !is.na(My_dataset$RLI.new), ]

# Variable Distribution 

# Display unique values from the 'region' column
unique_regions <- unique(My_dataset$region)

# Print unique regions
print(unique_regions)


# Select two different regions 
region1 <- unique_regions[4]  
region2 <- unique_regions[5]  

# Create subsets
subset_region1 <- subset(My_dataset, region == region1)
subset_region2 <- subset(My_dataset, region == region2)

# Print first few rows of each subset
print(head(subset_region1))
print(head(subset_region2))

# Check the shape of the first subset
dim(subset_region1)  # Returns c(number of rows, number of columns)
nrow(subset_region1) # Returns number of rows
ncol(subset_region1) # Returns number of columns

# Check the shape of the second subset
dim(subset_region2)
nrow(subset_region2)
ncol(subset_region2)

# Define the variable
variable <- "EPI.new"

# Plot histograms with density lines for both regions
p1 <- ggplot(subset_region1, aes(x = EPI.new)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "blue", alpha = 0.5) +
  geom_density(color = "red", size = 1) +
  ggtitle(paste("Histogram with Density -", region1)) +
  theme_minimal()

p2 <- ggplot(subset_region2, aes(x = EPI.new)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "green", alpha = 0.5) +
  geom_density(color = "red", size = 1) +
  ggtitle(paste("Histogram with Density -", region2)) +
  theme_minimal()

# Display plots
print(p1)
print(p2)

# Q-Q Plots

# Q-Q plot function
qq_plot <- function(data, region_name, variable) {
  ggplot(data, aes(sample = get(variable))) +
    stat_qq(distribution = qnorm) +  # Compare against a normal distribution
    stat_qq_line(distribution = qnorm, color = "red") +
    ggtitle(paste("Q-Q Plot -", region_name)) +
    theme_minimal()
}

# Generate Q-Q plots for both regions
p1 <- qq_plot(subset_region1, region1, variable)
p2 <- qq_plot(subset_region2, region2, variable)

# Display plots
print(p1)
print(p2)

# linear models

#Visualization 

ggplot(My_dataset, aes(x = log10(gdp), y = (ECO.new))) + 
  geom_point()

ggplot(My_dataset, aes(x = log10(population), y = log10(ECO.new))) +
  geom_point()


## fit linear model

lmod_11 <- lm((EPI.new) ~ log10(population) + log10(gdp) , data = My_dataset)

lmod_22 <- lm((EPI.new)~ log10(gdp), data = My_dataset)

lmod_33 <- lm((EPI.new)~log10(population) , data = My_dataset)

## print model output
summary(lmod_11)
summary(lmod_22)
summary(lmod_33)

lmod_1 <- lm((ECO.new) ~ log10(population) + log10(gdp) , data = My_dataset)

lmod_2 <- lm((ECO.new)~ log10(gdp), data = My_dataset)

lmod_3 <- lm((ECO.new)~log10(gdp) , data = My_dataset)
## print model output
summary(lmod_1)
summary(lmod_2)
summary(lmod_3)

# Fitting models with subsets of sub regions 

attach(subset_region1)
View(subset_region1)


lmod_s1 <- lm((EPI.new)~log10(population) + log10(gdp), data = subset_region1)
summary(lmod_s1)

#Creating new columns for log transformation of the predictors 

My_dataset$log10_population <- log10(My_dataset$population)
My_dataset$log10_gdp <- log10(My_dataset$gdp)


# Plot log10_gdp vs EPI.new with regression line

p1 <- ggplot(My_dataset, aes(x = log10_gdp, y = EPI.new)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  ggtitle("EPI.new vs log10(GDP)") +
  theme_minimal()

# Plot log10_gdp vs ECO.new with regression line
p2 <- ggplot(My_dataset, aes(x = log10_gdp, y = ECO.new)) +
  geom_point(alpha = 0.6, color = "green") +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  ggtitle("ECO.new vs log10(GDP)") +
  theme_minimal()

# Plot residuals for EPI.new model
residuals_epi <- data.frame(Fitted = fitted(lmod_22), Residuals = resid(lmod_22))
p3 <- ggplot(residuals_epi, aes(x = Fitted, y = Residuals)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  ggtitle("Residuals Plot for EPI.new Model") +
  theme_minimal()

# Plot residuals for ECO.new model
residuals_eco <- data.frame(Fitted = fitted(lmod_2), Residuals = resid(lmod_2))
p4 <- ggplot(residuals_eco, aes(x = Fitted, y = Residuals)) +
  geom_point(alpha = 0.6, color = "green") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  ggtitle("Residuals Plot for ECO.new Model") +
  theme_minimal()

# Plot residuals for Sub Region model
residuals_sub <- data.frame(Fitted = fitted(lmod_s1), Residuals = resid(lmod_s1))
p5 <- ggplot(residuals_sub, aes(x = Fitted, y = Residuals)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  ggtitle("Residuals Plot for Sub-Saharan Africa Model") +
  theme_minimal()

# Plot log10_gdp vs ECO.new with regression line for sub region 
p6 <- ggplot(subset_region1, aes(x = log10(gdp), y = EPI.new)) +
  geom_point(alpha = 0.6, color = "green") +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  ggtitle("EPI.new vs log10(GDP) for Sub-Saharan Africa ") +
  theme_minimal()

# Display plots
print(p1)
print(p2)
print(p3)
print(p4)
print(p5)
print(p6)

# Classification (kNN) 

# Define the two regions
selected_regions <- c("Sub-Saharan Africa", "Latin America & Caribbean")

# Create the subset using base R 
subset_data <- My_dataset[My_dataset$region %in% selected_regions, c("region", "SPI.new", "BER.new", "RLI.new")]

# View the first few rows of the subset
head(subset_data)

# Convert region to factor (for classification)
subset_data$region <- as.factor(subset_data$region)

## plot subset_data colored by class
ggplot(subset_data, aes(x = BER.new, y = RLI.new, colour = region)) +
  geom_point()

# Normalize the numerical features
#normalize <- function(x) { (x - min(x)) / (max(x) - min(x)) }
#subset_data[, 2:4] <- lapply(subset_data[, 2:4], normalize)

# Split data into training (80%) and testing (20%)
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(subset_data), 0.8 * nrow(subset_data))
train_data <- subset_data[train_index, ]
test_data <- subset_data[-train_index, ]

# Extract features and labels
train_x <- train_data[, 2:4]  # Predictor variables
train_y <- train_data$region  # Response variable
test_x <- test_data[, 2:4]
test_y <- test_data$region


n <- 76
# simple estimate of k
k_v = round(sqrt(n))

k_v <- k_v

# Train and evaluate kNN model for different k values
k_values <- c(3, 9, 12)  # Try different k values
for (k in k_values) {
  knn_pred <- knn(train_x, test_x, train_y, k = k)
  
  # Compute confusion matrix
  cm <- confusionMatrix(knn_pred, test_y)
  
  
  # Accuracy calculation
  accuracy <- sum(diag(cm$table)) / sum(cm$table)
  
  print(paste("k =", k, "Accuracy =", round(accuracy, 3)))
  print(cm)
}

##############################################################################

## train model & predict in one step ('knn' function from 'class' library)
knn.predicted <- knn(train_x, test_x, train_y, k = 9)

# create contingency table/ confusion matrix 
contingency.table <- table(knn.predicted, test_y, dnn=list('predicted','actual'))

contingency.table

# calculate classification accuracy
sum(diag(contingency.table))/length(test_y)


