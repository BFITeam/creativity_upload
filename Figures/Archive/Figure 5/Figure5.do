clear all
set more off
set memory 100m
cap log close

use "$mypath\Figures\Figure 5\Figure5.dta", clear


graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Gift Slider" 2 "Gift Creative" 3 `" "Gift Creative with " "Discretionary Transfer" "', noticks) 	///
	xtitle(" ") ylabel(-0.2 (0.2) 0.6) subtitle("") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figure5.gph", replace) 
	graph export "$mypath\Figures\Figure 5\Figure5_new.pdf", logo(off) replace




clear
