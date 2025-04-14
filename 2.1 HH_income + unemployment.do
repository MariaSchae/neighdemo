***************************************
** Household income & unemployment rate
** Author: Maria Schäfer
***************************************

**Prepare regionl dataset

cd "$SOEP"
use syear kkz_rek using "regionl.dta", clear
*Check for missing values
mdesc
*Check for negative values of hid and syear
sum syear
//No missing values and no negative values for syear
*Check for negative values of kkz_rek
sum kkz_rek //There are negative values 
levelsof kkz_rek if kkz_rek<0
recode kkz_rek (-1 -2=.) //16,402 changes made
tempfile adapted_regionl
save `adapted_regionl'

**Household income + unemployment rate taken from INKAR

cd "$raw"
import excel "household income.xls", sheet("Daten") firstrow clear
rename Kennziffer kkz_rek
drop Raumeinheit 

rename Arbeitslosenquote unemploy1998
rename D unemploy1999
rename E unemploy2000
rename F unemploy2001
rename G unemploy2002
rename H unemploy2003
rename I unemploy2004
rename J unemploy2005
rename K unemploy2006
rename L unemploy2007
rename M unemploy2008
rename N unemploy2009
rename O unemploy2010
rename P unemploy2011
rename Q unemploy2012
rename R unemploy2013
rename S unemploy2014
rename T unemploy2015
rename U unemploy2016
rename V unemploy2017
rename W unemploy2018
rename X unemploy2019
rename Y unemploy2020

rename Haushaltseinkommen hh_income2000
rename AA hh_income2001
rename AB hh_income2002
rename AC hh_income2003
rename AD hh_income2004
rename AE hh_income2005
rename AF hh_income2006
rename AG hh_income2007
rename AH hh_income2008
rename AI hh_income2009
rename AJ hh_income2010
rename AK hh_income2011
rename AL hh_income2012
rename AM hh_income2013
rename AN hh_income2014
rename AO hh_income2015
rename AP hh_income2016
rename AQ hh_income2017
rename AR hh_income2018
rename AS hh_income2019

drop if _n==1
reshape long unemploy hh_income, i(kkz_rek) j(syear)
destring kkz_rek unemploy hh_income, replace
tempfile hhincome
save `hhincome'

merge 1:m kkz_rek syear using `adapted_regionl'
drop _merge
sort kkz_rek syear
drop if unemploy==. & hh_income==.
bys kkz_rek syear: gen group=_n
keep if group==1
drop group
tempfile close_final
save `close_final'

*Prepare the Consumer Price Index

cd "$SOEP"
use "pequiv.dta", clear
label language EN
keep syear y1110

*Deflate earnings to the year 2008 using the German Consumer Price Index
*Inflation causes the purchasing power of money to decrease over time. By deflating earnings, you can compare income levels or wages across different time periods in a meaningful way. This allows you to account for the effects of inflation and assess changes in real income or wages over time accurately.
tab y11101,m
replace y11101=. if y11101==-2
gen CPI = y11101 if syear==2008
sort CPI
tab CPI,m
replace CPI=89.6 if CPI==.
bys syear: gen group=_n
keep if group==1
drop group

merge 1:m syear using `close_final'
drop _merge
drop if unemploy==. & hh_income==.

gen real_hh_income= hh_income * (CPI/y11101)
drop y11101 CPI hh_income

xtile income_quintile18=real_hh_income if syear==2018, nq(5)
xtile income_quintile16=real_hh_income if syear==2016, nq(5)
xtile income_quintile14=real_hh_income if syear==2014, nq(5)
xtile income_quintile12=real_hh_income if syear==2012, nq(5)
xtile income_quintile10=real_hh_income if syear==2010, nq(5)
xtile income_quintile08=real_hh_income if syear==2008, nq(5)

gen income_quintile=.
replace income_quintile=income_quintile18 if income_quintile==. & income_quintile18!=.
replace income_quintile=income_quintile16 if income_quintile==. & income_quintile16!=.
replace income_quintile=income_quintile14 if income_quintile==. & income_quintile14!=.
replace income_quintile=income_quintile12 if income_quintile==. & income_quintile12!=.
replace income_quintile=income_quintile10 if income_quintile==. & income_quintile10!=.
replace income_quintile=income_quintile08 if income_quintile==. & income_quintile08!=.
drop income_quintile0* income_quintile1*

cd "$data"
merg 1:m kkz_rek syear using "INKAR+regionl+ppathl+health_pre.dta"
drop if pid==.
drop _merge
cd "$data"
save "INKAR+regionl+ppathl+health.dta", replace
