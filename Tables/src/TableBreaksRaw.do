clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4

log using "$mypath\Tables\Logs\TableBreaks.log", replace

// make new variables 
gen time1 = 180-pausen1*20
gen time2 = 180-pausen2*20

gen pausendif = pausen2 - pausen1

//Make formated variables for table output
gen Task = "Simple" if slider == 1
replace Task = "Creative" if creative == 1

gen Treatment = "Control" if treatment == 1
replace Treatment = "Gift" if treatment == 2
replace Treatment = "Tournament" if treatment == 3

//tournament treatment
ttest pausendif == 0 if slider == 1 & turnier == 1
ttest pausendif == 0 if creative == 1 & turnier == 1

//gift treatment
ttest pausendif == 0 if slider == 1 & gift == 1
ttest pausendif == 0 if creative == 1 & gift == 1

//Output mean number of breaks by treatment x task
preserve
collapse (mean) pausen1 pausen2, by(Task Treatment)
drop if missing(Task) | missing(Treatment)
gsort -Task Treatment

format pausen* %9.2f


list

//tex output
replace Treatment = "Performance Bonus" if Treatment == "Tournament"

capture program drop breaks_row_output
program define breaks_row_output, rclass
	args task treatment
	//Correction for Performance Bonus being two words
	if "`treatment'" == "Tournament" local treatment Performance Bonus
	
	quietly: sum pausen1 if Task == "`task'" & Treatment == "`treatment'"
	local breaks1 = `r(mean)'
	
	quietly: sum pausen2 if Task == "`task'" & Treatment == "`treatment'"
	local breaks2 = `r(mean)'
	
	local format %4.2f
	
	//only write the task name in the control line
	if ("`treatment'" != "Control"){
		local task 
	}
	
	return local line "`task' & `treatment' & " `format' (`breaks1') " & " `format' (`breaks2') " \\"
end

breaks_row_output Simple Gift
local Simple_Control_line `r(line)'
di "`Simple_Control_line'"

foreach task in Simple Creative{
	foreach treatment in Control Gift Tournament {
		breaks_row_output `task' `treatment'
		local `task'_`treatment'_line `r(line)'
		di "``task'_`treatment'_line'"
	}
}

cap file close f 
file open f using "$mypath/Tables/Output/Appendix/TableA6_Num_Breaks.tex", write replace

#delimit ;
file write f 
	"\begin{table}[h]%"  _n
	"\setlength\tabcolsep{2pt}"  _n
	"\caption{Average Number of Breaks Taken by Treatment and Period}"  _n
	"\label{tab:BreaksMeans}" _n
	"\begin{center}%"  _n
	"{\small\renewcommand{\arraystretch}{1}%"  _n
	"\begin{tabular}{llcc}"  _n
	"\hline\noalign{\smallskip}"  _n
	"\hspace{7pt} \bf Task \hspace{7pt} & \bf Treatment & \bf Breaks in & \bf Breaks in \\"  _n
	"	 	  & 		  	  & \bf Period 1  & \bf Period 2 \\"  _n
	"\hline"  _n
	"\noalign{\smallskip}" _n
	"`Simple_Control_line'" _n
	"`Simple_Gift_line'" _n
	"`Simple_Tournament_line'" _n
	"`Creative_Control_line'" _n
	"`Creative_Gift_line'" _n
	"`Creative_Tournament_line'" _n
	"\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{\textwidth} $footnote_params" _n
	"\footnotesize NOTE.--This table reports the average number of breaks by task, treatment, and period. "  _n
	"$breaks_description " _n
	"$treatment_description " _n
	"$sample_description_nonreg " _n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}";
#delimit cr
file close f

restore

	
preserve
keep if (treatment == 1 | treatment == 2 | treatment == 3)

foreach task in slider creative{
	foreach var in effort time{
		forvalues i = 1/2{ //periods 1 and 2
			foreach treat in Tournament Gift Control {
				if("`treat'" == "Tournament") 	local prefix t
				if("`treat'" == "Gift")			local prefix g
				if("`treat'" == "Control") 		local prefix c
				
				sum `var'`i' if Treatment == "`treat'" & `task' == 1
				local `task'_`prefix'_`i'_`var' = r(mean)
				di ``task'_`prefix'_`i'_`var''
			}
		}
	}
}

clear
set obs 3


gen Treatment = ""
replace Treatment = "Performance Bonus" in 1
replace Treatment = "Gift" in 2
replace Treatment = "Control" in 3

local vars slider_effort1 slider_time1 slider_effort2 slider_time2 creative_effort1 creative_time1 creative_effort2 creative_time2

foreach var in `vars'{
	gen `var' = missing()
}

foreach task in slider creative{
	foreach var in effort time{
		forvalues i = 1/2{
			foreach treat in t g c{
				if("`treat'" == "t") local row = 1
				if("`treat'" == "g") local row = 2
				if("`treat'" == "c") local row = 3
				replace `task'_`var'`i' = ``task'_`treat'_`i'_`var'' in `row'
			}
		}
	}
}
format *effort* *time* %9.2f
list

//calculate output/time for all 
foreach task in slider creative{
	foreach treat in t g c{
		forvalues i = 1/2{
			local `task'_`treat'_`i'_opt = ``task'_`treat'_`i'_effort' / ``task'_`treat'_`i'_time'
		}
	}
}


//calculate differences period 2 - period 1 for all 
foreach task in slider creative{
	foreach treat in t g c{
		foreach var in opt effort time {
			local `task'_`treat'_dif_`var' = ``task'_`treat'_2_`var'' - ``task'_`treat'_1_`var''
		}
	}
}

//calculate the log ratio
foreach task in slider creative{
	foreach var in opt effort time {
		foreach time in 1 2 dif {
			//treatment ratio
			local `task'_tratio_`time'_`var' = log(``task'_t_`time'_`var'') - log(``task'_c_`time'_`var'')
			local `task'_tratio_`time'_`var' ``task'_tratio_`time'_`var'' //add \% here if needed
			
			//gift ratio
			local `task'_gratio_`time'_`var' = log(``task'_g_`time'_`var'') - log(``task'_c_`time'_`var'')
			local `task'_gratio_`time'_`var' ``task'_gratio_`time'_`var'' //add \% here if needed
			
		}
	}
}

//round everything
foreach task in slider creative{
	foreach treat in t g c{
		foreach var in opt effort time{
			foreach time in 1 2 dif{
				local `task'_`treat'_`time'_`var' = ``task'_`treat'_`time'_`var''
			}
		}
	}
}

