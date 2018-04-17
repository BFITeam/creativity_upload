clear all
set more off
set memory 100m
cap log close

global mypath = "D:\Dropbox\Work\Projekte\Aktiv\WOEK\Backup\p-schmit\WOEK\Final Paper Versions\Figures\Figure 3"
use "$mypath\Figure3b.dta", clear


graph twoway (bar coefficient treatment, barwidth(0.8))(rcap high low treatment), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament" 4 "Feedback", noticks) 	///
	ytitle("Difference between Round 3 and 1") xtitle(" ") ylabel(-4 (2) 14) subtitle("Creative Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figurea3b.gph", replace) 
	graph export "$mypath\Figurea3b.ps", logo(off) replace




set more on
exit, clear
