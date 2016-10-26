test$camp_duration=lubridate::ymd(test$Camp_End_Date)-lubridate::ymd(test$Camp_Start_Date)
test$registration_end=lubridate::ymd(test$Registration_Date)-lubridate::ymd(test$Camp_End_Date)
table(check)
test$time_interval=lubridate::ymd(test$First_Interaction)-lubridate::ymd(test$Registration_Date)
table(x)
test$registration_start=lubridate::ymd(test$Registration_Date)-lubridate::ymd(test$Camp_Start_Date)

test$interact_start=lubridate::ymd(test$First_Interaction)-lubridate::ymd(test$Camp_Start_Date)

test$Camp_Start_Date=NULL
test$Registration_Date=NULL
test$Camp_End_Date=NULL
test$First_Interaction=NULL

test$Online_Follower=as.factor(test$Online_Follower)
test$LinkedIn_Shared=as.factor(test$LinkedIn_Shared)
test$Twitter_Shared=as.factor(test$Twitter_Shared)
test$Facebook_Shared=as.factor(test$Facebook_Shared)
test$Target=as.factor(test$Target)
test$Var3=as.factor(test$Var3)

table(test$Income)

#test$Income[test$Income=="None"]=NA
#test$Income=as.factor(test$Income)
# test$Age=as.character(test$Age)
# 
# test$Age[test$Age=="None"]=NA
# test$Age=as.numeric(test$Age)
# test$Age[is.na(test$Age)]=mean(test$Age,na.rm=T)
# 
# levels(test$City_Type)[levels(test$City_Type=="")]="others"
# levels(test$Employer_Category)[levels(test$Employer_Category)==""]="others"
test$Education_Score=NULL
test$City_Type=NULL
test$Employer_Category=NULL
test$Age=NULL
test$Income=NULL
test$Category3=NULL
test$camp_duration=as.numeric(test$camp_duration)
test$registration_end=as.numeric(test$registration_end)
test$time_interval=as.numeric(test$time_interval)
test$interact_start=as.numeric(test$interact_start)
test$registration_start=as.numeric(test$registration_start)
test$registration_end[is.na(test$registration_end)]=mean(test$registration_end,na.rm=T)
test$registration_start[is.na(test$registration_start)]=mean(test$registration_start,na.rm=T)
test$time_interval[is.na(test$time_interval)]=mean(test$time_interval,na.rm=T)
test$Category1=as.factor(test$Category1)
test$Category2=as.factor(test$Category2)

test$Health_Camp_ID=NULL
test$Patient_ID=NULL
Y=test$Target
test$Target=NULL