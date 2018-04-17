clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Overview mit Stata Auswertungen\20150506_Overview_with_merged_scores.dta", clear
log using "$mypath\Figures\Figure 2\Figure2&3_paired_scores.log", replace


* Regressions for Figure 2 *

ttest score2==score1 if treatment_id==11, level(90)
ttest score2==score1 if treatment_id==12, level(90) 
ttest score2==score1 if treatment_id==13, level(90) 
ttest score2==score1 if treatment_id==14, level(90) 

ttest score2==score1 if treatment_id==21, level(90) 
ttest score2==score1 if treatment_id==22, level(90) 
ttest score2==score1 if treatment_id==23, level(90) 
ttest score2==score1 if treatment_id==24, level(90) 


* Regressions for Figure 3 *

ttest score3==score1 if treatment_id==11, level(90) 
ttest score3==score1 if treatment_id==12, level(90) 
ttest score3==score1 if treatment_id==13, level(90) 
ttest score3==score1 if treatment_id==14, level(90) 

ttest score3==score1 if treatment_id==21, level(90) 
ttest score3==score1 if treatment_id==22, level(90) 
ttest score3==score1 if treatment_id==23, level(90) 
ttest score3==score1 if treatment_id==24, level(90) 																


log close
set more on
exit, clear
