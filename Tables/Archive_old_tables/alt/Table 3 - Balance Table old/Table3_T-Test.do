clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Overview.dta", clear
log using "$mypath\Tables\Table 3\Table3_T-Test.log", replace

preserve

gen heidelberg = 1 if mannheim==2
replace heidelberg = 0 if heidelberg== .
gen frankfurt = 1 if mannheim==0
replace frankfurt = 0 if frankfurt== .
replace mannheim = 0 if (heidelberg==1 | frankfurt==1)

drop if treatment_id==52


******#of subjects, agent, rewarded agents*********
tab treatment_id if ( session_problem==. & fdb_old==0 & ( no_problem==. | (no_problem!=. & proposer==1)))
tab treatment_id if (fdb_old==0 & session_problem==. & no_problem==. & proposer==0)
tab treatment_id if (fdb_old==0 & subject_sample==1)

drop if subject_sample!=1

******Age**********************************
tabulate treatment_id, summarize(age) means

gen age_11 = age if treatment_id==11
gen age_12 = age if treatment_id==12
gen age_13 = age if treatment_id==13
gen age_14 = age if treatment_id==14
gen age_21 = age if treatment_id==21
gen age_22 = age if treatment_id==22
gen age_23 = age if treatment_id==23
gen age_24 = age if treatment_id==24
gen age_31 = age if treatment_id==31
gen age_32 = age if treatment_id==32
gen age_41 = age if treatment_id==41
gen age_42 = age if treatment_id==42

ttest age_11==age_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest age_11==age_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest age_11==age_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest age_21==age_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest age_21==age_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest age_21==age_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest age_11==age_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest age_21==age_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest age_41==age_42 if (treatment_id==41|treatment_id==42), level(90) unp


******Sex********************************
tab treatment_id sex, row

gen sex_11 = sex if treatment_id==11
gen sex_12 = sex if treatment_id==12
gen sex_13 = sex if treatment_id==13
gen sex_14 = sex if treatment_id==14
gen sex_21 = sex if treatment_id==21
gen sex_22 = sex if treatment_id==22
gen sex_23 = sex if treatment_id==23
gen sex_24 = sex if treatment_id==24
gen sex_31 = sex if treatment_id==31
gen sex_32 = sex if treatment_id==32
gen sex_41 = sex if treatment_id==41
gen sex_42 = sex if treatment_id==42

ttest sex_11==sex_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest sex_11==sex_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest sex_11==sex_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest sex_21==sex_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest sex_21==sex_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest sex_21==sex_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest sex_11==sex_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest sex_21==sex_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest sex_41==sex_42 if (treatment_id==41|treatment_id==42), level(90) unp


******WIWI********************************
tab treatment_id wiwi, row

gen wiwi_11 = wiwi if treatment_id==11
gen wiwi_12 = wiwi if treatment_id==12
gen wiwi_13 = wiwi if treatment_id==13
gen wiwi_14 = wiwi if treatment_id==14
gen wiwi_21 = wiwi if treatment_id==21
gen wiwi_22 = wiwi if treatment_id==22
gen wiwi_23 = wiwi if treatment_id==23
gen wiwi_24 = wiwi if treatment_id==24
gen wiwi_31 = wiwi if treatment_id==31
gen wiwi_32 = wiwi if treatment_id==32
gen wiwi_41 = wiwi if treatment_id==41
gen wiwi_42 = wiwi if treatment_id==42

ttest wiwi_11==wiwi_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest wiwi_11==wiwi_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest wiwi_11==wiwi_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest wiwi_21==wiwi_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest wiwi_21==wiwi_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest wiwi_21==wiwi_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest wiwi_11==wiwi_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest wiwi_21==wiwi_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest wiwi_41==wiwi_42 if (treatment_id==41|treatment_id==42), level(90) unp


******Location************************************
tab treatment_id frankfurt, row
tab treatment_id mannheim, row
tab treatment_id heidelberg, row

gen frankfurt_11 = frankfurt if treatment_id==11
gen frankfurt_12 = frankfurt if treatment_id==12
gen frankfurt_13 = frankfurt if treatment_id==13
gen frankfurt_14 = frankfurt if treatment_id==14
gen frankfurt_21 = frankfurt if treatment_id==21
gen frankfurt_22 = frankfurt if treatment_id==22
gen frankfurt_23 = frankfurt if treatment_id==23
gen frankfurt_24 = frankfurt if treatment_id==24
gen frankfurt_31 = frankfurt if treatment_id==31
gen frankfurt_32 = frankfurt if treatment_id==32
gen frankfurt_41 = frankfurt if treatment_id==41
gen frankfurt_42 = frankfurt if treatment_id==42

