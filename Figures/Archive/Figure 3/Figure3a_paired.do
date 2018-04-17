clear all
set more off
set memory 100m
cap log close

global mypath = "D:\Dropbox\Work\Projekte\Aktiv\WOEK\Do-Files\Stata\Figures\Figure 3"
use "$mypath\Figure3a_paired.dta", clear

drop if treatment==4

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament", noticks) 	///
	ytitle("Difference between Round 3 and 1") xtitle(" ") ylabel(-4 (2) 6) subtitle("Slider Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figurea3a_paired.gph", replace) 
	graph export "$mypath\Figurea3a_paired.ps", logo(off) replace




set more on
exit, clear
