clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Overview.dta", clear
log using "$mypath\Tables\Table 3\Table3.log", replace

preserve

gen heidelberg = 1 if mannheim==2
replace heidelberg = 0 if heidelberg== .
replace mannheim = 0 if heidelberg==1

******#of subjects, agent, rewarded agents*********

tab treatment_id if (fdb_old==0 & session_problem==.)
tab treatment_id if (fdb_old==0 & session_problem==. & no_problem==. & proposer==0)
tab treatment_id if (fdb_old==0 & session_problem==. & no_problem==. & proposer==0 & bonus_dec==1)


*********mit Problemkandidaten*************************
tab treatment_id if fdb_old==0
tab treatment_id if ( proposer==0 & fdb_old==0)
tab treatment_id if ( proposer==0  &  bonus_dec==1 & fdb_old==0 )
********ohne Problemkandidaten*********************
tab treatment_id if (no_problem== . & session_problem== . & fdb_old==0)
tab treatment_id if ( proposer==0 & session_problem== . & no_problem== . & fdb_old==0)
tab treatment_id if ( proposer==0 & session_problem== . &  bonus_dec==1 & no_problem== . & fdb_old==0)

****************************Problem Candidates ohne Fdb Old*****************************
*All
tab treatment_id if  ((no_problem!= . | session_problem!= .) & fdb_old==0)
*Agents
tab treatment_id if  ((no_problem!= . | session_problem!= .) & proposer==0 & fdb_old==0)
*Rewarded Agents
tab treatment_id if  ((no_problem!= . | session_problem!= .) & proposer==0 & bonus_dec==1 & fdb_old==0)
************Age**********************************

tabulate treatment_id if (proposer==0 & session_problem== . & no_problem== . &  bonus_dec==1  & fdb_old==0 & ( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32)) , summarize(age) means


*****************effort1/transfer1******************************

tabulate treatment_id if (( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32) & proposer==0 & session_problem== . &  bonus_dec==1 & no_problem== . & fdb_old==0) , summarize(effort1) means standard 
tabulate treatment_id if (( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32) & proposer==0 & session_problem== . &  bonus_dec==1 & no_problem== . & fdb_old==0) , summarize(transfer1) means standard 

*******************Sex********************************

tab treatment_id sex if (( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32) &proposer==0 & session_problem= =  . &  bonus_dec==1 & no_problem== . & fdb_old==0) , row

*******************WIWI********************************

tab treatment_id wiwi if (( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32) &proposer==0 & session_problem= =  . &  bonus_dec==1 & no_problem== . & fdb_old==0) , row

********************Location************************************

tab treatment_id mannheim if (( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32) &proposer==0 & session_problem= =  . &  bonus_dec==1 & no_problem== . & fdb_old==0) , row
tab treatment_id heidelberg if (( treatment_id==11 | treatment_id==12 | treatment_id==13  | treatment_id==14  | treatment_id==21  | treatment_id==22  | treatment_id==23  | treatment_id==24  | treatment_id==41  | treatment_id==42 | treatment_id==31 | treatment_id==32) &proposer==0 & session_problem= =  . &  bonus_dec==1 & no_problem== . & fdb_old==0) , row

*******************Mann-Whitney-Test for Creative Transfer****************

ranksum transfer1 if ((treatment_id==41 | treatment_id==42) & proposer==0 & session_problem== . & no_problem== . &  bonus_dec==1) , by(treatment_id)

ranksum effort1 if ((treatment_id==41 | treatment_id==42) & proposer==0 & session_problem== . & no_problem== . &  bonus_dec==1) , by(treatment_id)

ranksum effort1 if ((treatment_id==31 | treatment_id==32) & proposer==0 & session_problem== . & no_problem== . &  bonus_dec==1) , by(treatment_id)



restore




log close
set more on
exit, clear
