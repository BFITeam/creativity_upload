 clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\TableTournamentPreiod3.log", replace 

keep if turnier == 1 | control == 1 | treatment == 31 | treatment == 32

gen winner = (turnier == 1 | eke == 1 | kek == 1) & bonus_recvd == 1
gen loser = (turnier == 1 | eke == 1 | kek == 1) & bonus_recvd == 0

reg ztransfer3 turnier ztransfer1 if slider == 1 , robust
reg ztransfer3 winner loser ztransfer1 if slider == 1 , robust

//these are off
reg ztransfer3 turnier ztransfer1 if (turnier == 1 | control == 1) & creative == 1, robust
reg ztransfer3 winner loser ztransfer1 if (turnier == 1 | control == 1) & creative == 1 , robust

//Mixed: SCS (EKE)
reg ztransfer3 eke ztransfer1 if treatment == 31 | (slider == 1 & control == 1), robust
reg ztransfer3 winner loser ztransfer1 if treatment == 31 | (slider == 1 & control == 1), robust

//Mixed: CSC (KEK) (these are also off)
reg ztransfer3 kek ztransfer1 if treatment == 32 | (creative == 1 & control == 1), robust
reg ztransfer3 winner loser ztransfer1 if treatment == 32 | (creative == 1 & control == 1), robust

log close
