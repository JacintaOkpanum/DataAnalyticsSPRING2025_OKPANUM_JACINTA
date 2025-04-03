#   Model 1: SVM Linear Kernel

> cm
      Predicted
Actual  1  2  3
     1 41  1  0
     2  0 50  0
     3  0  1 30
     
     
#   Model 2: SVM Radial Kernel (best model)

 cm
      Predicted
Actual  1  2  3
     1 42  0  0
     2  0 50  0
     3  0  1 30
     
> data.frame(precision, recall, f1)

  precision    recall        f1
1 1.0000000 1.0000000 1.0000000
2 0.9803922 1.0000000 0.9900990
3 1.0000000 0.9677419 0.9836066


#     Model 3: kNN model 
cm
      Predicted
Actual  1  2  3
     1 41  1  0
     2  0 50  0
     3  0  1 30
     
 > data.frame(precision, recall, f1)
 
  precision    recall        f1
1 1.0000000 0.9761905 0.9879518
2 0.9615385 1.0000000 0.9803922
3 1.0000000 0.9677419 0.9836066

