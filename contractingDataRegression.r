library(plyr)
library(stringr)
library(MASS)
library(lubridate)

raw<-read.csv("~/Documents/Work/datathon/fss.csv")
raw$date<-dmy(raw$signeddate)
raw$month<-month(raw$date)
raw$year<-year(raw$date)
raw$qtr<-ifelse((raw$month==10 | raw$month==11 | raw$month==12), 1, ifelse(
  (raw$month==1 | raw$month==2 | raw$month==3), 2, ifelse(
    (raw$month==4 | raw$month==5 | raw$month==6), 3, 4)))
raw$agency<-as.factor(substr(raw$maj_agency_cat, 1, 4))
fss<-raw[raw$fss!="NULL",]
fss$fss<-as.numeric(fss$fss)
fss$fssdummy1<-ifelse(fss$fss==1, 1, 0)
fss$fssdummy2<-ifelse(fss$fss==2, 1, 0)
fss$lowdummy<-ifelse((fss$fss==1 | fss$fss==2), 1, 0)

lowfssFit<-lm(lowdummy~as.factor(month), data=fss)
write.csv(fss, file="~/Documents/Work/datathon/fss_cleaned.csv")
