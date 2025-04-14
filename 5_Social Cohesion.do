************************************************
** Social cohesion
** Author: Maria Schäfer
************************************************

clear all
cap log close
set more off, perm
set maxvar 5090
cls

***
*PL
***

cd "$SOEP"
use pid syear pld0045 plh0111 plj0047 plj0043 plh0177 plh0156 using "pl.dta", replace
codebook _all

**
tab pld0045
replace pld0045=. if pld0045<1
tab pld0045, m
recode pld0045 (1=5) (2=4) (3=3) (4=2) (5=1)
rename pld0045 lockdoor
lab val lockdoor lockdoor
lab def lockdoor 1 "1 Nie" 2 "2 Selten" 3 "3 Manchmal" 4 "4 Oft" 5 "5 Sehr oft", modify
tab lockdoor, m

**
tab plh0111
replace plh0111=. if plh0111<1
tab plh0111, m
rename plh0111 polsoc
replace polsoc=(5-1)*((polsoc-1)/(4-1))+1
levelsof polsoc
lab val polsoc polsoc
lab def polsoc 1 "1 Sehr wichtig" 5 "5 Ganz unwichtig", modify
tab polsoc, m

**
tab plh0156
replace plh0156=. if plh0156<0
tab plh0156, m
gen satisarea=11 if plh0156==0
replace satisarea=10 if plh0156==1 & satisarea==.
replace satisarea=9 if plh0156==2 & satisarea==.
replace satisarea=8 if plh0156==3 & satisarea==.
replace satisarea=7 if plh0156==4 & satisarea==.
replace satisarea=6 if plh0156==5 & satisarea==.
replace satisarea=5 if plh0156==6 & satisarea==.
replace satisarea=4 if plh0156==7 & satisarea==.
replace satisarea=3 if plh0156==8 & satisarea==.
replace satisarea=2 if plh0156==9 & satisarea==.
replace satisarea=1 if plh0156==10 & satisarea==.
replace satisarea=(5-1)*((satisarea-1)/(11-1))+1
levelsof satisarea
lab val satisarea satisarea
lab def satisarea 1 "1 Sehr zufrieden" 3 "3 Mittel zufrieden" 5 "5 Sehr unzufrieden", modify
lab var satisarea "Zufriedenh. Wohngegend"
drop plh0156

**
tab plh0177
replace plh0177=. if plh0177<0
tab plh0177, m
gen satisdwell=11 if plh0177==0
replace satisdwell=10 if plh0177==1 & satisdwell==.
replace satisdwell=9 if plh0177==2 & satisdwell==.
replace satisdwell=8 if plh0177==3 & satisdwell==.
replace satisdwell=7 if plh0177==4 & satisdwell==.
replace satisdwell=6 if plh0177==5 & satisdwell==.
replace satisdwell=5 if plh0177==6 & satisdwell==.
replace satisdwell=4 if plh0177==7 & satisdwell==.
replace satisdwell=3 if plh0177==8 & satisdwell==.
replace satisdwell=2 if plh0177==9 & satisdwell==.
replace satisdwell=1 if plh0177==10 & satisdwell==.
replace satisdwell=(5-1)*((satisdwell-1)/(11-1))+1
levelsof satisdwell
lab val satisdwell satisdwell
lab def satisdwell 1 "1 Sehr zufrieden" 3 "3 Mittel zufrieden" 5 "5 Sehr unzufrieden", modify
lab var satisdwell "Zufriedenheit Wohnung"
drop plh0177

**
tab plj0047
replace plj0047=. if plj0047<1
tab plj0047, m
recode plj0047 (1=5) (2=3) (3=1)
rename plj0047 ausländer
lab val ausländer ausländer
lab def ausländer 5 "5 Große Sorgen" 3 "3 Einige Sorgen" 1 "1 Keine Sorgen", modify
tab ausländer, m

**
tab plj0043
replace plj0043=. if plj0043<1
tab plj0043, m
rename plj0043 tieslocal
replace tieslocal=(5-1)*((tieslocal-1)/(4-1))+1
levelsof tieslocal
lab val tieslocal tieslocal
lab def tieslocal 1 "1 Sehr stark" 5 "5 Eigentlich gar nicht", modify
tab tieslocal, m

