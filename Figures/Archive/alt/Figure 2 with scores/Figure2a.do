clear all
set more off
set memory 100m
cap log close

global mypath = "I:\personal\zew_interns\p-schmit\WOEK\Final Paper Versions\Figures\Figure 2"
use "$mypath\Figure2a.dta", clear


graph twoway (bar coefficient treatment, barwidth(0.8) sort)(rcap high low treatment, sort), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament" 4 "Feedback", noticks) 	///
	ytitle("Difference between Round 2 and 1") xtitle(" ") ylabel(-4 (2) 14) subtitle("Slider Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figure2a.gph", replace) 
	graph export "$mypath\Figure2a.ps", logo(off) replace




set more on
exit, clear