//variable name headers
local combined_headers1 \bf Treatment & \bf \hspace{5pt} Average \hspace{5pt} & \bf Time Worked &  \hspace{5pt} \bf Output per Second  \hspace{5pt} && \bf  \hspace{5pt} Average \hspace{5pt} & \bf Time Worked & \bf  \hspace{5pt} Output per Second \hspace{5pt} \\
local combined_headers2 		& \bf Output & \bf (out of 180s) & \bf of Time Worked & & \bf Output & \bf (out of 180s) & \bf of Time Worked \\
local p2_headers \bf Treatment & \bf Output Period 2 & \bf Time Worked Period 2 & \bf Output per Time Worked && \bf Output Period 2 & \bf Time Worked Period 2 & \bf Output per Time Worked \\
local p1_headers \bf Treatment & \bf Output Period 1 & \bf Time Worked Period 1 & \bf Output per Time Worked && \bf Output Period 1 & \bf Time Worked Period 1 & \bf Output per Time Worked \\
local dd_headers1 \bf Treatment & \bf Difference in & \bf Difference in & \bf Difference in 		 && \bf Difference in & \bf Difference in & \bf Difference in 		 \\
local dd_headers2  			& \bf Output 		& \bf Time Worked 	& \bf Output per Time Worked && \bf Output 		& \bf Time Worked 	& \bf Output per Time Worked \\

//simple/creative headers
local task_header & \multicolumn{3}{c}{\bf Simple Task} & & \multicolumn{3}{c}{\bf Creative Task} \\ \cline{2-4} \cline{6-8}

local format %9.2f
//data rows
foreach time in 1 2 dif  {
	foreach treat in t g c tratio gratio{
		if("`treat'" == "t") local treat_str Performance Bonus
		if("`treat'" == "g") local treat_str Gift
		if("`treat'" == "c") local treat_str Control
		if("`treat'" == "tratio") local treat_str Performance Bonus
		if("`treat'" == "gratio") local treat_str Gift
		
		if("`treat'" == "c") local space \vspace{5pt}
		if("`treat'" != "c") local space 
		
		local p`time'_`treat'_row "`treat_str' &" `format' (`slider_`treat'_`time'_effort') " &" `format' ( `slider_`treat'_`time'_time') " &" `format' ( `slider_`treat'_`time'_opt') "&&" `format' ( `creative_`treat'_`time'_effort') "&" `format' ( `creative_`treat'_`time'_time') "&" `format' ( `creative_`treat'_`time'_opt') " `space' \\ "
	}
}

//combined table, just period 2, both treatments
cap file close f
file open f using "$mypath/Tables/Output/Appendix/TableA7_Breaks_Raw_Combined.tex", write replace
#delimit; 
file write f 
	"\begin{landscape}" _n
	"\begin{table}[h]%" _n
	"\setlength\tabcolsep{2pt}" _n
	"\caption{Descriptive Statistics on Raw Output and Breaks Taken in Period 2}" _n
	"\label{tab:BreaksBreakdown}" _n
	"\begin{center}%" _n
	"{\small\renewcommand{\arraystretch}{1}%" _n
	"\begin{tabular}{lccccccc}" _n
	"\hline\noalign{\smallskip}" _n
	"`task_header'" _n
	"`combined_headers1'" _n
	"`combined_headers2'" _n
	"\midrule" _n
	"`p2_t_row'" _n
	"`p2_g_row'" _n
	"`p2_c_row'" _n
	" \multicolumn{3}{l}{\textit{Log Difference}} \\" _n
	"\hspace{10pt} `p2_tratio_row'" _n
	"\hspace{10pt} `p2_gratio_row'" _n
	"\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{1.2\textwidth} $footnote_params" _n
	"\footnotesize NOTE.--This table reports raw, unstandardized, average output, time spent working, and output per second of time worked. " _n 
	"\textit{Average output} refers to the number of correctly positioned sliders in the simple task and to the creativity score in the creative task (please refer to Section $creative_score_section for a description of the scoring procedure in the creative task). " _n
	"\textit{Time worked} is the total time (180 seconds) less the number of breaks times the length of breaks (20 seconds). " _n
	"\textit{Output per second of time worked} is the ratio of those two quantities. " _n
	"$breaks_description " _n
	"\textit{Log difference} is the log of the treatment group statistic less the log of the \textit{Control} group statistic. Log differences provide a sense of relative effect sizes. " _n
	"Numbers may not add up due to rounding. " _n
	"For simplicity, this analysis ignores differences in Period 1 output. " _n
	"$treatment_description " _n
	"$sample_description "_n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}" _n
	"\end{landscape}";
#delimit cr
file close f 

restore

