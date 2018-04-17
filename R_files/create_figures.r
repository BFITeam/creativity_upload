
#
##########################################################################################################################################
################################################# Load Data ##############################################################################
########################################################################################################################################## 
### Load current dataset
neu<-read.table("../raw_data/r_data/Overview.txt",sep="\t",header=T)
#
source("clean_data.r")
#
options(digits = 3)

##########################################################################################################################################
################################################# Make Bar Chart #########################################################################
##########################################################################################################################################
source("Bar_chart.r")

##########################################################################################################################################
################################################# Make Propensity Score Chart ############################################################
##########################################################################################################################################

prop_slider_gift<-predict(glm(gift~effort1,data=subset(sl,treatment_id%in%c(11,12))),type = "response")
#
prop_slider_turnier<-predict(glm(turnier~effort1,data=subset(sl,treatment_id%in%c(11,13))),type = "response")
#

graph_matching_gift<-data.frame("gift"=subset(sl,treatment_id%in%c(11,12))[,c("gift")])
graph_matching_gift$prop_gift<-prop_slider_gift
graph_matching_turnier<-data.frame("turnier"=subset(sl,treatment_id%in%c(11,13))[,c("turnier")])
graph_matching_turnier$prop_turnier<-prop_slider_turnier
#
png("Results/FigureA2_Propensity_Score.png")
plot(NA,xlim=c(0,1),ylim=c(0,3.5),xlab="Propensity Score",ylab="Distribution")
abline(v=seq(0,1,.1),lwd=0.1,lty=4,col="lightgray")
abline(h=seq(0,3.5,.25),lwd=0.1,lty=4,col="lightgray")
lines(density(subset(graph_matching_turnier,turnier==0)$prop_turnier,bw=.05),lwd=3,col="black",lty=3)
lines(density(subset(graph_matching_turnier,turnier==1)$prop_turnier,bw=.05),lwd=3,col="black")
legend("right",c("Performance \nBonus \nTreatment","Control Group"),lwd=3,col=c("black","black"),lty=c(1,3))
dev.off()
tiff("Results/FigureA2_Propensity_Score.tif")
plot(NA,xlim=c(0,1),ylim=c(0,3.5),xlab="Propensity Score",ylab="Distribution")
abline(v=seq(0,1,.1),lwd=0.1,lty=4,col="lightgray")
abline(h=seq(0,3.5,.25),lwd=0.1,lty=4,col="lightgray")
lines(density(subset(graph_matching_turnier,turnier==0)$prop_turnier,bw=.05),lwd=3,col="black",lty=3)
lines(density(subset(graph_matching_turnier,turnier==1)$prop_turnier,bw=.05),lwd=3,col="black")
legend("right",c("Performance \nBonus \nTreatment","Control Group"),lwd=3,col=c("black","black"),lty=c(1,3))
dev.off()
##########################################################################################################################################
################################################# Make Non-Parametric Chart ##############################################################
##########################################################################################################################################
#
#for help see: https://cran.r-project.org/web/packages/np/vignettes/np.pdf
pooled$gift_slider <- pooled$gift*pooled$slider
pooled$turnier_slider <- pooled$turnier*pooled$slider
#rename variables for output
pooled$`Baseline_Performance` <- pooled$neffort1
pooled$`Period 2 Performance` <- pooled$neffort2
np <- npplreg(`Period 2 Performance`~gift+gift_slider+turnier+turnier_slider | `Baseline_Performance`,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
np
np_plot_data <- plot(np,plot.behavior = "data")
y <- fitted(np_plot_data$plr5)
x <- np_plot_data$plr5$evalz[,1]

png(paste0(path,"/Results/FigureA1_np_reg.png"))
plot(y ~ x, type = "n",xlab = "Period 1 Output",ylab = "Period 2 Output")
lines(y~x)
dev.off()
tiff(paste0(path,"/Results/FigureA1_np_reg.tif"))
plot(y ~ x, type = "n",xlab = "Period 1 Output",ylab = "Period 2 Output")
lines(y~x)
dev.off()
