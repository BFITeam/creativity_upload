clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview.dta", clear
log using "$mypath\Tables\Table 3\Table3_Wilcoxon-Test.log", replace

preserve

gen heidelberg = 1 if mannheim==2
replace heidelberg = 0 if heidelberg== .
gen frankfurt = 1 if mannheim==0
replace frankfurt = 0 if frankfurt== .
replace mannheim = 0 if (heidelberg==1 | frankfurt==1)

drop if treatment_id==52


******#of subjects, agent, rewarded agents*********
tab treatment_id if (fdb_old==0 & session_problem==.)
tab treatment_id if (fdb_old==0 & session_problem==. & no_problem==. & proposer==0)
tab treatment_id if (fdb_old==0 & subject_sample==1)


******Age**********************************
tabulate treatment_id if subject_sample==1, summarize(age) means

ranksum age if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum age if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)


******Sex********************************
tab treatment_id sex if subject_sample==1, row

ranksum sex if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum sex if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)


******WIWI********************************
tab treatment_id wiwi if subject_sample==1, row

ranksum wiwi if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum wiwi if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)


******Location************************************
tab treatment_id frankfurt if subject_sample==1, row
tab treatment_id mannheim if subject_sample==1, row
tab treatment_id heidelberg if subject_sample==1, row

ranksum frankfurt if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum frankfurt if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)

ranksum mannheim if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum mannheim if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)

ranksum heidelberg if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum heidelberg if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)


******effort1/transfer1******************************
tab treatment_id if subject_sample==1, summarize(effort1) means standard 
tab treatment_id if subject_sample==1, summarize(transfer1) means standard 

ranksum effort1 if ((treatment_id==11 | treatment_id==12) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==11 | treatment_id==13) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==11 | treatment_id==14) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==21 | treatment_id==22) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==21 | treatment_id==23) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==21 | treatment_id==24) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==31 | treatment_id==32) & subject_sample==1) , by(treatment_id)
ranksum effort1 if ((treatment_id==41 | treatment_id==42) & subject_sample==1) , by(treatment_id)


******Mann-Whitney-Test for Creative Transfer****************

ranksum transfer1 if ((treatment_id==41 | treatment_id==42) & subject_sample==1), by(treatment_id)



restore




log close
set more on
exit, clear