cd "$data"
save "SC_PL.dta", replace

***
*HL
***

cd "$SOEP"
use hid syear hld0001 hld0002 hld0003 hlf0152 hlf0151 hlj0004_v1 hlj0004_v2 using "hl.dta", replace
codebook _all

**
replace hld0001=. if hld0001<1
tab hld0001, m
rename hld0001 relneigh
tab relneigh, m

**
replace hld0002=. if hld0002<1
tab hld0002, m
replace hld0003=. if hld0003<1
tab hld0003, m
 
gen test=0 if hld0002==1 & hld0003==. //There are 159 obs. where I know that there are visits of neighbors but a missing value for the frequencey of those visits
replace test=1 if hld0002==2 & hld0003!=.
tab test, m //test=0; For approx. 150 obs. I know that the hh was visiting their neighbors, but no information on the frequencey
replace hld0003=4 if hld0002==1 & hld0003==.  //According Odile if test=0 allocate to hld0003==4 (=seltener)
drop hld0002 test

clonevar freqneigh=hld0003
replace freqneigh=((5-1)*(hld0003-1)/(4-1))+1
levelsof freqneigh
lab val freqneigh freqneigh
lab def freqneigh 1 "1 Beinahe taeglich" 5 "5 Seltener", modify
tab freqneigh, m
drop hld0003

**
replace hlf0152=. if hlf0152<1 
tab hlf0152, m
recode hlf0152 (1=5)
recode hlf0152 (3=1)
recode hlf0152 (4=3)
recode hlf0152 (5=4)
lab val hlf0152 hlf0152
lab def hlf0152 4 "4 Kennen sich kaum" 3 "3 Unterschiedlich" 2 "2 Reden schon mal miteinander" 1 "1 Relativer enger Zusammenhalt", modify

gen interneigh=1 if hlf0152==4
replace interneigh=2 if hlf0152==3 & interneigh==.
replace interneigh=3 if hlf0152==2 & interneigh==.
replace interneigh=4 if hlf0152==1 & interneigh==.
replace interneigh=(5-1)*((hlf0152-1)/(4-1))+1 
levelsof interneigh
lab val interneigh interneigh
lab def interneigh 1 "1 Relativ enger Zusammenhalt"  5 " 5 Kennen sich kaum", modify
tab interneigh, m
lab var interneigh "Verhaeltnis d. Bewohner zueinander"
drop hlf0152

**
replace hlf0151=. if hlf0151<1
tab hlf0151, m

clonevar security=hlf0151
replace security=((5-1)*(hlf0151-1)/(4-1))+1
levelsof security
lab val security security
lab def security 1 "1 Sehr sicher" 5 "5 Sehr unsicher", modify
tab security, m
drop hlf0151

**
replace hlj0004_v1=. if hlj0004_v1<1
rename hlj0004_v1 immineigh_v1

replace hlj0004_v2=. if hlj0004_v2<1
rename hlj0004_v2 immineigh_v2

gen immineigh=1 if immineigh_v1==3 |immineigh_v2==6
replace immineigh=2 if immineigh_v1==4 & immineigh==.
replace immineigh=3 if immineigh_v2==5 & immineigh==.
replace immineigh=4 if immineigh_v1==2 & immineigh==.
replace immineigh=5 if immineigh_v2==4 & immineigh==.
replace immineigh=6 if immineigh_v2==3 & immineigh==.
replace immineigh=7 if immineigh_v1==1 & immineigh==.
replace immineigh=8 if immineigh_v2==2 & immineigh==.
replace immineigh=9 if immineigh_v2==1 & immineigh==.
tab immineigh
lab var immineigh "Leben auslaend. Familien im Wohngebiet"
replace immineigh=(5-1)*((immineigh-1)/(9-1))+1 
levelsof immineigh
lab val immineigh immineigh
lab def immineigh 1 "1 Keiner" 5 " 5 Alle", modify
drop immineigh_*

cd "$data"
save "SC_HL.dta", replace

************
*Extrapolate
************
***
*PL
***
cd "$data"
use "SC_PL.dta", clear
reshape wide lockdoor polsoc tieslocal ausländer satisarea satisdwell, i(pid) j(syear)

