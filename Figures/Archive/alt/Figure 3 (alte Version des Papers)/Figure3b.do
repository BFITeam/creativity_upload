clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Do-Files und Datasets\Overview_Aufbereitet.dta", clear
log using "$mypath\Figures\Figure 3\Figure3b.log", replace




keep if (creative_trans==1)
keep transfer1 transfer2 transfer3 treatment_id no
reshape long transfer, i(no) j(round)
egen mean_1 = mean(transfer) if (round==1 & treatment_id==41)
egen mean_2 = mean(transfer) if (round==2 & treatment_id==41)
egen mean_3 = mean(transfer) if (round==3 & treatment_id==41)
gen meaneffort_1 = mean_1  
replace meaneffort_1 = mean_2 if round==2
replace meaneffort_1 = mean_3 if round==3
drop mean_1
drop mean_2
drop mean_3

egen mean_1 = mean(transfer) if (round==1 & treatment_id==42)
egen mean_2 = mean(transfer) if (round==2 & treatment_id==42)
egen mean_3 = mean(transfer) if (round==3 & treatment_id==42)
gen meaneffort_2 = mean_1  
replace meaneffort_2 = mean_2 if round==2
replace meaneffort_2 = mean_3 if round==3

label var meaneffort_1 "Controle Group" 
label var meaneffort_2 "Gift" 
label var round "Round"
graph twoway connected meaneffort_* round, sort connect(L)lpattern(dot solid) lcolor(gray red) ytitle(Mean Transfer)xlabel(#3) ylabel(15(5)32) mcolor(gray red)
graph export "$mypath\Figures\Figure 3\Figure3b.ps", logo(off) replace



log close
set more on
exit, clear
