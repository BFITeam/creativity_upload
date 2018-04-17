clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\Reciprocity.log", replace
drop if treatment == 4

 
 
 //Reciprocity regressions 

eststo clear
eststo: reg ztransfer2 turnier turnXslid gift giftXslid ztransfer1 ztransfer1Xslid $controls tendencytoforgive if (slider==1 | creative==1), robust
eststo: reg ztransfer2 turnier turnier#c.tendencytoforgive turnXslid turnXslid#c.tendencytoforgive gift gift#c.tendencytoforgive giftXslid giftXslid#c.tendencytoforgive /*slider#c.tendencytoforgive*/ tendencytoforgive ztransfer1 ztransfer1Xslid $controls if (slider==1 | creative==1), robust

#delimit ;
esttab using "$mypath\Tables\Output\Referees\Reciprocity.tex", // esttab produces a pretty-looking publication-style regression table from stored estimates without much typing (alternative zu estout)
	nomtitles	// Options: mtitles (model titles to appear in table header)
	label	   // label (make use of variable labels)
	varlabel (_cons "Constant" ztransfer1 "Period 1 Output" zeffort1 "Period 1 Output" gift "Gift" turnier "Performance Bonus" zeffort1Xslid "Period 1 Output x Simple Task" giftXslid "Gift x Simple Task" turnXslid "Performance Bonus x Simple Task" ztransfer1Xslid "Period 1 Output x Simple Task"
	tendencytoforgive "Reciprocity" 1.turnier#c.tendencytoforgive "Performance Bonus x Reciprocity" 1.turnXslid#c.tendencytoforgive "Performance Bonus x Slider x Reciprocity" 1.gift#c.tendencytoforgive "Gift x Reciprocity" 1.giftXslid#c.tendencytoforgive "Gift x Slider x Reciprocity" 1.slider#c.tendencytoforgive "Slider x Reciprocity"
	, elist(_cons "[2mm]" zeffort1 "[2mm]" gift "[2mm]" turnier "[2mm]" feedback "[2mm]" giftXslid "[2mm]" turnXslid "[2mm]" feedXslid "[2mm]" zeffort1Xslid "[2mm]" ztransfer1 "[2mm]" ztransfer1Xslid "[2mm]"))
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop ($controls 0.*)
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects in Period 2: Reciprocity Controls}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{.9}%" 
	"\begin{tabular}{lcc}" 
	"\hline\noalign{\smallskip}"
	" & Controls for & Interactions with \\"
	" & Reciprocity  & Reciprocity \\")
	posthead("\hline\noalign{\smallskip}") 
	prefoot("\noalign{\smallskip}\hline"
	" Controls & YES & YES \\"
	"\hline" ) 
	postfoot(
	"\hline\noalign{\medskip}"
	"\end{tabular}"
	"\begin{minipage}{\textwidth} $footnote_params"
	"\footnotesize NOTE.--This table reports the estimated OLS coefficients from Equation 1 and adds a control for reciprocity (Column I) or controls for reciprocity interacted with the different treatment indicators (Column II). " 
	"The dependent variable is standardized performance in Period 2. $pooled_performance_description "
	"The treatment dummies \textit{Gift} and \textit{Performance Bonus} capture the effect of an unconditional wage gift or of a tournament incentive (rewarding the top 2 performers out of 4 agents) on standardized performance. " 
	"The interaction effects with the \textit{Simple} variable measure the difference in treatment effects between the creative and the simple task. "
	"That is, the estimated effect of the two treatments on the creative task is the main treatment coefficient (\textit{Gift} or \textit{Performance Bonus}) and the effect on the simple task is the sum of the main treatment coefficient and the respective interaction coefficient (\textit{Performance Bonus x Simple} or \textit{Gift x Simple}). "
	"The interaction effects with the \textit{Reciprocity} variable show how the effects of the treatments (by task) vary with the strength of reciprocal inclinations of the subject. "
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
#delimit cr


log close
