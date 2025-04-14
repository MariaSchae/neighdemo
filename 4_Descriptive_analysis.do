cls
clear
set more off

cd "$data"
use "INKAR_1995_2020.dta"
keep district Raumeinheit syear change_sen_5 change_y_5
keep if syear==2019 | syear==2017 | syear==2015 | syear==2013 | syear==2011 | syear==2009 | syear==2007 
recode syear (2019=2020) 
recode syear (2017=2018) 
recode syear (2015=2016) 
recode syear (2013=2014) 
recode syear (2011=2012) 
recode syear (2009=2010) 
recode syear (2007=2008) 

rename change_sen_5 change_sen_5s
rename change_y_5 change_y_5s
rename Raumeinheit city

xtile senior_quartile=change_sen_5s if (syear==2020 | syear==2018 | syear==2016 | syear==2014 |syear==2012 | syear==2010 | syear==2008) , nq(4)
codebook senior_quartile

xtile senior_tercile=change_sen_5s if (syear==2020 | syear==2018 | syear==2016 | syear==2014 |syear==2012 | syear==2010 | syear==2008) , nq(3)
codebook senior_tercile

xtile young_quartile=change_y_5s if (syear==2020 | syear==2018 | syear==2016 | syear==2014 |syear==2012 | syear==2010 | syear==2008), nq(4)
codebook young_quartile

xtile young_tercile=change_y_5s if (syear==2020 | syear==2018 | syear==2016 | syear==2014 |syear==2012 | syear==2010 | syear==2008), nq(3)
codebook young_tercile

tempfile INKAR_change_sen
save `INKAR_change_sen'

cd "$data"
use "INKAR_1995_2020.dta"
keep district Raumeinheit syear senior young
keep if syear==2014 | syear==2012 | syear==2010 | syear==2008 | syear==2006 | syear==2004 | syear==2002
recode syear (2014=2020) 
recode syear (2012=2018) 
recode syear (2010=2016) 
recode syear (2008=2014) 
recode syear (2006=2012) 
recode syear (2004=2010) 
recode syear (2002=2008) 

rename senior share_sen5
rename young share_y5
rename Raumeinheit city
tempfile INKAR_share_sen
save `INKAR_share_sen'

use "Clean_INKAR_regionl_ppathl_health.dta"
keep pid hid syear district city edu real_hh_income unemploy regtyp income_quintile A_Level totalbypid2014 totalbypid1812 totalbypid1610 totalbypid1408 totalbypid1206 totalbypid1004 totalbypid0802 sex age mcs pcs mcs_6 pcs_6

merge m:1 district syear using `INKAR_change_sen'
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       496,059
        from master                   496,051  (_merge==1)
        from using                          8  (_merge==2)

    Matched                           172,106  (_merge==3)
    -----------------------------------------
*/
sort _merge
keep if _merge==3
drop _merge
tempfile SOEP_INKAR_change_sen
save `SOEP_INKAR_change_sen' 

