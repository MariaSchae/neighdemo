************************************************
** INKAR Do-File
** Author: Maria Schäfer
************************************************

clear all
cap log close
set more off, perm
set maxvar 5090
cls

//INKAR 2020
*Import xls
cd "$raw"
import excel "inkar.xls", sheet("Daten") firstrow clear

*Rename variables 
rename Kennziffer district 
rename Einwohnerunter6Jahre u6 
rename Einwohnervon6bisunter18Jah a6u18 
rename Einwohnervon18bisunter25Ja a18u25 
rename Einwohnervon25bisunter30Ja a25u30 
rename Einwohnervon30bisunter50Ja a30u50 
rename Einwohnervon50bisunter65Ja a50u65 
rename Einwohner65Jahreundälter a65 
rename Einwohner75Jahreundälter a75
rename WeiblicheEinwohner75Jahreund Wa75 
rename WeiblicheEinwohnervon18bisu Wa18u25 
rename WeiblicheEinwohnervon25bisu Wa25u30 
rename WeiblicheEinwohner65Jahreund Wa65 
rename Einwohnervon65bisunter75Ja a65u75 
rename WeiblicheEinwohnervon65bisu Wa65u75 
rename Einwohnervon75bisunter85Ja a75u85 
rename Einwohner85Jahreundälter a85 
rename WeiblicheEinwohnervon75bisu Wa75u85 
rename WeiblicheEinwohner85Jahreund Wa85 
rename Einwohnerunter3Jahren u3 
rename Einwohnervon3bisunter6Jahr a3u6 
rename DurchschnittsalterderBevölkeru avage 

gen syear=2020
*Drop first row
drop if _n==1
destring district u6 a6u18 a18u25 a30u50 a50u65 a65 a75 Wa75 Wa18u25 Wa25u30 Wa65 a65u75 Wa65u75 a75u85 a85 Wa75u85 Wa85 u3 a3u6 avage a25u30, replace

gen child=u6+a6u18
gen young=a18u25 
gen adult=a18u25+a25u30+a30u50+a50u65
gen senior=a65
gen totalcontrol=child+adult+senior
tempfile INKAR_2020
save `INKAR_2020.dta'

*Prepare INKAR data of 1995-2019 for merge
cd "$raw"
use "Kreis_Difference_Age_Distributions.dta", clear
destring district, replace
gen young=a18u25 
tempfile INKAR_1995_2019
save `INKAR_1995_2019'

*Append 2020 INKAR data to 1995-2019 INKAR data
append using `INKAR_2020.dta'
*Adapt form of numbers
format %9.6f u6 a6u18 a18u25 a25u30 a30u50 a50u65 a65 a75 Wa75 Wa18u25 Wa25u30 Wa65 a65u75

//Correct change between 2020 and 1995 for children, adults and seniors
sort district syear
*Children
by district: replace change_chi=child[_N]-child[1]
*Young adults
by district: gen change_y=young[_N]-young[1]
*Adults
by district: replace change_adu=adult[_N]-adult[1]
*Seniors
by district: replace change_sen=senior[_N]-senior[1]

//Change in age structure

*Children
sort district syear
by district: replace change_chi_1=child[_n]-child[_n-1]
by district: replace change_chi_2=child[_n]-child[_n-2]
by district: replace change_chi_5=child[_n]-child[_n-5]

*Young adults
sort district syear
by district: gen change_y_1=young[_n]-young[_n-1]
by district: gen change_y_2=young[_n]-young[_n-2]
by district: gen change_y_5=young[_n]-young[_n-5]

*Adults
sort district syear
by district: replace change_adu_1=adult[_n]-adult[_n-1]
by district: replace change_adu_2=adult[_n]-adult[_n-2]
by district: replace change_adu_5=adult[_n]-adult[_n-5]

*Seniors
sort district syear
by district: replace change_sen_1=senior[_n]-senior[_n-1]
by district: replace change_sen_2=senior[_n]-senior[_n-2]
by district: replace change_sen_5=senior[_n]-senior[_n-5]

form %3.2f u6 a6u18 a18u25 a25u30 a30u50 a50u65 a65 a75 Wa75 Wa18u25 Wa25u30 Wa65 a65u75 Wa65u75 a75u85 a85 Wa75u85 Wa85 u3 a3u6 avage child adult senior totalcontrol change_chi change_adu change_sen change_chi_1 change_chi_2 change_chi_5 change_adu_1 change_adu_2 change_adu_5 change_sen_1 change_sen_2 change_sen_5

drop u6 a6u18 a18u25 a25u30 a30u50 a50u65 a65 a75 Wa75 Wa18u25 Wa25u30 Wa65 a65u75 Wa65u75 a75u85 a85 Wa75u85 Wa85 u3 a3u6 avage child adult totalcontrol change_chi change_adu change_chi_1 change_chi_2 change_chi_5 change_adu_1 change_adu_2 change_adu_5

cd "$data"
save "INKAR_1995_2020.dta", replace

************************************************
** Prepare regionl and ppathl for merge
** Author: Maria Schäfer
************************************************

*Prepare regionl dataset
cd "$SOEP"
use hid syear kkz_rek regtyp using "regionl.dta", clear
*Check for missing values
mdesc
*Check for negative values of hid and syear
sum hid
sum syear

sum regtyp
levelsof regtyp if regtyp<0
recode regtyp (-1=.) //16,567 changes made
tab regtyp
recode regtyp (2=0)
lab val regtyp regtyp
lab def regtyp 0 "rural" 1 "urban", modify

//No missing values and no negative values for hid and syea
*Check for negative values of kkz_rek
sum kkz_rek //There are negative values 
levelsof kkz_rek if kkz_rek<0
recode kkz_rek (-1 -2=.) //16,402 changes made
*Check identifier
isid hid syear //variables uniquely identify the obs.
tempfile adapted_regionl
save `adapted_regionl'

