clear all
set more off
set memory 100m
cap log close

global mypath = "D:\Dropbox\Work\Projekte\Aktiv\WOEK\Do-Files\Stata\Figures\Figure 2"
use "$mypath\Figure2b_paired.dta", clear

drop if treatment==4

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament", noticks) 	///
	ytitle("Difference between Round 2 and 1") xtitle(" ") ylabel(-4 (2) 14) subtitle("Creative Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figure2b_paired.gph", replace) 
	graph export "$mypath\Figure2b_paired.ps", logo(off) replace




set more on
exit, clear
