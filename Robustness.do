cls
clear
set more off

cd "$data"
log using "Without_categorization"
use "FINAL.dta"

*Seniors
gen two_change_sen_5s=change_sen_5s*change_sen_5s
gen three_change_sen_5s=change_sen_5s*two_change_sen_5s

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 c.change_sen_5s##c.sum_SC c.two_change_sen_5s##c.sum_SC c.three_change_sen_5s##c.sum_SC || district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 c.change_sen_5s##c.sum_SC c.two_change_sen_5s##c.sum_SC c.three_change_sen_5s##c.sum_SC || district: || hid: ||  pid: , mle stddeviations

*Young people
gen two_change_y_5s=change_y_5s*change_y_5s
gen three_change_y_5s=change_y_5s*two_change_y_5s

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 c.change_y_5s##c.sum_SC c.two_change_y_5s##c.sum_SC c.three_change_y_5s##c.sum_SC || district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 c.change_y_5s##c.sum_SC c.two_change_y_5s##c.sum_SC c.three_change_y_5s##c.sum_SC || district: || hid: ||  pid: , mle stddeviations

*Mixed
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 c.change_y_5s##c.sum_SC c.two_change_y_5s##c.sum_SC c.three_change_y_5s##c.sum_SC share_sen5 c.change_sen_5s##c.sum_SC c.two_change_sen_5s##c.sum_SC c.three_change_sen_5s##c.sum_SC || district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 c.change_y_5s##c.sum_SC c.two_change_y_5s##c.sum_SC c.three_change_y_5s##c.sum_SC share_sen5 c.change_sen_5s##c.sum_SC c.two_change_sen_5s##c.sum_SC c.three_change_sen_5s##c.sum_SC || district: || hid: ||  pid: , mle stddeviations

log close
translate Without_categorization.smcl Without_categorization.pdf

****************************************
log close
log using "three-way_unemploy", replace
use "FINAL.dta"

*30
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##c.unemploy || district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##c.unemploy || district: || hid: ||  pid: , mle stddeviations 

*31
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##c.unemploy || district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_y5 ib2.young_quartile##c.sum_SC##c.unemploy || district: || hid: ||  pid: , mle stddeviations

*32
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##c.unemploy share_y5 ib2.young_quartile##c.sum_SC##c.unemploy|| district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 ib2.senior_quartile##c.sum_SC##c.unemploy share_y5 ib2.young_quartile##c.sum_SC##c.unemploy  || district: || hid: ||  pid: , mle stddeviations 

log close
translate three-way_unemploy.smcl three-way_unemploy.pdf
