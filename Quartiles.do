cls
clear
set more off

cd "$data"
log using "quartiles", replace
use "FINAL.dta"

//a. Simple models
*1q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile || district: || hid: ||  pid: , mle stddeviations
*2q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile || district: || hid: ||  pid: , mle stddeviations  
*3q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile share_y5 ib2.young_quartile || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile share_y5 ib2.young_quartile || district: || hid: ||  pid: , mle stddeviations 
*4q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile SC_6 || district: || hid: ||  pid: , mle stddeviations
*5q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile sum_SC || district: || hid: ||  pid: , mle stddeviations
*6q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile sum_SC || district: || hid: ||  pid: , mle stddeviations
*7q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile sum_SC || district: || hid: ||  pid: , mle stddeviations
*8q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile share_y5 ib2.young_quartile sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile share_y5 ib2.young_quartile sum_SC || district: || hid: ||  pid: , mle stddeviations 
*9q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile SC_6 || district: || hid: ||  pid: , mle stddeviations
*10q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile SC_6 || district: || hid: ||  pid: , mle stddeviations
*11q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile share_y5 ib2.young_quartile SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile share_y5 ib2.young_quartile SC_6 || district: || hid: ||  pid: , mle stddeviations 

****

//b. Two-way interactions
*12q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC || district: || hid: ||  pid: , mle stddeviations 
*13q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC || district: || hid: ||  pid: , mle stddeviations
*14q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC share_y5 ib2.young_quartile##c.sum_SC || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC share_y5 ib2.young_quartile##c.sum_SC || district: || hid: ||  pid: , mle stddeviations 
*15q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.SC_6 || district: || hid: ||  pid: , mle stddeviations 
*16q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.SC_6 || district: || hid: ||  pid: , mle stddeviations 
*17q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.SC_6  share_y5 ib2.young_quartile##c.SC_6 || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.SC_6  share_y5 ib2.young_quartile##c.SC_6 || district: || hid: ||  pid: , mle stddeviations

***

*c.Three-way interactions
*18q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.sex || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.sex || district: || hid: ||  pid: , mle stddeviations 
*19q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##i.sex || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##i.sex || district: || hid: ||  pid: , mle stddeviations
*20q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.sex share_y5 ib2.young_quartile##c.sum_SC##i.sex || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.sex share_y5 ib2.young_quartile##c.sum_SC##i.sex || district: || hid: ||  pid: , mle stddeviations 
*21q
mixed mcs mcs_6 sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.age_group || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.age_group  || district: || hid: ||  pid: , mle stddeviations 
*22q
mixed mcs mcs_6 sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##i.age_group  || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##i.age_group  || district: || hid: ||  pid: , mle stddeviations
*23q
mixed mcs mcs_6 sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.age_group  share_y5 ib2.young_quartile##c.sum_SC##i.age_group  || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.age_group  share_y5 ib2.young_quartile##c.sum_SC##i.age_group  || district: || hid: ||  pid: , mle stddeviations 
*24q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.regtyp || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.regtyp || district: || hid: ||  pid: , mle stddeviations 
*25q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##i.regtyp || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##i.regtyp || district: || hid: ||  pid: , mle stddeviations
*26q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.regtyp  share_y5 ib2.young_quartile##c.sum_SC##i.regtyp || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##i.regtyp  share_y5 ib2.young_quartile##c.sum_SC##i.regtyp || district: || hid: ||  pid: , mle stddeviations 

***

//d.
*27q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_S   fcad_10_hosp || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_10_hosp || district: || hid: ||  pid: , mle stddeviations 

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_3_haus || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_3_haus|| district: || hid: ||  pid: , mle stddeviations 
*28q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC   fcad_10_hosp || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC   fcad_10_hosp || district: || hid: ||  pid: , mle stddeviations

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC   fcad_3_haus || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC  fcad_3_haus|| district: || hid: ||  pid: , mle stddeviations 
*29q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_10_hosp share_y5 ib2.young_quartile##c.sum_SC  || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_10_hosp share_y5 ib2.young_quartile##c.sum_SC  || district: || hid: ||  pid: , mle stddeviations 

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_3_haus share_y5 ib2.young_quartile##c.sum_SC  || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   fcad_3_haus share_y5 ib2.young_quartile##c.sum_SC  || district: || hid: ||  pid: , mle stddeviations 
*30q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   unemploy || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   unemploy || district: || hid: ||  pid: , mle stddeviations 
*31q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC   unemploy || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC   unemploy || district: || hid: ||  pid: , mle stddeviations
*32q
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   unemploy   share_y5 ib2.young_quartile##c.sum_SC  || district: || hid: ||  pid: , mle stddeviations
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC   unemploy   share_y5 ib2.young_quartile##c.sum_SC  || district: || hid: ||  pid: , mle stddeviations 

log close
translate quartiles.smcl quartiles.pdf