ttest frankfurt_11==frankfurt_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest frankfurt_11==frankfurt_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest frankfurt_11==frankfurt_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest frankfurt_21==frankfurt_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest frankfurt_21==frankfurt_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest frankfurt_21==frankfurt_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest frankfurt_11==frankfurt_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest frankfurt_21==frankfurt_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest frankfurt_41==frankfurt_42 if (treatment_id==41|treatment_id==42), level(90) unp

gen mannheim_11 = mannheim if treatment_id==11
gen mannheim_12 = mannheim if treatment_id==12
gen mannheim_13 = mannheim if treatment_id==13
gen mannheim_14 = mannheim if treatment_id==14
gen mannheim_21 = mannheim if treatment_id==21
gen mannheim_22 = mannheim if treatment_id==22
gen mannheim_23 = mannheim if treatment_id==23
gen mannheim_24 = mannheim if treatment_id==24
gen mannheim_31 = mannheim if treatment_id==31
gen mannheim_32 = mannheim if treatment_id==32
gen mannheim_41 = mannheim if treatment_id==41
gen mannheim_42 = mannheim if treatment_id==42

ttest mannheim_11==mannheim_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest mannheim_11==mannheim_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest mannheim_11==mannheim_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest mannheim_21==mannheim_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest mannheim_21==mannheim_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest mannheim_21==mannheim_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest mannheim_11==mannheim_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest mannheim_21==mannheim_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest mannheim_41==mannheim_42 if (treatment_id==41|treatment_id==42), level(90) unp

gen heidelberg_11 = heidelberg if treatment_id==11
gen heidelberg_12 = heidelberg if treatment_id==12
gen heidelberg_13 = heidelberg if treatment_id==13
gen heidelberg_14 = heidelberg if treatment_id==14
gen heidelberg_21 = heidelberg if treatment_id==21
gen heidelberg_22 = heidelberg if treatment_id==22
gen heidelberg_23 = heidelberg if treatment_id==23
gen heidelberg_24 = heidelberg if treatment_id==24
gen heidelberg_31 = heidelberg if treatment_id==31
gen heidelberg_32 = heidelberg if treatment_id==32
gen heidelberg_41 = heidelberg if treatment_id==41
gen heidelberg_42 = heidelberg if treatment_id==42

ttest heidelberg_11==heidelberg_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest heidelberg_11==heidelberg_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest heidelberg_11==heidelberg_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest heidelberg_21==heidelberg_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest heidelberg_21==heidelberg_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest heidelberg_21==heidelberg_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest heidelberg_11==heidelberg_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest heidelberg_21==heidelberg_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest heidelberg_41==heidelberg_42 if (treatment_id==41|treatment_id==42), level(90) unp


******Effort1******************************
tab treatment_id, summarize(effort1) means standard 
tab treatment_id, summarize(transfer1) means standard 

gen effort1_11 = effort1 if treatment_id==11
gen effort1_12 = effort1 if treatment_id==12
gen effort1_13 = effort1 if treatment_id==13
gen effort1_14 = effort1 if treatment_id==14
gen effort1_21 = effort1 if treatment_id==21
gen effort1_22 = effort1 if treatment_id==22
gen effort1_23 = effort1 if treatment_id==23
gen effort1_24 = effort1 if treatment_id==24
gen effort1_31 = effort1 if treatment_id==31
gen effort1_32 = effort1 if treatment_id==32
gen effort1_41 = effort1 if treatment_id==41
gen effort1_42 = effort1 if treatment_id==42

ttest effort1_11==effort1_12 if (treatment_id==11|treatment_id==12), level(90) unp
ttest effort1_11==effort1_13 if (treatment_id==11|treatment_id==13), level(90) unp
ttest effort1_11==effort1_14 if (treatment_id==11|treatment_id==14), level(90) unp
ttest effort1_21==effort1_22 if (treatment_id==21|treatment_id==22), level(90) unp
ttest effort1_21==effort1_23 if (treatment_id==21|treatment_id==23), level(90) unp
ttest effort1_21==effort1_24 if (treatment_id==21|treatment_id==24), level(90) unp
ttest effort1_11==effort1_31 if (treatment_id==11|treatment_id==31), level(90) unp
ttest effort1_21==effort1_32 if (treatment_id==21|treatment_id==32), level(90) unp
ttest effort1_41==effort1_42 if (treatment_id==41|treatment_id==42), level(90) unp



restore




log close
set more on
exit, clear
