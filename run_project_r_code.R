rm(list=ls(all=TRUE))
#
#set path to the R_files folder
path <-"C:/Users/gtierney/Google Drive/final version April 2018/data/R_files"
setwd(path)

require(foreign)
require(reshape)
require(plyr)
require(sandwich)
require(lmtest)
require(car)
require(plm)
require(np)
require(quantreg)
require(lme4)
require(coin)
require(arm)

memory.limit(5000)

source("create_figures.r")
