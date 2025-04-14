cls
clear
set more off

cd "$data"
use "Clean and controlls.dta"

merge 1:1 pid syear using "SC_sum.dta"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     3,896,559
        from master                         0  (_merge==1)
        from using                  3,896,559  (_merge==2)

    Matched                            84,967  (_merge==3)
    -----------------------------------------
*/
drop _merge
cd "$data"
save "FINAL.dta", replace

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 share_y5 ib2.senior_quartile##c.SC_w ib2.young_quartile##c.SC_w || district: || hid: ||  pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 share_y5 ib2.senior_quartile##c.SC_w ib2.young_quartile##c.SC_w  || district: || hid: ||  pid: , mle stddeviations 
/*
*With SC sum score in t
mixed pcs pcs_6 age sex sum_SC i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_median##i.age65 || district: || pid: , mle stddeviations

mixed mcs mcs_6 age sex sum_SC i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_median##i.age65 || district: || pid: , mle stddeviations

*

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_median##c.sum_SC|| district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_median##c.sum_SC|| district: || pid: , mle stddeviations

*

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_75##c.sum_SC|| district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_75##c.sum_SC|| district: || pid: , mle stddeviations

*

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_75 c.sum_SC|| district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_75 c.sum_SC|| district: || pid: , mle stddeviations

*

mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile c.share_sen5##c.sum_SC i.dummy_senior_median || district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile c.share_sen5##c.sum_SC i.dummy_senior_median || district: || pid: , mle stddeviations

*With Dummy quartile

*sum_SC
*With interaction
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile ib3.senior_quartile##c.sum_SC || district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile ib3.senior_quartile##c.sum_SC || district: || pid: , mle stddeviations

*Without interaction
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile ib2.senior_quartile c.sum_SC || district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile ib2.senior_quartile c.sum_SC || district: || pid: , mle stddeviations

*SC_6
*With interaction
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile ib3.senior_quartile##c.SC_6 || district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile ib3.senior_quartile##c.SC_6 || district: || pid: , mle stddeviations

*Without interaction
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile ib2.senior_quartile c.SC_6 || district: || pid: , mle stddeviations

mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile ib2.senior_quartile c.SC_6 || district: || pid: , mle stddeviations*/
