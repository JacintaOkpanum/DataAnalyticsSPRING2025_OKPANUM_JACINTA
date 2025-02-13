# This README file contains the summary for each of the models developed

# model 1

Call:
lm(formula = log10(PRICE) ~ log10(PROPERTYSQFT) + (BEDS) + (BATH), 
    data = dataset)
Residuals:
     Min       1Q   Median       3Q      Max 
-0.99063 -0.18610 -0.03317  0.17488  0.97089 

Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)          2.535254   0.075273   33.68   <2e-16 ***
log10(PROPERTYSQFT)  1.081017   0.026741   40.43   <2e-16 ***
BEDS                -0.049919   0.003742  -13.34   <2e-16 ***
BATH                 0.068009   0.005707   11.92   <2e-16 ***
---

Residual standard error: 0.2715 on 3120 degrees of freedom
Multiple R-squared:  0.5888,	Adjusted R-squared:  0.5884 
F-statistic:  1489 on 3 and 3120 DF,  p-value: < 2.2e-16

# Model 2

Call:
lm(formula = log10(PRICE) ~ log10(PROPERTYSQFT) + (BEDS), data = dataset)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.14827 -0.19379 -0.03883  0.18404  0.88413 

Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)          2.124750   0.068423  31.053   <2e-16 ***
log10(PROPERTYSQFT)  1.240209   0.023682  52.369   <2e-16 ***
BEDS                -0.031000   0.003464  -8.949   <2e-16 ***
---

Residual standard error: 0.2775 on 3121 degrees of freedom
Multiple R-squared:  0.5701,	Adjusted R-squared:  0.5699 
F-statistic:  2070 on 2 and 3121 DF,  p-value: < 2.2e-16

# Model 3

Call:
lm(formula = log10(PRICE) ~ (BEDS) + (BATH), data = dataset)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.29091 -0.21116 -0.04134  0.17962  1.39373 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  5.5513224  0.0123299 450.232   <2e-16 ***
BEDS        -0.0002832  0.0043627  -0.065    0.948    
BATH         0.1832649  0.0061018  30.034   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3351 on 3121 degrees of freedom
Multiple R-squared:  0.3735,	Adjusted R-squared:  0.3731 
F-statistic: 930.2 on 2 and 3121 DF,  p-value: < 2.2e-16