# LAB 2 Activities and Exercises 
# LINEAR REGRESSION
# Class Example 


library("ggplot2")
library("readr")

NY_House_Dataset <- read_csv("C:/Users/jacin/OneDrive/Desktop/DATA ANALYTICS 2025/NY-House-Dataset.csv")
View(NY_House_Dataset)
dataset <- NY_House_Dataset
View(dataset)
attach(dataset)

ggplot(dataset, aes(x = log10(PROPERTYSQFT), y = log10(PRICE))) +
  geom_point()

## filter data
dataset <- dataset[dataset$PRICE<195000000,]

dataset <- dataset[dataset$PROPERTYSQFT!=2184.207862,]

dataset$PROPERTYSQFT[dataset$BROKERTITLE=="Brokered by Douglas Elliman - 575 Madison Ave"][85]

ggplot(dataset, aes(x = log10(PROPERTYSQFT), y = log10(PRICE))) +
  geom_point()

## column names
names(dataset)


# LAB Exercise 

# combinations of PropertySqFt, Beds, and Bath as predictors

ggplot(dataset, aes(x = BEDS, y = PRICE)) +
  geom_point()

ggplot(dataset, aes(x = BATH, y = PRICE)) +
  geom_point()



## filter data
dataset <- dataset[dataset$PRICE<24500000,]

dataset <- dataset[dataset$BEDS<15,]

dataset <- dataset[dataset$BATH<15,]



## Filter out NaN, Inf in log data
dataset <- dataset[!is.na(dataset$PRICE) & 
                     !is.na(dataset$PROPERTYSQFT) & 
                     !is.na(dataset$BEDS) & 
                     !is.na(dataset$BATH) & 
                     dataset$PROPERTYSQFT > 0 & 
                     dataset$PRICE > 0, ]


## Check for error in log values 
colSums(is.na(dataset))  # Count NAs in each column
sum(is.infinite(log10(dataset$PRICE)))      # Check for Inf in PRICE
sum(is.infinite(log10(dataset$PROPERTYSQFT)))  # Check for Inf in PROPERTYSQFT
sum(is.infinite((dataset$BEDS)))       # Check for Inf in BEDS
sum(is.infinite((dataset$BATH)))      # Check for Inf in BATHS



## fit linear model

lmod_11 <- lm(log10(PRICE) ~ log10(PROPERTYSQFT) + (BEDS) + (BATH), data = dataset)

lmod_22 <- lm(log10(PRICE)~log10(PROPERTYSQFT) + (BEDS), data = dataset)

lmod_33 <- lm(log10(PRICE)~(BEDS) + (BATH), data = dataset)

## print model output
summary(lmod_11)
summary(lmod_22)
summary(lmod_33)


# Function to plot log10 of significant variable vs log10(PRICE) and residuals
plot_model <- function(model, data, var_name, model_name) {
  
  # 1. Scatter plot of log10(PROPERTYSQFT) vs log10(PRICE) with regression line
  ggplot(data, aes_string(x = paste0("log10(", var_name, ")"), y = "log10(PRICE)")) +
    geom_point(alpha = 0.5, color = "blue") +  # Scatter plot points
    stat_smooth(method = "lm", col = "red", se = FALSE) +  # Best fit line
    labs(title = paste("Scatter plot of log10(", var_name, ") vs log10(PRICE) -", model_name),
         x = paste("log10", var_name), y = "log10(PRICE)") +
    theme_minimal() -> plot1
  
  # 2. Residuals vs Fitted plot
  residuals_data <- data.frame(Fitted = fitted(model), Residuals = resid(model))
  
  ggplot(residuals_data, aes(x = Fitted, y = Residuals)) +
    geom_point(alpha = 0.5, color = "darkgreen") +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    labs(title = paste("Residuals vs Fitted -", model_name),
         x = "Fitted Values", y = "Residuals") +
    theme_minimal() -> plot2
  
  # Print the plots
  print(plot1)
  print(plot2)
}

# Call function for each model (PROPERTYSQFT is the most significant variable)
plot_model(lmod_11, dataset, "PROPERTYSQFT", "lmod_11")
plot_model(lmod_22, dataset, "PROPERTYSQFT", "lmod_22")


# Repeating the above for BEDS as the sig.v 

# 1. Scatter plot of BEDS vs log10(PRICE) with best-fit regression line
ggplot(dataset, aes(x = BEDS, y = log10(PRICE))) +
  geom_point(alpha = 0.5, color = "blue") +  # Scatter plot points
  stat_smooth(method = "lm", col = "red", se = FALSE) +  # Best fit line
  labs(title = "Regression: BEDS vs log10(PRICE) - Model lmod33",
       x = "Number of Beds", y = "log10(PRICE)") +
  theme_minimal()

# 2. Residuals vs Fitted Values plot
residuals_data <- data.frame(Fitted = fitted(lmod_33), Residuals = resid(lmod_33))

ggplot(residuals_data, aes(x = Fitted, y = Residuals)) +
  geom_point(alpha = 0.5, color = "darkgreen") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted - Model lmod_33",
       x = "Fitted Values", y = "Residuals") +
  theme_minimal()
