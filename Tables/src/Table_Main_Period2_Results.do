clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\Table_Main_Period2_Results.log", replace
drop if treatment == 4

cap program drop get_pvals
program define get_pvals, rclass
	
	test turnier == gift
	local p_cr = round(`r(p)',.00001)
	if(`p_cr' == 0) local p_cr 0.000
	
	test turnier + turnXslid == gift + giftXslid
	local p_sl = round(`r(p)',.00001)
	if(`p_sl' == 0) local p_sl 0.000
	
	test gift + giftXslid == 0 
	local p_sl_g_0 = round(`r(p)',.00001)
	if(`p_sl_g_0' == 0) local p_sl_g_0 0.000
	
	test turnier + turnXslid == 0 
	local p_sl_t_0 = round(`r(p)',.00001)
	if(`p_sl_t_0' == 0) local p_sl_t_0 0.000
	
	local gift_slider_point_est = _b[gift] + _b[giftXslid]
	test gift == `gift_slider_point_est'
	local p_cr_2 = round(`r(p)',.00001)
	if(`p_cr_2' == 0) local p_cr_2 0.000
	
	display "Test for tournament and gift having the same effect in creative task: `p_cr'"
	display "Test for tournament and gift having the same effect in slider task: `p_sl'"
	display "Test for gift having zero effect in slider task: `p_sl_g_0'"
	display "Test for tournament having zero effect in slider task: `p_sl_t_0'"
	display "Test for gift in slider task having effect size equal to point estimate of gift in creative task: `p_cr_2'"
	
	return local p_cr `p_cr'
	return local p_sl `p_sl'
end


* Nummer 1
local treatments turnier turnXslid gift giftXslid

eststo clear	// eststo clear drops all estimation sets stored by eststo
eststo:  reg ztransfer2 `treatments' if feedback==0 & (slider==1 | creative==1), robust 
//get_pvals
local p_1_cr `r(p_cr)'
local p_1_sl `r(p_sl)'

eststo:  reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid if feedback==0 & (slider==1 | creative==1), robust 
//get_pvals
local p_2_cr `r(p_cr)'
local p_2_sl `r(p_sl)'
//test gift + giftXslid = 0

  
eststo:  reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid $controls if (slider==1 | creative==1), robust 

get_pvals
local p_3_cr `r(p_cr)'
local p_3_sl `r(p_sl)'
test gift = giftXslid
test gift + giftXslid == 0 
test gift == 0.2

tabstat ztransfer2 if creative == 1 | slider == 1, by(treatment_id2) stat(mean median n)


local p_format %9.3f
#delimit; // #delimit: command resets the character that marks the end of a command, here ;

esttab using "$mypath\Tables\Output\Table3_Period2_Results.tex", // esttab produces a pretty-looking publication-style regression table from stored estimates without much typing (alternative zu estout)
	nomtitles	// Options: mtitles (model titles to appear in table header)
	label	   // label (make use of variable labels)
	varlabel (_cons "Constant" ztransfer1 "Period 1 Output" zeffort1 "Period 1 Output" slider "Simple Task" gift "Gift" turnier "Performance Bonus" zeffort1Xslid "Period 1 Output x Simple Task" giftXslid "Gift x Simple Task" turnXslid "Performance Bonus x Simple Task" ztransfer1Xslid "Period 1 Output x Simple Task"
	, elist(_cons "[2mm]" zeffort1 "[2mm]" slider "[2mm]" gift "[2mm]" turnier "[2mm]" feedback "[2mm]" giftXslid "[2mm]" turnXslid "[2mm]" feedXslid "[2mm]" zeffort1Xslid "[2mm]" ztransfer1 "[2mm]" ztransfer1Xslid "[2mm]"))
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop ($controls)
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\captionsetup{justification=centering}"
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects on Output in Period 2 in both the Creative and the Simple Task}"
	
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lccc}" 
	"\hline\noalign{\smallskip}"
	" & I & II & III \\")
	posthead("\hline\noalign{\smallskip}") 
	prefoot("\noalign{\smallskip}\hline"
	"Additional Controls & NO & NO & YES \\"
	"\hline" ) 
	postfoot(
	"\hline\noalign{\medskip}"
	"\end{tabular}"
	"\begin{minipage}{\textwidth} $footnote_params"
	"\footnotesize NOTE.--This table reports the estimated OLS coefficients from Equation \ref{eq:reg}. " 
	"The dependent variable is standardized output in Period 2. $pooled_performance_description "
	"$treatment_coef_description " 
	"$slider_treatment_effects "
	""
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	""
	"$p1"
	""
	"$p2"
	""
	"$p3"
	"\end{minipage}}"
	"\end{center}"
	"\label{tab:EQ_Pooled_Results}"
	"\end{table}")
	replace;
			
#delimit cr	// #delimit cr: restore the carriage return delimiter inside a file

********************************
*** Cluster Robustness Check ***
********************************

local treatments turnier turnXslid gift giftXslid 
eststo clear	// eststo clear drops all estimation sets stored by eststo
eststo:  reg ztransfer2 `treatments' if feedback==0 & (slider==1 | creative==1), robust cluster(session)
eststo:  reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid if feedback==0 & (slider==1 | creative==1), robust cluster(session)
eststo:  reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid $controls if (slider==1 | creative==1), robust cluster(session)
test gift = giftXslid
test gift + giftXslid == 0 
test gift == 0.2

#delimit ;
esttab using "$mypath\Tables\Output\Appendix\TableA3_Period2_Results_Cluster_Session.tex", // esttab produces a pretty-looking publication-style regression table from stored estimates without much typing (alternative zu estout)
	nomtitles	// Options: mtitles (model titles to appear in table header)
	label	   // label (make use of variable labels)
	varlabel (_cons "Constant" ztransfer1 "Period 1 Output" zeffort1 "Period 1 Output" slider "Simple Task" gift "Gift" turnier "Performance Bonus" zeffort1Xslid "Period 1 Output x Simple Task" giftXslid "Gift x Simple Task" turnXslid "Performance Bonus x Simple Task" ztransfer1Xslid "Period 1 Output x Simple Task"
	, elist(_cons "[2mm]" zeffort1 "[2mm]" slider "[2mm]" gift "[2mm]" turnier "[2mm]" feedback "[2mm]" giftXslid "[2mm]" turnXslid "[2mm]" feedXslid "[2mm]" zeffort1Xslid "[2mm]" ztransfer1 "[2mm]" ztransfer1Xslid "[2mm]"))
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop ($controls)
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\captionsetup{justification=centering}"
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects on Output in Period 2 in both the Creative and the Simple Task \\ Clustered by Experimental Session}"
	
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lccc}" 
	"\hline\noalign{\smallskip}"
	" & I & II & III \\")
	posthead("\hline\noalign{\smallskip}") 
	prefoot("\noalign{\smallskip}\hline"
	" Additional Controls & NO & NO & YES \\"
	"\hline" ) 
	postfoot(
	"\hline\noalign{\medskip}"
	"\end{tabular}"
	"\begin{minipage}{\textwidth} $footnote_params"
	"\footnotesize NOTE.--This table reports the estimated OLS coefficients from Equation \ref{eq:reg}. This table differs from Table \ref{tab:EQ_Pooled_Results} in that it clusters standard errors by session." 
	"The dependent variable is standardized output in Period 2. $pooled_performance_description "
	"$treatment_coef_description " 
	"$slider_treatment_effects "
	""
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	""
	"$p1"
	""
	"$p2"
	""
	"$p3"
	"\end{minipage}}"
	"\end{center}"
	"\label{tab:EQ_Pooled_Results_Cluster_Session}"
	"\end{table}")
	replace;
			
#delimit cr	// #delimit cr: restore the carriage return delimiter inside a file

log close
