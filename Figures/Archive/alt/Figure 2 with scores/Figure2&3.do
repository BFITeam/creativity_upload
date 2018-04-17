clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Do-Files und Datasets\Overview_Aufbereitet.dta", clear
log using "$mypath\Figures\Figure 2\Figure2&3.log", replace


* Regressions for Figure 2 *

ttest effort2==effort1 if treatment_id==11, level(90) unp
ttest effort2==effort1 if treatment_id==12, level(90) unp
ttest effort2==effort1 if treatment_id==13, level(90) unp
ttest effort2==effort1 if treatment_id==14, level(90) unp

ttest effort2==effort1 if treatment_id==21, level(90) unp
ttest effort2==effort1 if treatment_id==22, level(90) unp
ttest effort2==effort1 if treatment_id==23, level(90) unp
ttest effort2==effort1 if treatment_id==24, level(90) unp


* Regressions for Figure 3 *

ttest effort3==effort1 if treatment_id==11, level(90) unp
ttest effort3==effort1 if treatment_id==12, level(90) unp
ttest effort3==effort1 if treatment_id==13, level(90) unp
ttest effort3==effort1 if treatment_id==14, level(90) unp

ttest effort3==effort1 if treatment_id==21, level(90) unp
ttest effort3==effort1 if treatment_id==22, level(90) unp
ttest effort3==effort1 if treatment_id==23, level(90) unp
ttest effort3==effort1 if treatment_id==24, level(90) unp																


log close
set more on
exit, clear
