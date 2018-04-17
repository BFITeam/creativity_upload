clear all
set more off
set memory 100m
cap log close


use "$mypath\raw_data\Overview.dta", clear
log using "$mypath\Tables\Logs\BalanceTable_T-Test.log", replace
//drop if treatment == 4 | treatment_id == 31 | treatment_id == 32

gen heidelberg = 1 if mannheim==2
replace heidelberg = 0 if heidelberg== .
gen frankfurt = 1 if mannheim==0
replace frankfurt = 0 if frankfurt== .
replace mannheim = 0 if (heidelberg==1 | frankfurt==1)

drop if treatment_id==52 | treatment_id == 31 | treatment_id == 32


******#of subjects, agent, rewarded agents*********
tab treatment_id2 if ( session_problem==. & fdb_old==0 & ( no_problem==. | (no_problem!=. & proposer==1)))
tab treatment_id2 if (fdb_old==0 & session_problem==. & no_problem==. & proposer==0)
tab treatment_id2 if (fdb_old==0 & subject_sample==1)

drop if subject_sample!=1

*program to report the balance statistics 
capture program drop report_balance
capture program define report_balance
	args tabulate_options var tab_var
	
	foreach treat_id in 11 12 13 14 21 22 23 24 31 32 41 42{
		capture gen `var'_`treat_id' = `var' if treatment_id == `treat_id'
	}
	
	di "Main treatments"
	tabulate treatment_id `tab_var' if inlist(treatment_id,11,12,13,21,22,23), `tabulate_options'
	
	ttest `var'_11==`var'_12 if (treatment_id==11|treatment_id==12), level(90) unp
	ttest `var'_11==`var'_13 if (treatment_id==11|treatment_id==13), level(90) unp
	ttest `var'_21==`var'_22 if (treatment_id==21|treatment_id==22), level(90) unp
	ttest `var'_21==`var'_23 if (treatment_id==21|treatment_id==23), level(90) unp
	
	di "Supplementary Treatments"
	
	//feedback treatment
	di "Feedback"
	tab treatment_id `tab_var' if treatment == 4, `tabulate_options'
	ttest `var'_11==`var'_14 if (treatment_id==11|treatment_id==14), level(90) unp
	ttest `var'_21==`var'_24 if (treatment_id==21|treatment_id==24), level(90) unp

	//creative transfer
	di "Creative transfer"
	tab treatment_id `tab_var' if treatment_id > 40, `tabulate_options'
	ttest `var'_41==`var'_42 if (treatment_id==41|treatment_id==42), level(90) unp
	
	di "Overall average"
	sum `var'
	
	di "Overall average excluding feedback"
	sum `var' if treatment != 4
	
end

report_balance "summarize(age) means" age
report_balance "row nofreq" sex sex
report_balance "row nofreq" wiwi wiwi
report_balance "row nofreq" frankfurt frankfurt
report_balance "row nofreq" mannheim mannheim 
report_balance "row nofreq" heidelberg heidelberg
report_balance "summarize(score1) means standard obs" score1
report_balance "row nofreq" ferienzeit ferienzeit
report_balance "row nofreq" pruefungszeit pruefungszeit

log close
set more on
exit, clear
