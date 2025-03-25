Exercise 1: kNN - Classification model

The best performing model is the second model that involves the weight features 
with 68% accuracy

contingency.table
         actual
predicted young adult old
    young   320    99  13
    adult    91   430 165
    old       1    31 103
> # calculate classification accuracy
> sum(diag(contingency.table))/length(dataset.test$age.group)
[1] 0.6807662

The optimal value of K = 65


Exercise 2: Kmeans classification 

The optimal value of k = 3