*lockdoor
*********
by pid: replace lockdoor2002=lockdoor2003 if lockdoor2003!=. & lockdoor2002==.

by pid: replace lockdoor2004=lockdoor2003 if lockdoor2003!=. & lockdoor2004==.
by pid: replace lockdoor2005=lockdoor2003 if lockdoor2003!=. & lockdoor2005==.
by pid: replace lockdoor2006=lockdoor2003 if lockdoor2003!=. & lockdoor2006==.

by pid: replace lockdoor2009=lockdoor2008 if lockdoor2008!=. & lockdoor2009==.
by pid: replace lockdoor2010=lockdoor2008 if lockdoor2008!=. & lockdoor2010==.
by pid: replace lockdoor2011=lockdoor2008 if lockdoor2008!=. & lockdoor2011==.

by pid: replace lockdoor2012=lockdoor2013 if lockdoor2013!=. & lockdoor2012==.

by pid: replace lockdoor2014=lockdoor2013 if lockdoor2013!=. & lockdoor2014==.
by pid: replace lockdoor2015=lockdoor2013 if lockdoor2013!=. & lockdoor2015==.
by pid: replace lockdoor2016=lockdoor2013 if lockdoor2013!=. & lockdoor2016==.

by pid: replace lockdoor2019=lockdoor2018 if lockdoor2018!=. & lockdoor2019==.
by pid: replace lockdoor2020=lockdoor2018 if lockdoor2018!=. & lockdoor2020==.
by pid: replace lockdoor2021=lockdoor2018 if lockdoor2018!=. & lockdoor2021==.

*polsoc
*********
by pid: replace polsoc2005=polsoc2004 if polsoc2004!=. & polsoc2005==.
by pid: replace polsoc2006=polsoc2004 if polsoc2004!=. & polsoc2006==.
by pid: replace polsoc2007=polsoc2004 if polsoc2004!=. & polsoc2007==.

by pid: replace polsoc2009=polsoc2008 if polsoc2008!=. & polsoc2009==.

by pid: replace polsoc2011=polsoc2010 if polsoc2010!=. & polsoc2011==.

by pid: replace polsoc2013=polsoc2012 if polsoc2012!=. & polsoc2013==.
by pid: replace polsoc2014=polsoc2012 if polsoc2012!=. & polsoc2014==.
by pid: replace polsoc2015=polsoc2012 if polsoc2012!=. & polsoc2015==.

by pid: replace polsoc2017=polsoc2016 if polsoc2016!=. & polsoc2017==.
by pid: replace polsoc2018=polsoc2016 if polsoc2016!=. & polsoc2018==.
by pid: replace polsoc2019=polsoc2016 if polsoc2016!=. & polsoc2019==.

by pid: replace polsoc2020=polsoc2021 if polsoc2021!=. & polsoc2020==.

*tieslocal
**********
by pid: replace tieslocal2008=tieslocal2009 if tieslocal2009!=. & tieslocal2009==.

by pid: replace tieslocal2010=tieslocal2009 if tieslocal2009!=. & tieslocal2010==.
by pid: replace tieslocal2011=tieslocal2009 if tieslocal2009!=. & tieslocal2011==.
by pid: replace tieslocal2012=tieslocal2009 if tieslocal2009!=. & tieslocal2012==.

by pid: replace tieslocal2015=tieslocal2014 if tieslocal2014!=. & tieslocal2015==.
by pid: replace tieslocal2016=tieslocal2014 if tieslocal2014!=. & tieslocal2016==.
by pid: replace tieslocal2017=tieslocal2014 if tieslocal2014!=. & tieslocal2017==.

by pid: replace tieslocal2018=tieslocal2019 if tieslocal2019!=. & tieslocal2018==.

by pid: replace tieslocal2020=tieslocal2019 if tieslocal2019!=. & tieslocal2020==.
by pid: replace tieslocal2021=tieslocal2019 if tieslocal2019!=. & tieslocal2021==.

*satisarea
**********
by pid: replace satisarea2000=satisarea1999 if satisarea1999!=. & satisarea2000==.
by pid: replace satisarea2001=satisarea1999 if satisarea1999!=. & satisarea2001==.
by pid: replace satisarea2002=satisarea1999 if satisarea1999!=. & satisarea2002==.

