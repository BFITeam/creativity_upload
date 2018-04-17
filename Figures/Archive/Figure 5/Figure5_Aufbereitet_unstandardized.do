clear all
set more off
set memory 100m
cap log close

global mypath = "D:\Dropbox\Work\Projekte\Aktiv\WOEK\Backup\p-schmit\WOEK\Final Paper Versions"

use "$mypath\Datenaufbereitung\Do-Files und Datasets\Overview_Aufbereitet.dta", clear
log using "$mypath\Figures\Figure 5\Figure5_Aufbereitet.log", replace


reg effort2 effort1 gift if (treatment_id==11 | treatment_id==12), level(90) robust
reg effort2 effort1 gift if (treatment_id==21 | treatment_id==22), level(90) robust
reg transfer2 transfer1 giftXtransfer if (treatment_id==41 | treatment_id==42), level(90) robust




log close
set more on
exit, clear
