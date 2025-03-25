Model 1 :

> contingency.table
         actual
predicted  1  2  3
        1 17  0  0
        2  0 18  0
        3  0  1 18
        
Model 2: 

> contingency.table
         actual
predicted  1  2  3
        1 17  0  0
        2  0 18  0
        3  0  1 18
        
  Precision/ Recall/ F1 score metrics:
  
  > print(metrics_df)
  
  Class Precision    Recall F1_Score
1     1 1.0000000 1.0000000 1.000000
2     2 1.0000000 0.9473684 0.972973
3     3 0.9473684 1.0000000 0.972973
  
  