by pid: replace satisarea2016=satisarea2017 if satisarea2017!=. & satisarea2016==.

by pid: replace satisarea2018=satisarea2017 if satisarea2017!=. & satisarea2018==.
by pid: replace satisarea2019=satisarea2017 if satisarea2017!=. & satisarea2019==.
by pid: replace satisarea2020=satisarea2017 if satisarea2017!=. & satisarea2020==.

*Reshape back
reshape long lockdoor polsoc tieslocal ausländer satisarea satisdwell, i(pid) j(syear)
mdesc

*Sanity checks
tab syear if lockdoor!=.
tab syear if polsoc!=.
tab syear if ausländer!=.
tab syear if tieslocal!=.
tab syear if satisdwell!=.
tab syear if satisarea!=.

cd "$data"
save "SC_PL.dta", replace

***
*HL
***
cd "$data"
use "SC_HL.dta", clear
reshape wide relneigh freqneigh interneigh security immineigh, i(hid) j(syear)

*relneigh
*********
by hid: replace relneigh2000=relneigh1999 if relneigh1999!=. & relneigh2000==.
by hid: replace relneigh2001=relneigh1999 if relneigh1999!=. & relneigh2001==.
by hid: replace relneigh2002=relneigh1999 if relneigh1999!=. & relneigh2002==.

by hid: replace relneigh2005=relneigh2004 if relneigh2004!=. & relneigh2005==.
by hid: replace relneigh2006=relneigh2004 if relneigh2004!=. & relneigh2006==.
by hid: replace relneigh2007=relneigh2004 if relneigh2004!=. & relneigh2007==.

by hid: replace relneigh2008=relneigh2009 if relneigh2009!=. & relneigh2008==.

by hid: replace relneigh2010=relneigh2009 if relneigh2009!=. & relneigh2010==.
by hid: replace relneigh2011=relneigh2009 if relneigh2009!=. & relneigh2011==.
by hid: replace relneigh2012=relneigh2009 if relneigh2009!=. & relneigh2012==.

by hid: replace relneigh2015=relneigh2014 if relneigh2014!=. & relneigh2015==.
by hid: replace relneigh2016=relneigh2014 if relneigh2014!=. & relneigh2016==.
by hid: replace relneigh2017=relneigh2014 if relneigh2014!=. & relneigh2017==.

by hid: replace relneigh2018=relneigh2019 if relneigh2019!=. & relneigh2018==.

by hid: replace relneigh2020=relneigh2019 if relneigh2019!=. & relneigh2020==.
by hid: replace relneigh2021=relneigh2019 if relneigh2019!=. & relneigh2021==.

*freqneigh
**********
by hid: replace freqneigh2000=freqneigh1999 if freqneigh1999!=. & freqneigh2000==.
by hid: replace freqneigh2001=freqneigh1999 if freqneigh1999!=. & freqneigh2001==.
by hid: replace freqneigh2002=freqneigh1999 if freqneigh1999!=. & freqneigh2002==.

by hid: replace freqneigh2005=freqneigh2004 if freqneigh2004!=. & freqneigh2005==.
by hid: replace freqneigh2006=freqneigh2004 if freqneigh2004!=. & freqneigh2006==.
by hid: replace freqneigh2007=freqneigh2004 if freqneigh2004!=. & freqneigh2007==.

by hid: replace freqneigh2008=freqneigh2009 if freqneigh2009!=. & freqneigh2008==.

by hid: replace freqneigh2010=freqneigh2009 if freqneigh2009!=. & freqneigh2010==.
by hid: replace freqneigh2011=freqneigh2009 if freqneigh2009!=. & freqneigh2011==.
by hid: replace freqneigh2012=freqneigh2009 if freqneigh2009!=. & freqneigh2012==.

by hid: replace freqneigh2015=freqneigh2014 if freqneigh2014!=. & freqneigh2015==.
by hid: replace freqneigh2016=freqneigh2014 if freqneigh2014!=. & freqneigh2016==.
by hid: replace freqneigh2017=freqneigh2014 if freqneigh2014!=. & freqneigh2017==.

by hid: replace freqneigh2018=freqneigh2019 if freqneigh2019!=. & freqneigh2018==.

