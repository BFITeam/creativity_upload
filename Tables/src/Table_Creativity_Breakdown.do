clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\Table_Creativity_Breakdown.log", replace
drop if treatment == 4

* Regressions for Table 6 * 

* gen rates
foreach var in original flex{
	foreach time in 1 2 3 {
		gen `var'_rate`time' = p_`var'`time' / p_valid`time'
	}
}

eststo clear

//level regressions
eststo: reg zeffort2 turnier gift zeffort1 			$controls if creative==1, robust
eststo: reg zp_valid2 turnier gift zp_valid1 		$controls if creative==1, robust
eststo: reg zp_flex2 turnier gift zp_flex1 			$controls if creative==1, robust
eststo: reg zp_original2 turnier gift zp_original1 	$controls if creative==1, robust

//rate regressions
eststo: reg flex_rate2 turnier gift flex_rate1 			$controls if creative==1, robust
eststo: reg original_rate2 turnier gift original_rate1 	$controls if creative==1, robust


tabstat zp_valid2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat zp_flex2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat zp_original2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat flex_rate2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat original_rate2 if creative == 1, by(treatment_id2) stat(mean median n)


//top answers
preserve
insheet using "$mypath\raw_data\r_data\best_answers.txt", clear tab
keep id antonia*
*tostring id, replace
tempfile topanswers
save `topanswers'
restore
destring id, replace
count
merge 1:m id using `topanswers', keep(match master) 
count
eststo: reg antoniatop30r2 turnier gift antoniatop30r1 $controls if creative==1, robust

//invalid uses
gen p_invalid1 = answers1 - p_valid1	
gen p_invalid2 = answers2 - p_valid2
eststo: reg p_invalid2 turnier gift p_invalid1 $controls if creative==1, robust

//check # of "best" ideas and proportion of "best" ideas
gen total_top = antoniatop30r2 + antoniatop30r1
gen total_p12 = p_valid2 + p_valid1

//tabstat total_top total_p12 if creative == 1, stat(sum)



local intercept_row Constant 
local controls_row Additional Controls
local tab_cols l

local num_regs 8
forvalues i = 1/`num_regs'{
	local tab_cols `tab_cols'c
	local intercept_row `intercept_row' & YES
	local controls_row `controls_row' & YES
}

#delimit; // #delimit: command resets the character that marks the end of a command, here ;
esttab using "$mypath\Tables\Output\Table4_Creativity_Breakdown.tex", 
	label	   // label (make use of variable labels)
	nomtitles
	rename(zeffort1 "Period1" zp_valid1 "Period1" zp_flex1 "Period1" zp_original1 "Period1" flex_rate1 "Period1" original_rate1 "Period1" antoniatop30r1 "Period1" p_invalid1 "Period1")
	varlabels("Period1" "Period 1 Output" _cons Constant turnier "Performance Bonus")
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
	drop($controls)
	nonumbers
	substitute(\' ')
	fragment
	replace
	prehead("\begin{landscape}"
	"\begin{table}[h]%" 
	"\captionsetup{justification=centering}"
	"\setlength\tabcolsep{2pt}"
	"\caption{Dimensions of Creativity: Treatment Effects on Output in Period 2}"
	"\label{tab:CreativityBreakdown}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{`tab_cols'}" 
	"\hline\noalign{\smallskip}"
	" & \multicolumn{`num_regs'}{c}{\textbf{Creative Task}} \\"
	" & \textit{Score} & \textit{Validity} & \textit{Flexibility} & \textit{Originality} & \textit{Flexibility} & \textit{Originality} & \textit{Best} & \textit{Invalid} \\"
	" &					& 					&						&					&	\textit{Rate}		&	\textit{Rate}		&	\textit{Answers}		&	\textit{Answers} \\" 
	" & I & II & III & IV & V & VI & VII & VIII \\")
	prefoot(
	"\midrule"
	" `controls_row' \\"
	"\midrule" ) 
	postfoot("\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth} $footnote_params"
	"\footnotesize NOTE.--This table reports the estimated OLS coefficients from Equation \ref{eq:reg} using only observations from the creative task. "
	"$treatment_coef_description "
	"The dependent variable in Column I is the standardized creativity score in Period 2. "
	"Please refer to Section $creative_score_section for a description of the scoring procedure. "
	"In Columns II, III, and IV, the dependent variables are the three different standardized subdimensions of the creativity score (validity, flexibility, and originality). "
	"Columns V and VI display treatment effects on the unstandardized flexibility and originality rate. "
	"The flexibility (originality) rate equals flexibility (originality) points divided by the number of validity points. Subjects with zero valid answers are dropped from these two regressions. "
	"Column VII reports the results for a subjective assessment of idea quality (unstandardized). To create this variable, an evaluator blind to the treatments was instructed to indicate for each idea whether they considered it to be a ``best$close_latex_quote or ``outstanding$close_latex_quote idea. "
	"Column VIII reports results for the number of invalid uses (unstandardized). "
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
	"\end{minipage}"
	"\end{center}"
	"\end{table}"
	"\end{landscape}");
#delimit cr

//make new originality scores with other cutoffs
gen original_o10_v5_1 = original_1_10 + original_1_5
gen original_o10_v5_2 = original_2_10 + original_2_5

gen original_o10_v1_1 = original_1_10 + original_1_1
gen original_o10_v1_2 = original_2_10 + original_2_1

gen original_o5_v1_1 = original_1_5 + original_1_1
gen original_o5_v1_2 = original_2_5 + original_2_1

//make new originality rates
foreach time in 1 2{
	foreach var in original_o10_v5 original_o10_v1 original_o5_v1 {
		gen `var'_`time'_rate = `var'_`time'/p_valid`time'
	}
}

//standardize orginality variables
foreach time in 1 2{
	//raw originality counts
	foreach cutoff in 1 5 10{
		sum original_`time'_`cutoff' if creative == 1 & control == 1
		gen zoriginal_`time'_`cutoff' = (original_`time'_`cutoff' - r(mean))/r(sd)
	}
	//originality scores
	foreach o in 5 10{
		foreach v in 1 5{
			capture sum original_o`o'_v`v'_`time' if creative == 1 & control == 1
			capture gen zoriginal_o`o'_v`v'_`time' = (original_o`o'_v`v'_`time' - r(mean))/r(sd)
		}
	}
}



rename turnier tournament

reg original_2_10 tournament gift original_1_10 $controls if creative == 1, robust
reg original_2_5 tournament gift original_1_5 $controls if creative == 1, robust

//eststo: reg original_o10_v5_2 tournament gift original_o10_v5_1 $controls if creative == 1, robust
eststo: reg original_o10_v1_2 tournament gift original_o10_v1_1 $controls if creative == 1, robust
eststo: reg original_o5_v1_2 tournament gift original_o5_v1_1 $controls if creative == 1, robust
eststo: reg original_2_1 tournament gift original_1_1 $controls if creative == 1, robust

reg invalid2 tournament gift invalid1 $controls if creative == 1, robust

eststo: reg original_o10_v5_2_rate tournament gift original_o10_v5_1_rate $controls if creative == 1, robust
eststo: reg original_o10_v1_2_rate tournament gift original_o10_v1_1_rate $controls if creative == 1, robust
eststo: reg original_o5_v1_2_rate tournament gift original_o5_v1_1_rate $controls if creative == 1, robust

log close