*Prepare ppathl dataset (to get the pid)
cd "$SOEP"
use hid pid syear sex gebjahr piyear using "ppathl.dta", clear
*Check for missing values
mdesc
*Check for negative values of hid
sum hid
//There are negative values for hid --> check it
sum hid if hid<0
//There are 2,442 hid-obs. with a value equal to -3 or -2
drop if hid<0
//Drop all negative values for hid, since this is the key variable for the merge of regionl and ppathl
*Check for negative values of pid and syear
sum pid
sum syear
//No negative values for pid and syear
*Closer look on variable sex
tab sex,m
/*
                             Geschlecht |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                      [-3] nicht valide |         45        0.00        0.00
                      [-1] keine Angabe |        257        0.02        0.02
                          [1] maennlich |    633,435       49.39       49.41
                           [2] weiblich |    648,819       50.59      100.00
----------------------------------------+-----------------------------------
                                  Total |  1,282,556      100.00
*/
drop if sex==-3 | sex==-1 // 140 obs. deleted
*Dummy encoding of variable sex
tab sex
recode sex (1=0)(2=1)
lab val sex sex
lab def sex 0 "Male" 1 "Female", modify
tab sex
*Closer look on variable gebjahr
tab gebjahr
drop if gebjahr==-1 // 6,527 obs. deleted
*Generate variable age (see mail from Dr. Peter Krause 02nd March 2023)
sum piyear
gen diff=1 if piyear!=syear & piyear>0
replace diff=0 if piyear==syear
sort diff
tab diff,m 
/*
       diff |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |  1,220,447       95.64       95.64
          1 |     25,477        2.00       97.64
          . |     30,122        2.36      100.00
------------+-----------------------------------
      Total |  1,276,046      100.00
      
diff==. are those obs. wih pyear<0
*/
gen age=piyear-gebjahr if (piyear!=syear & piyear>0)
replace age=piyear-gebjahr if piyear==syear
replace age=syear-gebjahr if piyear<0
tab age, m
*Drop variable gebjahr, diff, piyear
drop gebjahr diff piyear
*Check identifier
isid pid syear //variables uniquely identify the obs.
tempfile adapted_ppathl
save `adapted_ppathl'

*Merge adapted_regionl with adapted_ppathl
merge m:1 hid syear using `adapted_regionl', gen(regionl_ppathl) 
drop if regionl_ppathl!=3 //..., since we have no values for kkz_rek or pid, sex and age; 
// 158,905 obs. deleted
drop regionl_ppathl
*Closer look
sort hid syear
tempfile regionl_ppathl
save `regionl_ppathl'

************************************************
** Merge INKAR with SOEP
** Author: Maria Schäfer
************************************************

use "$data/INKAR_1995_2020.dta", clear
*Rename district
rename district kkz_rek
*Check identifier
isid kkz_rek syear //variables uniquely identify the obs.
tempfile adapted_INKAR
save `adapted_INKAR.dta'

merge 1:m kkz_rek syear using `regionl_ppathl.dta'
/*Order variables
order hid pid syear kkz_rek Raumeinheit Aggregat sex age u6 a6u18 a18u25 a25u30 a30u50 a50u65 a65 a75 Wa75 Wa18u25 Wa25u30 Wa65 a65u75 Wa65u75 a75u85 a85 Wa75u85 Wa85 u3 a3u6 avage child adult senior totalcontrol change_chi change_adu change_sen change_chi_1 change_chi_2 change_chi_5 change_adu_1 change_adu_2 change_adu_5 change_sen_1 change_sen_2 change_sen_5 */
*Check the merge
sort _merge 
drop if _merge!=3 //192,196 obs. deleted
*Check and drop _merge
tab _merge
drop _merge
tempfile INKAR_regionl_pid
save `INKAR_regionl_pid'

************************************************
** Merge INKAR_regionl_pid.dta  with health.dta
** Author: Maria Schäfer
************************************************