by hid: replace freqneigh2020=freqneigh2019 if freqneigh2019!=. & freqneigh2020==.
by hid: replace freqneigh2021=freqneigh2019 if freqneigh2019!=. & freqneigh2021==.

*interneigh
***********
by hid: replace interneigh2000=interneigh1999 if interneigh1999!=. & interneigh2000==.
by hid: replace interneigh2001=interneigh1999 if interneigh1999!=. & interneigh2001==.
by hid: replace interneigh2002=interneigh1999 if interneigh1999!=. & interneigh2002==.

by hid: replace interneigh2005=interneigh2004 if interneigh2004!=. & interneigh2005==.
by hid: replace interneigh2006=interneigh2004 if interneigh2004!=. & interneigh2006==.
by hid: replace interneigh2007=interneigh2004 if interneigh2004!=. & interneigh2007==.

by hid: replace interneigh2008=interneigh2009 if interneigh2009!=. & interneigh2008==.

by hid: replace interneigh2010=interneigh2009 if interneigh2009!=. & interneigh2010==.
by hid: replace interneigh2011=interneigh2009 if interneigh2009!=. & interneigh2011==.
by hid: replace interneigh2012=interneigh2009 if interneigh2009!=. & interneigh2012==.

by hid: replace interneigh2015=interneigh2014 if interneigh2014!=. & interneigh2015==.
by hid: replace interneigh2016=interneigh2014 if interneigh2014!=. & interneigh2016==.
by hid: replace interneigh2017=interneigh2014 if interneigh2014!=. & interneigh2017==.

by hid: replace interneigh2018=interneigh2019 if interneigh2019!=. & interneigh2018==.

by hid: replace interneigh2020=interneigh2019 if interneigh2019!=. & interneigh2020==.
by hid: replace interneigh2021=interneigh2019 if interneigh2019!=. & interneigh2021==.

*security
***********
by hid: replace security2005=security2004 if security2004!=. & security2005==.
by hid: replace security2006=security2004 if security2004!=. & security2006==.
by hid: replace security2007=security2004 if security2004!=. & security2007==.

by hid: replace security2008=security2009 if security2009!=. & security2008==.

by hid: replace security2010=security2009 if security2009!=. & security2010==.
by hid: replace security2011=security2009 if security2009!=. & security2011==.
by hid: replace security2012=security2009 if security2009!=. & security2012==.

by hid: replace security2015=security2014 if security2014!=. & security2015==.

by hid: replace security2021=security2020 if security2020!=. & security2021==.

*immineigh
**********
by hid: replace immineigh2000=immineigh1999 if immineigh1999!=. & immineigh2000==.
by hid: replace immineigh2001=immineigh1999 if immineigh1999!=. & immineigh2001==.
by hid: replace immineigh2002=immineigh1999 if immineigh1999!=. & immineigh2002==.

by hid: replace immineigh2005=immineigh2004 if immineigh2004!=. & immineigh2005==.
by hid: replace immineigh2006=immineigh2004 if immineigh2004!=. & immineigh2006==.
by hid: replace immineigh2007=immineigh2004 if immineigh2004!=. & immineigh2007==.

by hid: replace immineigh2008=immineigh2009 if immineigh2009!=. & immineigh2008==.

by hid: replace immineigh2010=immineigh2009 if immineigh2009!=. & immineigh2010==.
by hid: replace immineigh2011=immineigh2009 if immineigh2009!=. & immineigh2011==.
by hid: replace immineigh2012=immineigh2009 if immineigh2009!=. & immineigh2012==.

by hid: replace immineigh2015=immineigh2014 if immineigh2014!=. & immineigh2015==.
by hid: replace immineigh2016=immineigh2014 if immineigh2014!=. & immineigh2016==.
by hid: replace immineigh2017=immineigh2014 if immineigh2014!=. & immineigh2017==.

by hid: replace immineigh2018=immineigh2019 if immineigh2019!=. & immineigh2018==.

by hid: replace immineigh2020=immineigh2019 if immineigh2019!=. & immineigh2020==.
by hid: replace immineigh2021=immineigh2019 if immineigh2019!=. & immineigh2021==.

