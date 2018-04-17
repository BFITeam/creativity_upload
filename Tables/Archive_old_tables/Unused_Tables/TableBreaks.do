clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4
log using "$mypath\Tables\Logs\TableBreaks.log", replace
gen pausen1_1_3 = 1 <= pausen1 & pausen1 <= 3
gen pausen1_4_7 = 4 <= pausen1 & pausen1 <= 7
gen pausen1_8_up = 8 <= pausen1 

gen dif_breaks = pausen2 - pausen1

gen dif_breaks_1_3 = dif_breaks*pausen1_1_3
gen dif_breaks_4_7 = dif_breaks*pausen1_4_7
gen dif_breaks_8_up = dif_breaks*pausen1_8_up

reg ztransfer2 gift turnier pausen1_* dif_breaks dif_breaks_* ztransfer1 if slider == 1 , robust

reg ztransfer2 gift turnier pausen1_* dif_breaks dif_breaks_* ztransfer1 if creative == 1 , robust



gen time1 = 180-pausen1*20
gen time2 = 180-pausen2*20

gen effort_rate1 = effort1/time1
gen effort_rate2 = effort2/time2

//but-for production period 2 at period 2 rate for period 1 time
gen effort_rate2_time1 = effort_rate2*time1

//but-for production period 2 at period 1 rate for period 2 time
gen effort_rate1_time2 = effort_rate1*time2

/*
sum effort_time2_nobreaks if treatment_id == 11
gen 	zeffort_time2_nobreaks = (effort_time2_nobreaks - r(mean))/r(sd) if slider == 1
sum effort_time2_nobreaks if treatment_id == 21
replace zeffort_time2_nobreaks = (effort_time2_nobreaks - r(mean))/r(sd) if creative == 1
*/


foreach i in 1 2{
	sum effort_rate`i' if treatment_id == 11
	gen zeffort_rate`i' = (effort_rate`i' - r(mean))/r(sd) if slider == 1

	sum effort_rate`i' if treatment_id == 21
	replace zeffort_rate`i' = (effort_rate`i' - r(mean))/r(sd) if creative == 1
}


local controls $controls

//normal regs
label variable turnier "Tournament"
label variable gift "Gift"

eststo clear
eststo: reg zeffort2 turnier gift zeffort1 `controls' if slider == 1, robust
eststo: reg zeffort2 turnier gift zeffort1 `controls' if creative == 1, robust

//breaks period 2 on breaks period 1
eststo: reg pausen2 turnier gift pausen1 `controls' if slider == 1, robust
predict predicted_breaks_sl if e(sample) == 1
eststo: reg pausen2 turnier gift pausen1 `controls' if creative == 1, robust
predict predicted_breaks_cr if e(sample) == 1

/*
gen predicted_breaks = .
replace predicted_breaks = predicted_breaks_sl if slider == 1
replace predicted_breaks = predicted_breaks_cr if creative == 1

tabstat predicted_breaks if slider == 1 & gift == 0, by(turnier) stat(mean)
*/
//working-time productivity in period 2 on working-time productivity in period 1
eststo: reg zeffort_rate2 turnier gift zeffort_rate1 `controls' if slider == 1, robust
eststo: reg zeffort_rate2 turnier gift zeffort_rate1 `controls' if creative == 1, robust

//raw period 2
eststo: reg effort2 turnier gift effort1 `controls' if slider == 1, robust
eststo: reg effort2 turnier gift effort1 `controls' if creative == 1, robust

//period 2 rate with period 1 time
eststo: reg effort_rate2_time1 turnier gift effort1 `controls' if slider == 1, robust 
eststo: reg effort_rate2_time1 turnier gift effort1 `controls' if creative == 1, robust 

//period 2 time with period 1 rate
eststo: reg effort_rate1_time2 turnier gift effort1 `controls' if slider == 1, robust 
eststo: reg effort_rate1_time2 turnier gift effort1 `controls' if creative == 1, robust 

local tab_cols l
local slid_creat_headers 
local controls_row Controls 

local num_regs 12
forvalues i = 1/`num_regs'{
	local tab_cols `tab_cols'c
	local controls_row `controls_row' & YES
	
	if(mod(`i',2) == 1){
		local slid_creat_headers `slid_creat_headers' & Slider 
	}
	else if(mod(`i',2) == 0){
		local slid_creat_headers `slid_creat_headers' & Creative
	}
}



#delimit; // #delimit: command resets the character that marks the end of a command, here ;
esttab using "$mypath\Tables\Output\Referees\TableBreaksProductivityRate.tex", 
	label	   // label (make use of variable labels)
	nomtitles
	rename(zeffort1 "Period1" pausen1 "Period1" zeffort_rate1 "Period1" effort1 "Period1")
	varlabels("Period1" "Period 1 Output" _cons Constant)
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
	drop(`controls')
	nonumbers
	fragment
	replace
	prehead("\begin{landscape}"
	"\begin{table}[h]%" 
	"\setlength\tabcolsep{2pt}"
	"\caption{Performance Accounting for Breaks}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{`tab_cols'}" 
	"\hline\hline\noalign{\smallskip}"
	" \multicolumn{1}{c}{} & \multicolumn{2}{c}{Std. Period 2} & \multicolumn{2}{c}{Number of Breaks} & \multicolumn{2}{c}{Std. Period 2} & \multicolumn{2}{c}{Raw Period 2} & \multicolumn{2}{c}{Raw Period 2 Rate} & \multicolumn{2}{c}{Raw Period 1 Rate}\\"
	" & \multicolumn{2}{c}{Performance} & & & \multicolumn{2}{c}{Performance Rate} & \multicolumn{2}{c}{Performance} & \multicolumn{2}{c}{for Period 1 time} & \multicolumn{2}{c}{for Period 2 time} \\"
	"\hline"
	" `slid_creat_headers' \\"
	" & I & II & III & IV & V & VI & VII & VIII & IX & X & XI & XII \\")
	prefoot("\hline"
	" `controls_row' \\"
	"\hline" ) 
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{1.2\textwidth}"
	"\footnotesize {\it Note:} This table reports OLS estimates of treatment effects on the use of the time-out button. " 
	"The dependent variable in colulmns I and II is the standardized performance in Period 2 and refers to the number of sliders moved in the slider task and the creativity score in the creative task. "
	"The dependent variable in columns III and IV is the number of breaks taken in Period 2." 
	"The dependent variable in columns V and VI is the standardized performance rate in Period 2, calculated as raw performance in Period 2, divided by time not spent on break, and standardized to give the control group a mean of zero and standard deviation of one. "
	"Period 1 Output is standardized performance in Period 1 in columns I and II, number of breaks taken in Period 1 in columns III and IV, and standardized performance rate in Period 1. " 
	"The coefficient on the \textit{Tournament} (\textit{Gift}) treatment represents the impact of the \textit{Tournament} (\textit{Gift}) on the dependent variable. \\"
	"The estimation includes all agents from the Control Group as well as agents from treatment groups where the principal decided to institute the tournament/gift. "
	"Agents with negative reward decisions are not part of this analysis. "
	"Significance levels are denoted as follows: * \$p < 0.1$, ** \$p < 0.05$, *** \$p < 0.01$. "
	"\end{minipage}"
	"\end{center}"
	"\end{table}"
	"\end{landscape}");
#delimit cr

di (180-(180-1.8*20))/180
di (.679-.450)/.679

tabstat time1 , stat(mean) by(treatment_id2)
tabstat time2 , stat(mean) by(treatment_id2)

di ((132.2-111) - (168.9-119.7))/(132.2-111)

log close
