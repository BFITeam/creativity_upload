cols <- c("neffort1","neffort2","gift","turnier","treatment_id","bonus_dec")
neu_neg <- rbind(sneu_neg[,cols],cneu_neg[,cols],
                 sl[sl$treatment_id == 11,cols],
                 cr[cr$treatment_id == 21,cols])

bar_chart_reg1<-lm(neffort2~neffort1+gift,data=subset(sl,treatment_id==11 | treatment_id==12))
bar_chart_reg2<-lm(neffort2~neffort1+gift,data=subset(neu_neg,treatment_id==11 | (treatment_id==12 & bonus_dec==0)))
bar_chart_reg3<-lm(neffort2~neffort1+turnier,data=subset(sl,treatment_id==11 | treatment_id==13))
bar_chart_reg4<-lm(neffort2~neffort1+turnier,data=subset(neu_neg,treatment_id==11 | (treatment_id==13 & bonus_dec==0)))
bar_chart_reg5<-lm(neffort2~neffort1+gift,data=subset(cr,treatment_id==21 | treatment_id==22))
bar_chart_reg6<-lm(neffort2~neffort1+gift,data=subset(neu_neg,treatment_id==21 | (treatment_id==22 & bonus_dec==0)))
bar_chart_reg7<-lm(neffort2~neffort1+turnier,data=subset(cr,treatment_id==21 | treatment_id==23))
bar_chart_reg8<-lm(neffort2~neffort1+turnier,data=subset(neu_neg,treatment_id==21 | (treatment_id==23 & bonus_dec==0)))
#

bar_chart_coef<-data.frame("Coef"=c(
  "gift_slider_pos"=coeftest(bar_chart_reg1, vcov=vcovHC(bar_chart_reg1,type="HC1"))["gift",1],
  "gift_slider_neg"=coeftest(bar_chart_reg2, vcov=vcovHC(bar_chart_reg2,type="HC1"))["gift",1],
  "turnier_slider_pos"=coeftest(bar_chart_reg3, vcov=vcovHC(bar_chart_reg3,type="HC1"))["turnier",1],
  "turnier_slider_neg"=coeftest(bar_chart_reg4, vcov=vcovHC(bar_chart_reg4,type="HC1"))["turnier",1],
  "gift_creative_pos"=coeftest(bar_chart_reg5, vcov=vcovHC(bar_chart_reg5,type="HC1"))["gift",1],
  "gift_creative_neg"=coeftest(bar_chart_reg6, vcov=vcovHC(bar_chart_reg6,type="HC1"))["gift",1],
  "turnier_creative_pos"=coeftest(bar_chart_reg7, vcov=vcovHC(bar_chart_reg7,type="HC1"))["turnier",1],
  "turnier_creative_neg"=coeftest(bar_chart_reg8, vcov=vcovHC(bar_chart_reg8,type="HC1"))["turnier",1]
))
bar_chart_coef$p<-c(
  coeftest(bar_chart_reg1, vcov=vcovHC(bar_chart_reg1,type="HC1"))["gift",4],
  coeftest(bar_chart_reg2, vcov=vcovHC(bar_chart_reg2,type="HC1"))["gift",4],
  coeftest(bar_chart_reg3, vcov=vcovHC(bar_chart_reg3,type="HC1"))["turnier",4],
  coeftest(bar_chart_reg4, vcov=vcovHC(bar_chart_reg4,type="HC1"))["turnier",4],
  coeftest(bar_chart_reg5, vcov=vcovHC(bar_chart_reg5,type="HC1"))["gift",4],
  coeftest(bar_chart_reg6, vcov=vcovHC(bar_chart_reg6,type="HC1"))["gift",4],
  coeftest(bar_chart_reg7, vcov=vcovHC(bar_chart_reg7,type="HC1"))["turnier",4],
  coeftest(bar_chart_reg8, vcov=vcovHC(bar_chart_reg8,type="HC1"))["turnier",4]
)
bar_chart_coef$S<-""
bar_chart_coef$S[which(bar_chart_coef$p<0.1)]<-"*"
bar_chart_coef$S[which(bar_chart_coef$p<0.05)]<-"**"
bar_chart_coef$S[which(bar_chart_coef$p<0.01)]<-"***"
#



