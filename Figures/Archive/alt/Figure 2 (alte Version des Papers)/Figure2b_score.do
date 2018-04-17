clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Overview mit Stata Auswertungen\20150506_Overview_with_merged_scores.dta", clear
log using "$mypath\Figures\Figure 2\Figure2b.log", replace




keep if (creative==1)
keep score1 score2 score3 treatment_id no
reshape long score, i(no) j(round)

egen mean_1 = mean(score) if (round==1 & treatment_id==21)
egen mean_2 = mean(score) if (round==2 & treatment_id==21)
egen mean_3 = mean(score) if (round==3 & treatment_id==21)
gen meanscore_1 = mean_1  
replace meanscore_1 = mean_2 if round==2
replace meanscore_1 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(score) if (round==1 & treatment_id==22)
egen mean_2 = mean(score) if (round==2 & treatment_id==22)
egen mean_3 = mean(score) if (round==3 & treatment_id==22)
gen meanscore_2 = mean_1  
replace meanscore_2 = mean_2 if round==2
replace meanscore_2 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(score) if (round==1 & treatment_id==23)
egen mean_2 = mean(score) if (round==2 & treatment_id==23)
egen mean_3 = mean(score) if (round==3 & treatment_id==23)
gen meanscore_3 = mean_1  
replace meanscore_3 = mean_2 if round==2
replace meanscore_3 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(score) if (round==1 & treatment_id==24)
egen mean_2 = mean(score) if (round==2 & treatment_id==24)
egen mean_3 = mean(score) if (round==3 & treatment_id==24)
gen meanscore_4 = mean_1  
replace meanscore_4 = mean_2 if round==2
replace meanscore_4 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3



label var meanscore_1 "Control Group" 
label var meanscore_2 "Gift" 
label var meanscore_3 "Tournament" 
label var meanscore_4 "Feedback" 
label var round "Round"
graph twoway connected meanscore_* round, sort connect(L) lpattern(dot solid) lcolor(gray red blue green) ytitle(Mean Performance)xlabel(#3) ylabel(15(5)32) mcolor(gray red blue green)
graph export "$mypath\Figures\Figure 2\Figure2b_score.ps", logo(off) replace


log close
set more on
exit, clear