*Reshape back
reshape long relneigh freqneigh interneigh security immineigh, i(hid) j(syear)
mdesc

*Sanity checks
tab syear if relneigh!=.
tab syear if freqneigh!=.
tab syear if interneigh!=.
tab syear if security!=.
tab syear if immineigh!=.

cd "$data"
save "SC_HL.dta", replace

*Add varialbe hid to adapted pl data set & merge with adapted hl data set
cd "$SOEP"
use pid hid syear using "pl"

cd "$data"
merge 1:1 pid syear using "SC_PL"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     3,218,143
        from master                         0  (_merge==1)
        from using                  3,218,143  (_merge==2)

    Matched                           763,383  (_merge==3)
    -----------------------------------------
*/
drop _merge

merge m:1 hid syear using "SC_HL"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     4,988,225
        from master                 3,218,440  (_merge==1)
        from using                  1,769,785  (_merge==2)

    Matched                           763,086  (_merge==3)
    -----------------------------------------
*/
drop _merge

*Generate sum score for SC
egen numerator_SC=rowtotal(lockdoor polsoc tieslocal ausländer satisarea satisdwell relneigh freqneigh interneigh security immineigh)
egen denominator_SC=rownonmiss(lockdoor polsoc tieslocal ausländer satisarea satisdwell relneigh freqneigh interneigh security immineigh)
gen sum_SC=(numerator_SC/denominator_SC)
sum sum_SC

tempfile SC
save `SC'

		use`SC', clear
		keep pid syear sum_SC
		sort pid syear
		mdesc
		drop if pid==.
		reshape wide sum_SC, i(pid) j(syear)
		joinby pid using `SC'
		
		clonevar SC_6=sum_SC
		replace SC_6=. if (syear<2008 | syear==2009 | syear==2011 | syear==2013 | syear==2015 | syear==2017 | syear==2019 | syear==2021)
		replace SC_6=sum_SC2014 if syear==2020
		replace SC_6=sum_SC2012 if syear==2018 
		replace SC_6=sum_SC2010 if syear==2016
		replace SC_6=sum_SC2008 if syear==2014
		replace SC_6=sum_SC2006 if syear==2012
		replace SC_6=sum_SC2004 if syear==2010
		replace SC_6=sum_SC2002 if syear==2008

		drop sum_SC1* sum_SC2*
		
/*
clear
cls

set obs 11
gen rand1=runiform()
sum rand1
scalar scale1=1/r(sum)
gen weights1=rand1*scale1
drop rand1
list weights1

gen rand2=runiform()
sum rand2
scalar scale2=1/r(sum)
gen weights2=rand2*scale2
drop rand2
list weights2

weights1	weights2	var
.0716547	.0418942	1
.0313321	.0685039	2
.1489003	.1233361	3
.0615239	.1769521	4
.204943	        .2225139	5
.1306001	.0193754	6
.0253879	.0453078	7
.0944097	.005303	        8
.0006952	.1718452	9
.1516844	.0027905	10
.0788688	.1221779	11
*/

gen w1=0.0716547
gen w2=0.0313321
gen w3=0.1489003
gen w4=0.0615239
gen w5=0.204943
gen w6=0.1306001
gen w7=0.0253879
gen w8=0.0944097
gen w9=0.0006952
gen w10=0.1516844
gen w11=0.0788688
egen total=rowtotal(w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11)
drop total

gen SC1=lockdoor*w1
gen SC2=polsoc*w2
gen SC3=tieslocal*w3
gen SC4=ausländer*w4
gen SC5=satisarea*w5
gen SC6=satisdwell*w6
gen SC7=lockdoor*w7
gen SC8=lockdoor*w8
gen SC9=lockdoor*w9
gen SC10=lockdoor*w10
gen SC11=lockdoor*w11

egen numerator_SC_w=rowtotal(SC1 SC2 SC3 SC4 SC5 SC6 SC7 SC8 SC9 SC10 SC11)
egen denominator_SC_w=rownonmiss(SC1 SC2 SC3 SC4 SC5 SC6 SC7 SC8 SC9 SC10 SC11)
gen SC_w=(numerator_SC_w/denominator_SC_w)
sum SC_w, det

cd "$data"
save "SC_sum.dta", replace