png(paste0(path,"/Results/Figure6_Neg_Bonus_Dec.png"))
bplot_bonus_neg2<-barplot(as.numeric(bar_chart_coef[,1]),col=c("black","white")[rep(1:2,4)],ylim=c(-1,1.2),yaxt="n",density=c(NA,70),space=c(0.3,0.3,0.3,0.3,1.2,0.3,0.3,0.3))
segments(x0=mean(bplot_bonus_neg2[c(4,5)]),x1=mean(bplot_bonus_neg2[c(4,5)]),y0=-.6,y1=1)
segments(x0=mean(bplot_bonus_neg2[c(2,3)]),x1=mean(bplot_bonus_neg2[c(2,3)]),y0=-.55,y1=.55,lty=2)
segments(x0=mean(bplot_bonus_neg2[c(6,7)]),x1=mean(bplot_bonus_neg2[c(6,7)]),y0=-.55,y1=.55,lty=2)
text(bplot_bonus_neg2,as.numeric(bar_chart_coef[,1]),paste(" ",format(round(as.numeric(bar_chart_coef[,1]),2), nsmall = 2),bar_chart_coef$S,sep=""),pos=c(3,1,3,3,3,1,3,1),cex=1.15)
text(c(mean(bplot_bonus_neg2[c(1:4),]),mean(bplot_bonus_neg2[c(5:8),])),c(1.1,1.1),c("Simple task","Creative task"),cex=1.3,font=2)
text(c(mean(bplot_bonus_neg2[c(1:2),]),mean(bplot_bonus_neg2[c(3:4),])+0.1,mean(bplot_bonus_neg2[c(5:6),]),mean(bplot_bonus_neg2[c(7:8),]))+0.1,c(.95,.95,.95,.95),c("Gift","Performance \n Bonus","Gift","Performance \n Bonus"),font=3)
legend("bottomright",c("Reward implemented","Reward not implemented"),fill=c("black","white"),density=c(NA,70),cex=1.3)
#mtext("Stat. significance compared to control group: * p < 0.1, ** p < 0.05, *** p < 0.01",outer=T,SOUTH<-1,line=-4)
dev.off()

tiff(paste0(path,"/Results/Figure6_Neg_Bonus_Dec.tif"))
bplot_bonus_neg2<-barplot(as.numeric(bar_chart_coef[,1]),col=c("black","white")[rep(1:2,4)],ylim=c(-1,1.2),yaxt="n",density=c(NA,70),space=c(0.3,0.3,0.3,0.3,1.2,0.3,0.3,0.3))
segments(x0=mean(bplot_bonus_neg2[c(4,5)]),x1=mean(bplot_bonus_neg2[c(4,5)]),y0=-.6,y1=1)
segments(x0=mean(bplot_bonus_neg2[c(2,3)]),x1=mean(bplot_bonus_neg2[c(2,3)]),y0=-.55,y1=.55,lty=2)
segments(x0=mean(bplot_bonus_neg2[c(6,7)]),x1=mean(bplot_bonus_neg2[c(6,7)]),y0=-.55,y1=.55,lty=2)
text(bplot_bonus_neg2,as.numeric(bar_chart_coef[,1]),paste(" ",format(round(as.numeric(bar_chart_coef[,1]),2), nsmall = 2),bar_chart_coef$S,sep=""),pos=c(3,1,3,3,3,1,3,1),cex=1.15)
text(c(mean(bplot_bonus_neg2[c(1:4),]),mean(bplot_bonus_neg2[c(5:8),])),c(1.1,1.1),c("Simple task","Creative task"),cex=1.3,font=2)
text(c(mean(bplot_bonus_neg2[c(1:2),]),mean(bplot_bonus_neg2[c(3:4),])+0.1,mean(bplot_bonus_neg2[c(5:6),]),mean(bplot_bonus_neg2[c(7:8),]))+0.1,c(.95,.95,.95,.95),c("Gift","Performance \n Bonus","Gift","Performance \n Bonus"),font=3)
legend("bottomright",c("Reward implemented","Reward not implemented"),fill=c("black","white"),density=c(NA,70),cex=1.3)
#mtext("Stat. significance compared to control group: * p < 0.1, ** p < 0.05, *** p < 0.01",outer=T,SOUTH<-1,line=-4)
dev.off()

#all_bonus_dec <- rbind(neu_neg,subset(sl,treatment_id != 11))
all_bonus_dec <- rbind(sneu_neg[,cols],cneu_neg[,cols],
                 sl[,cols],
                 cr[,cols])

ols_rewards_effort <- lm(bonus_dec ~ neffort1, data = all_bonus_dec)
summary(ols_rewards_effort)

logit_rewards_effort <- glm(formula = bonus_dec ~ neffort1, data = all_bonus_dec,family = binomial(link = "logit"))
summary(logit_rewards_effort)