merge m:1 district syear using `INKAR_share_sen'
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                             8
        from master                         0  (_merge==1)
        from using                          8  (_merge==2)

    Matched                           172,107  (_merge==3)
    -----------------------------------------
*/
sort _merge
keep if _merge==3
drop _merge

drop if totalbypid2014==. & totalbypid1812==. &  totalbypid1610==. &  totalbypid1408==. &  totalbypid1206==. &  totalbypid1004==. &  totalbypid0802==. 

drop if totalbypid2014<3 & syear==2020 
drop if totalbypid1812<3 & syear==2018 
drop if totalbypid1610<3 & syear==2016 
drop if totalbypid1408<3 & syear==2014 
drop if totalbypid1206<3 & syear==2012 
drop if totalbypid1004<3 & syear==2010 
drop if totalbypid0802<3 & syear==2008

drop if totalbypid2014==. & syear==2020 
drop if totalbypid1812==. & syear==2018 
drop if totalbypid1610==. & syear==2016 
drop if totalbypid1408==. & syear==2014 
drop if totalbypid1206==. & syear==2012 
drop if totalbypid1004==. & syear==2010 
drop if totalbypid0802==. & syear==2008

tab totalbypid2014 if syear==2020, m
tab totalbypid1812 if syear==2018, m
tab totalbypid1610 if syear==2016, m
tab totalbypid1408 if syear==2014, m
tab totalbypid1206 if syear==2012, m
tab totalbypid1004 if syear==2010, m
tab totalbypid0802 if syear==2008, m

drop total*

/*
*Above/below median
*2020
sum change_sen_5s if syear==2020, det //linkssteil=0,034
return list //r(p50)=.81
gen dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2020
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2020
*2018
sum change_sen_5s if syear==2018, det //rechtssteil=0,033
return list //r(p50)=.82 
replace dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2018
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2018
*2016
sum change_sen_5s if syear==2016, det //rechtssteil=0,065
return list //r(p50)=.61
replace dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2016
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2016
*2014
sum change_sen_5s if syear==2014, det //rechtssteil=0,06
return list //r(p50)=.61
replace dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2014
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2014
*2012
sum change_sen_5s if syear==2012, det //linkssteil=0,019
return list //r(p50)=.98
replace dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2012
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2012
*2010
sum change_sen_5s if syear==2010, det //linkssteil=0,14
return list //r(p50)=2.07
replace dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2010
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2010
*2008
sum change_sen_5s if syear==2008, det //linkssteil=0,117
return list //r(p50)=2.64
replace dummy_senior_median=1 if change_sen_5s>=`r(p50)' & change_sen_5s!=. & syear==2008
replace dummy_senior_median=0 if change_sen_5s <`r(p50)' & change_sen_5s!=. & syear==2008

lab var dummy_senior_median "Dummy_Median: Change of seniors"
lab val dummy_senior_median dummy_senior_median 
lab def dummy_senior_median  0 "Under median" 1 "Over median", modify
tab dummy_senior_median, m

/*      
      Dummy: |
   change of |
     seniors |
 above/below |
      median |      Freq.     Percent        Cum.
-------------+-----------------------------------
Below median |     42,025       49.46       49.46
Above median |     42,942       50.54      100.00
-------------+-----------------------------------
       Total |     84,967      100.00
*/

*Above/below 75th percentile
*2020
sum change_sen_5s if syear==2020, det //linkssteil=0,034
return list 
gen dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2020
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2020
*2018
sum change_sen_5s if syear==2018, det //rechtssteil=0,033
return list  
replace dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2018
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2018
*2016
sum change_sen_5s if syear==2016, det //rechtssteil=0,065
return list 
replace dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2016
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2016
*2014
sum change_sen_5s if syear==2014, det //rechtssteil=0,06
return list
replace dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2014
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2014
*2012
sum change_sen_5s if syear==2012, det //linkssteil=0,019
return list 
replace dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2012
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2012
*2010
sum change_sen_5s if syear==2010, det //linkssteil=0,14
return list 
replace dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2010
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2010
*2008
sum change_sen_5s if syear==2008, det //linkssteil=0,117
return list 
replace dummy_senior_75=1 if change_sen_5s>=`r(p75)' & change_sen_5s!=. & syear==2008
replace dummy_senior_75=0 if change_sen_5s <`r(p75)' & change_sen_5s!=. & syear==2008

lab var dummy_senior_75 "Dummy: change of seniors above/below median"
lab val dummy_senior_75 dummy_senior_75 
lab def dummy_senior_75  0 "Below 75" 1 "Above 75", modify
tab dummy_senior_75, m

*Above/below median for <26 years
*2020
sum change_y_5s if syear==2020, det 
return list //r(p50)=.81
gen dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2020
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2020
*2018
sum change_y_5s if syear==2018, det 
return list //r(p50)=.82 
replace dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2018
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2018
*2016
sum change_y_5s if syear==2016, det 
return list //r(p50)=.61
replace dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2016
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2016
*2014
sum change_y_5s if syear==2014, det 
return list //r(p50)=.61
replace dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2014
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2014
*2012
sum change_y_5s if syear==2012, det 
return list //r(p50)=.98
replace dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2012
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2012
*2010
sum change_y_5s if syear==2010, det 
return list //r(p50)=2.07
replace dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2010
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2010
*2008
sum change_y_5s if syear==2008, det 
return list //r(p50)=2.64
replace dummy_y_median=1 if change_y_5s>=`r(p50)' & change_y_5s!=. & syear==2008
replace dummy_y_median=0 if change_y_5s <`r(p50)' & change_y_5s!=. & syear==2008

lab var dummy_y_median "Dummy_Median: Change of youngs"
lab val dummy_y_median dummy_y_median 
lab def dummy_y_median  0 "Under median" 1 "Over median", modify
tab dummy_y_median, m

*Analyses (for dummy_senior_median)
***********************************

mixed pcs pcs_6 sex age share_sen5 dummy_senior_median || district: || pid: , mle stddeviations
mixed mcs mcs_6 sex age share_sen5 dummy_senior_median || district: || pid: , mle stddeviations
mdesc

gen age65=1 if age>=65 & age!=.
replace age65=0 if age<65 & age!=.
lab val age65 age65 
lab var age65 "Dummy: younger/older than 65"
lab def age65 0 "Under 65" 1 "Over 65", modify

mixed pcs pcs_6 age sex share_sen5 i.dummy_senior_median##i.age65 || district: || pid: , mle stddeviations
mixed mcs mcs_6 age sex share_sen5 i.dummy_senior_median##i.age65 || district: || pid: , mle stddeviations
mdesc
*/

/*
*Model With A_Level & hh_income
mixed pcs pcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_median##i.age65 || district: || pid: , mle stddeviations
mixed mcs mcs_6 age sex i.A_Level ib2.income_quintile share_sen5 i.dummy_senior_median##i.age65 || district: || pid: , mle stddeviations
mdesc
*/

gen age_group=1 if age<25 & age!=.
replace age_group=2 if (age>24 & age<65) & age!=.
replace age_group=3 if age>64 & age!=.
tab age if age_group==1
tab age if age_group==2
tab age if age_group==3
tempfile clean_and_controlls
save `clean_and_controlls'

import delimited "/home/lwc-mschaefer/work/Project 1/5_Raw_Data/bstacherl-soep_v36_hh_export-indicators_2SFCAD_v37.csv", numericcols(4 5) clear
mdesc 
sum _all

merge 1:m hid syear using `clean_and_controlls'
sort _merge 
drop if _merge==1
drop _merge

cd "$data"
save "Clean and controlls.dta", replace