*Prepare dataset health for merge
cd "$SOEP"
use "health.dta", clear
keep pid syear mcs pcs
*Closer look on variables pid syear
mdesc
sum pid
sum syear
// No missing and negative values for both variables
tempfile adapted_health
save `adapted_health'

merge 1:1 pid syear using `INKAR_regionl_pid'
sort _merge
keep if _merge==3 //since in case of _merge==1 we are missing data on age structure as well as the changes in age structure and in case of _merge==2 there is no data an mental and physical health
drop _merge

tempfile INKAR_regionl_pid 
save `INKAR_regionl_pid'

**Education
		
**PGEN (School-leaving Degree + Degree)
cd "$SOEP"
use "pgen.dta", clear
label language EN
keep pid syear pgpsbil pgpbbil02
sum _all

*School-leaving Degree
replace pgpsbil=. if pgpsbil<0
rename pgpsbil edu
codebook edu

*Variable pgpbbil02: Degree
levelsof pgpbbil02
replace pgpbbil02=. if pgpbbil02<0
codebook pgpbbil02
recode pgpbbil02 (2=1)
recode pgpbbil02 (3=1)
recode pgpbbil02 (4=1)
recode pgpbbil02 (5=1)
recode pgpbbil02 (6=1)
recode pgpbbil02 (7=1)
recode pgpbbil02 (9=1)
recode pgpbbil02 (10=1)
lab val pgpbbil02 pgpbbil02
lab def pgpbbil02 1 "University" , modify
rename pgpbbil02 Degree1

mdesc
sum _all

tempfile pgen
save `pgen'

merge 1:1 pid syear using `INKAR_regionl_pid'

	drop _merge
	tempfile edu
	save `edu'

**PL (Degree)
cd "$SOEP"
use "pl.dta"
label language EN
keep pid syear hid plg0079* 
sum _all

*Variables plg0079*: What type of a degree /certificate / diploma did you obtain? 

*v1
codebook plg0079_v1
levelsof plg0079_v1
lab val plg0079_v1 plg0079_v1

recode plg0079_v1 (-8/-1=.) 
recode plg0079_v1 (2=1)
lab def plg0079_v1 1 "University", modify

*v2
codebook plg0079_v2
levelsof plg0079_v2
lab val plg0079_v2 plg0079_v2

recode plg0079_v2 (-8/-1=.) 
recode plg0079_v2 (2=1) (3=1)
lab def plg0079_v2 1 "University", modify

*v3
codebook plg0079_v3
levelsof plg0079_v3
lab val plg0079_v3 plg0079_v3

recode plg0079_v3 (-8/-1=.)
recode plg0079_v3 (2=1) (3=1) (4=1) (5=1)
lab def plg0079_v3 1 "University", modify

*v4
codebook plg0079_v4
levelsof plg0079_v4
lab val plg0079_v4 plg0079_v4

recode plg0079_v4 (-8/-1=.)  
recode plg0079_v4 (2/5=1) 
lab def plg0079_v4 1 "University", modify

replace plg0079_v1=plg0079_v2 if plg0079_v1==. & plg0079_v2!=.
replace plg0079_v1=plg0079_v3 if plg0079_v1==. & plg0079_v3!=.
replace plg0079_v1=plg0079_v4 if plg0079_v1==. & plg0079_v4!=.
drop plg0079_v2 plg0079_v3 plg0079_v4 
rename plg0079_v1 Degree2

mdesc
sum _all

tempfile pl
save `pl'

merge 1:1 pid syear using `edu'
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       324,601
        from master                         0  (_merge==1)
        from using                    324,601  (_merge==2)

    Matched                           742,822  (_merge==3)
    -----------------------------------------
*/
	drop _merge	

*Clean education and age variables
levelsof Degree1 
levelsof Degree2
replace Degree1=Degree2 if Degree1==. & Degree2!=.
drop Degree2

codebook edu
replace edu=9 if edu==. & Degree1!=.
lab val edu edu
lab def edu 1 "Secondary School Degree" 2 "Intermediate School Degree" 3 "Technical School Degree" 4 "Upper Secondary Degree" 5 "Other Degree" 6 "Dropout, No School Degree" 7 "No School Degree Yet" 8 "No School Attended" 9 "University Degree or more", modify
drop Degree1


	*Generate a variable which indicates if you have an A-level degree
	gen A_Level=2 if edu==3 | edu==4 | edu==9
	replace A_Level=1 if edu==1 | edu==2 | edu==6 | edu==8
	replace A_Level=3 if edu==5 | edu==7
	lab val A_Level A_Level
	lab def A_Level 1 "less than A-Level" 2 "A-Level or equivalent/more" 3 "Unspecified", modify
	lab var A_Level "A-Level degree?"

cd "$data"
save "INKAR+regionl+ppathl+health_pre.dta", replace
