setwd("C:/Users/user/Desktop/train")

train=read.csv("trainf.csv",stringsAsFactors = F)
test=read.csv("testf.csv")
test_1=read.csv("testf.csv")
summary(train)
library(lubridate)

train$camp_duration=lubridate::ymd(train$Camp_End_Date)-lubridate::ymd(train$Camp_Start_Date)
train$registration_end=lubridate::ymd(train$Camp_End_Date)-lubridate::ymd(train$Registration_Date)
table(check)
train$time_interval=lubridate::ymd(train$First_Interaction)-lubridate::ymd(train$Registration_Date)
table(x)

train$interact_start=lubridate::ymd(train$First_Interaction)-lubridate::ymd(train$Camp_Start_Date)

train$Camp_Start_Date=NULL
train$Registration_Date=NULL
train$Camp_End_Date=NULL
train$First_Interaction=NULL

train$Online_Follower=as.factor(train$Online_Follower)
train$LinkedIn_Shared=as.factor(train$LinkedIn_Shared)
train$Twitter_Shared=as.factor(train$Twitter_Shared)
train$Facebook_Shared=as.factor(train$Facebook_Shared)
train$Target=as.factor(train$Target)
train$Var3=as.factor(train$Var3)

table(train$Income)

train$Income[train$Income=="None"]=NA
train$Income=as.factor(train$Income)



train$Education_Score=NULL
train$City_Type=NULL
train$Employer_Category=NULL
train$Age=NULL
train$Income=NULL
train$Category3=NULL
train$camp_duration=as.numeric(train$camp_duration)
train$registration_end=as.numeric(train$registration_end)
train$time_interval=as.numeric(train$time_interval)
train$interact_start=as.numeric(train$interact_start)
train$registration_end[is.na(train$registration_end)]=mean(train$registration_end,na.rm=T)
train$time_interval[is.na(train$time_interval)]=mean(train$time_interval,na.rm=T)
train$Category1=as.factor(train$Category1)
train$Category2=as.factor(train$Category2)
train$Category3=as.factor(train$Category3)

train$Health_Camp_ID=NULL
train$Patient_ID=NULL
Y=train$Target
train$Target=NULL

library(xgboost)
model=xgb.cv(data=data.matrix(train),label=data.matrix(Y),booster="gbtree",objective="binary:logistic",nfold=5,nrounds=350,eta=0.01,max_depth=4, subsample=0.88, colsample_bytree=0.85, min_child_weight=5, eval_metric="auc")
summary(train)
model1=xgboost(data=data.matrix(train),label=data.matrix(Y),booster="gbtree",objective="binary:logistic",nrounds=350,eta=0.01,max_depth=4, subsample=0.88, colsample_bytree=0.85, min_child_weight=5, eval_metric="auc")
pred=predict(model1,data.matrix(test))
abc=xgb.importance(names(train),model=model1)
xgb.plot.importance(abc)

sub=data.frame("Patient_ID"=test_1$Patient_ID,"Health_Camp_ID"=test_1$Health_Camp_ID,"Outcome"=pred)
write.csv(sub,"sub.csv",row.names = F)
