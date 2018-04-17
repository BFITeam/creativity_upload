clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Do-Files und Datasets\Overview_Aufbereitet.dta", clear
log using "$mypath\Figures\Figure 2\Figure2b.log", replace




keep if (creative==1)
keep effort1 effort2 effort3 treatment_id no
reshape long effort, i(no) j(round)

egen mean_1 = mean(effort) if (round==1 & treatment_id==21)
egen mean_2 = mean(effort) if (round==2 & treatment_id==21)
egen mean_3 = mean(effort) if (round==3 & treatment_id==21)
gen meaneffort_1 = mean_1  
replace meaneffort_1 = mean_2 if round==2
replace meaneffort_1 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(effort) if (round==1 & treatment_id==22)
egen mean_2 = mean(effort) if (round==2 & treatment_id==22)
egen mean_3 = mean(effort) if (round==3 & treatment_id==22)
gen meaneffort_2 = mean_1  
replace meaneffort_2 = mean_2 if round==2
replace meaneffort_2 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(effort) if (round==1 & treatment_id==23)
egen mean_2 = mean(effort) if (round==2 & treatment_id==23)
egen mean_3 = mean(effort) if (round==3 & treatment_id==23)
gen meaneffort_3 = mean_1  
replace meaneffort_3 = mean_2 if round==2
replace meaneffort_3 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(effort) if (round==1 & treatment_id==24)
egen mean_2 = mean(effort) if (round==2 & treatment_id==24)
egen mean_3 = mean(effort) if (round==3 & treatment_id==24)
gen meaneffort_4 = mean_1  
replace meaneffort_4 = mean_2 if round==2
replace meaneffort_4 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3



label var meaneffort_1 "Control Group" 
label var meaneffort_2 "Gift" 
label var meaneffort_3 "Tournament" 
label var meaneffort_4 "Feedback" 
label var round "Round"
graph twoway connected meaneffort_* round, sort connect(L) lpattern(dot solid) lcolor(gray red blue green) ytitle(Mean Performance)xlabel(#3) ylabel(15(5)32) mcolor(gray red blue green)
graph export "$mypath\Figures\Figure 2\Figure2b.ps", logo(off) replace


log close
set more on
exit, clear
