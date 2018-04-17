clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions\Figures\Figure 2"
use "$mypath\Figure2b.dta", clear


graph twoway (bar coefficient treatment, barwidth(0.8))(rcap high low treatment), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament" 4 "Feedback", noticks) 	///
	ytitle("Difference between Round 2 and 1") xtitle(" ") ylabel(-4 (2) 14) subtitle("Creative Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figure2b.gph", replace) 
	graph export "$mypath\Figure2b.ps", logo(off) replace




set more on
exit, clear
