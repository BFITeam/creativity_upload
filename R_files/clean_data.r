##########################################################################################################################################
clx <- 
function(fm, dfcw, cluster){
         M <- length(unique(cluster))   
         N <- length(cluster)           
         K <- fm$rank                        
         dfc <- (M/(M-1))*((N-1)/(N-K))  
         uj  <- apply(estfun(fm),2, function(x) tapply(x, cluster, sum));
         vcovCL <- dfc*sandwich(fm, meat=crossprod(uj)/N)*dfcw
         coeftest(fm, vcovCL) }
#
robust.se <- function(model, cluster){
 require(sandwich)
 require(lmtest)
 M <- length(unique(cluster))
 N <- length(cluster)
 K <- model$rank
 dfc <- (M/(M - 1)) * ((N - 1)/(N - K))
 uj <- apply(estfun(model), 2, function(x) tapply(x, cluster, sum));
 rcse.cov <- dfc * sandwich(model, meat = crossprod(uj)/N)
 rcse.se <- coeftest(model, rcse.cov)
 return(list(rcse.cov, rcse.se))
}
#
ztest<-function(mx,sdx,my,sdy){
	cat("p-value: ",dnorm((mx-my)/sqrt(sdx^2+sdy^2)),"\n\n")
}
##########################################################################################################################################
################################################# Data ###################################################################################
########################################################################################################################################## 
#
options(digits = 12)
###
if(any(grepl("fdb_old",names(neu)))){
	neu[,"feedback_old"]<-neu[,"fdb_old"]
	neu[,"fdb_old"]<-NULL
}
colnames(neu)<-tolower(colnames(neu))
neu$No<-neu$no
#
#
#
neu$start<-as.numeric(substr(neu$uhrzeit,1,2))
neu$date2<-as.Date(as.character(neu$date),format="%y%m%d")
neu$weekday<-weekdays(neu$date2)
#
#table(neu$group,neu$session)
#
#
table(table(neu$group,neu$session))
groups_per_session<-tapply(neu$group,neu$session,function(x){length(unique(x))})
neu$group_id<-NA
tmp<-0
for(i in 1:dim(neu)[1]){
	if(neu$session[i]==1){neu$group_id[i]<-neu$group[i]}
	if(neu$session[i]>1){
		if(neu$session[i]!=neu$session[i-1]){tmp<-tmp+groups_per_session[neu$session[i-1]]}
		neu$group_id[i]<-neu$group[i]+tmp
		}
}
table(neu$group_id,neu$session)
rm(tmp)
##########################################################################################################################################
################################################# Check Issues ###########################################################################
##########################################################################################################################################
neu<-neu[which(is.na(neu$no_problem) & is.na(neu$session_problem)),]
neu<-neu[which(neu$session!=108),]
neu$gift<-0
neu$gift[which(neu$treatment_id==12 | neu$treatment_id==22)]<-1
neu$control<-0
neu$control[which(neu$treatment_id==11 | neu$treatment_id==21)]<-1
neu$control_trans<-0
neu$control_trans[which(neu$treatment_id==41)]<-1
neu$gift_trans<-0
neu$gift_trans[which(neu$treatment_id==42)]<-1
neu$gift_fair<-0
neu$gift_fair[which(neu$treatment_id==52)]<-1
#
neu$expert1<-apply(neu[,c("p_subj_6_1","p_subj_8_1","p_subj_9_1","p_subj_10_1","p_subj_11_1")],1,mean,na.rm=T)
neu$expert2<-apply(neu[,c("p_subj_6_2","p_subj_8_2","p_subj_9_2","p_subj_10_2","p_subj_11_2")],1,mean,na.rm=T)
#
neu<-neu[,!(grepl("p_subj_|spillover|grund|ge_transfer|self_det_|evaluator|nonspec|gewoehnlich|intmot|pressure",colnames(neu)))]
neu<-neu[,!(colnames(neu)%in%c("ztreeid","uhrzeit","sudoku"))]
##########################################################################################################################################
################################################# Define Subsets #########################################################################
##########################################################################################################################################
### Subset containing creative tasks
cneu<-subset(neu,bonus_dec==1 & proposer==0 & creative==1) 
### Subset containing slider tasks 
sneu<-subset(neu,bonus_dec==1 & proposer==0 & slider==1)
### Subset containing proposer
sneu_proposer<-subset(neu,bonus_dec==1 & proposer==1 & slider==1)
cneu_proposer<-subset(neu,bonus_dec==1 & proposer==1 & slider==0)
#
sneu_proposer2<-subset(neu,proposer==1 & slider==1)
cneu_proposer2<-subset(neu,proposer==1 & creative==1)
proposer<-subset(neu,proposer==1)
### Subset containing neg. bonus dec. 
sneu_neg<-subset(neu,bonus_dec==0 & proposer==0 & slider==1)
cneu_neg<-subset(neu,bonus_dec==0 & proposer==0 & slider==0)
#
eke<-subset(neu,bonus_dec==1 & proposer==0 & eke==1)
kek<-subset(neu,bonus_dec==1 & proposer==0 & kek==1)
### Subset containing creative tasks
cr<-subset(neu,bonus_dec==1 & proposer==0 & (creative==1 | creative_trans==1)) 
### Subset containing slider tasks
sl<-subset(neu,bonus_dec==1 & proposer==0 & (slider==1 | slider_fair==1)) 
###
sl<-subset(sl,treatment_id!=52)

source("define_variables.r")
