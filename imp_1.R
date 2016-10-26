##############3
X_train<- fread("trainf.csv")
X_test<- fread("testf.csv")
#################3
X_All<- plyr::rbind.fill(X_train,X_test)
X_All$Health_Camp_ID<- NULL
X_All$Patient_ID<- NULL
#########################
X_All$combine<- ifelse(X_All$Income=="None" & X_All$Education_Score=="None" & X_All$Age=="None",0,1)
X_All$Income<- NULL
X_All$Age<- NULL
X_All$Education_Score<- NULL
############################
X_All$combine_2<- ifelse(X_All$City_Type=="" & X_All$Employer_Category=="",0,1)
X_All$City_Type<- NULL
X_All$Employer_Category<- NULL
#################################################################
V<- c(6,7,8,12)
for(i in V){
  X_All[,i]<- lubridate::ymd(X_All[,i])
  
}
str(X_All)
X_All$first_1<- with(X_All,(X_All$Registration_Date-X_All$First_Interaction)/365)
X_All$first_2<- with(X_All,(X_All$Camp_End_Date-X_All$Camp_Start_Date)/365)
X_All$Registration_Date<- NULL
X_All$First_Interaction<- NULL
X_All$Camp_End_Date<- NULL
X_All$Camp_Start_Date<- NULL
###############################dummies
names(X_All)
X_All<- dummies::dummy.data.frame(X_All,names=c('Category1','Category2','Category3'),sep="_")
X_All[is.na(X_All)]<- -1
############
for(i in 2:21){
  X_All[,i]<- log(X_All[,i]+2)
}
boxplot(X_All$first_1)
X_All$first_2[X_All$first_1>2.1]<- mean(X_All$first_1)
str(X_All)
X_All$first_1<- as.numeric(X_All$first_1)
X_All$first_2<- as.numeric(X_All$first_2)
#####################glm
X_tr<- X_All[1:nrow(X_train),]
X_te<- X_All[-(1:nrow(X_train)),]
###############33
l<- glm(Target~.,data = X_tr,family = "binomial")
pre<- predict(l,X_tr , type = "response")
pre_1<- predict(l,X_te,type = "response")
table(pre)
library(Metrics)
auc(X_tr$Target,pre)
####################
X_tr$pre<- pre
X_te$pre<- pre_1
####################xgboost
X<- names(X_tr)[-1]
X
library(xgboost)
model_xgb_cv <- xgb.cv(data=data.matrix(X_tr[,X]), label=data.matrix(X_tr$Target), objective="reg:linear", nfold=5, nrounds=130, eta=0.06, max_depth=6, subsample=0.950, colsample_bytree=0.98, min_child_weight=1, eval_metric="logloss")
model_xgb <- xgboost(data=data.matrix(X_tr[,X]), label=data.matrix(X_tr$Target), objective="binary:logistic", nrounds=250, eta=0.01, booster="gbtree",  max_depth=4, subsample=0.85, colsample_bytree=0.88, min_child_weight=5, eval_metric="auc")
X_tr$pre_3<- predict(model_xgb,data.matrix(X_tr[,X]))
X_te$pre_3<- predict(model_xgb , data.matrix(X_te[,X]))
pre_1<- predict(model_xgb,data.matrix(X_te[,X]))
submission <- data.table(Patient_ID = X_test$Patient_ID, Health_Camp_ID = X_test$Health_Camp_ID, Outcome = pre_1)

write.csv(submission,"R_Benchmark_4_5.csv",row.names = F) #Public Score - 0.78
##################gbm
X_tr$Target<- as.numeric(as.character(X_tr$Target))
write.csv(X_tr,'trh20.csv',row.names = F)
write.csv(X_te,'teh2o.csv',row.names = F)
