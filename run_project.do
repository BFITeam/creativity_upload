 
 
global mypath = "C:\Users\gtierney\Google Drive\final version April 2018\data"

//build dataset
do "$mypath/Overview_Aufbereitet.do"

//make tables
do "$mypath/Tables/run_tables.do"

//make figures
do "$mypath/Figures/run_figures.do"

//run R code 
/* 	run file run_project_r_code
	
	Requires the following libraries to be installed:
		require(foreign)
		require(reshape)
		require(plyr)
		require(sandwich)
		require(lmtest)
		require(car)
		require(plm)
		require(np)
		require(quantreg)
		require(lme4)
		require(coin)
*/

