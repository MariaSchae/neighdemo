************************************************
** Clean the final data set
** Author: Maria Schäfer
************************************************


*Check if a pid changed their sex 
use "$data/INKAR+regionl+ppathl+health.dta", clear
keep pid syear sex
bysort pid (syear): gen change=1 if sex!=sex[_n-1] & sex[_n-1]!=. & sex!=.
replace change=0 if change==.
bysort pid (syear):gen count=_n
bysort pid (syear):replace change=0 if count==1 & change==1
tab change, m
drop count change //no person changed their sex

*Prepare the movedist dataset
cd "$SOEP"
use "movedist.dta", clear
label language EN
keep pid syear chg_kkz
levelsof chg_kkz
recode chg_kkz (-2=.) //111,066 changes made
tempfile movedist
save `movedist'

*Merge movedist and current data set
merge 1:1 pid syear using "$data/INKAR+regionl+ppathl+health.dta"
sort _merge
/*

    Result                      Number of obs
    -----------------------------------------
    Not matched                       501,503
        from master                   407,614  (_merge==1)
        from using                     93,889  (_merge==2)

    Matched                           493,033  (_merge==3)
    -----------------------------------------
*/
drop if _merge==1
drop _merge

levelsof chg_kkz
sort pid syear

		//This part is important for the fist/initial anaylsis
		*Check if we have obs. for subsequent years (if diff>1 we do not have subsequent survey years)
		bysort pid (syear): gen diff=syear-syear[_n-1]
		tab diff, m
		bysort pid (syear): replace diff=1 if syear[_n==1] & diff==.
		lab var diff "Subsequent survey years?"

		*Replace missing values for chg_kkz based on kkz_rek 
		sort pid syear
		recode chg_kkz (.=0) if kkz_rek==kkz_rek[_n-1] & diff==1 // 122,559 changes made
		bysort pid (syear): gen count=_n

		recode chg_kkz (.=1) if kkz_rek!=kkz_rek[_n-1] & count!=1 & diff==1 // 1,595 changes made 
		drop count 

		//Variables indicating moving	
	**2020-2014

		*First year
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2014
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2013 & syear<2021)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2020
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2013	& syear<2021)
		gen same_firstlast=1 if first_county==last_county & (syear>2013 & syear<2021) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid2014=total(!missing(chg_kkz)) if (syear>2014 & syear<2021) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2014 & syear<2021) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid2014
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid2014=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid2014=totalbypid2014[_n-1] if missing(totalbypid2014) & syear==2020 & diff==1
		bysort pid (syear): replace totalbypid2014=totalbypid2014[_n+1] if missing(totalbypid2014) & syear==2014 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
	
	**2018-2012
		
		*First year
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2012
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2011 & syear<2019)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2018
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2011 & syear<2019)
		gen same_firstlast=1 if first_county==last_county & (syear>2011 & syear<2019) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid1812=total(!missing(chg_kkz)) if (syear>2012 & syear<2019) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2012 & syear<2019) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid1812
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid1812=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid1812=totalbypid1812[_n-1] if missing(totalbypid1812) & syear==2018 & diff==1
		bysort pid (syear): replace totalbypid1812=totalbypid1812[_n+1] if missing(totalbypid1812) & syear==2012 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
		
	**2016-2010
		
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2010
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2009 & syear<2017)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2016
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2009 & syear<2017)
		gen same_firstlast=1 if first_county==last_county & (syear>2009 & syear<2017) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid1610=total(!missing(chg_kkz)) if (syear>2010 & syear<2017) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2010 & syear<2017) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid1610
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid1610=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid1610=totalbypid1610[_n-1] if missing(totalbypid1610) & syear==2016 & diff==1
		bysort pid (syear): replace totalbypid1610=totalbypid1610[_n+1] if missing(totalbypid1610) & syear==2010 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
		
	**2014-2008
		
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2008
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2007 & syear<2015)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2014
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2007 & syear<2015)
		gen same_firstlast=1 if first_county==last_county & (syear>2007 & syear<2015) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid1408=total(!missing(chg_kkz)) if (syear>2008 & syear<2015) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2008 & syear<2015) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid1408
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid1408=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid1408=totalbypid1408[_n-1] if missing(totalbypid1408) & syear==2014 & diff==1
		bysort pid (syear): replace totalbypid1408=totalbypid1408[_n+1] if missing(totalbypid1408) & syear==2008 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
		
	**2012-2006
		
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2006
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2005 & syear<2013)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2012
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2005 & syear<2013)
		gen same_firstlast=1 if first_county==last_county & (syear>2005 & syear<2013) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid1206=total(!missing(chg_kkz)) if (syear>2006 & syear<2013) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2006 & syear<2013) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid1206
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid1206=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid1206=totalbypid1206[_n-1] if missing(totalbypid1206) & syear==2012 & diff==1
		bysort pid (syear): replace totalbypid1206=totalbypid1206[_n+1] if missing(totalbypid1206) & syear==2006 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
		
	**2010-2004
		
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2004
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2003 & syear<2011)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2010
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2003 & syear<2011)
		gen same_firstlast=1 if first_county==last_county & (syear>2003 & syear<2011) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid1004=total(!missing(chg_kkz)) if (syear>2004 & syear<2011) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2004 & syear<2011) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid1004
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid1004=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid1004=totalbypid1004[_n-1] if missing(totalbypid1004) & syear==2010 & diff==1
		bysort pid (syear): replace totalbypid1004=totalbypid1004[_n+1] if missing(totalbypid1004) & syear==2004 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
		
	**2008-2002
		
		clonevar first_county=kkz_rek
		bysort pid (syear): replace first_county=. if syear!=2002
		bysort pid (syear): replace first_county=first_county[_n-1] if missing(first_county)  & (syear>2001 & syear<2009)
		*Last year
		clonevar last_county=kkz_rek
		bysort pid (syear): replace last_county=. if syear!=2008
		rename last_county last
		bysort pid (syear): egen last_county=max(cond(!missing(last),  last, .)) if (syear>2001 & syear<2009)
		gen same_firstlast=1 if first_county==last_county & (syear>2001 & syear<2009) & (first_county!=.) & (last_county!=.)
		levelsof same_firstlast
		drop first_county last_county last
		
		levelsof chg_kkz
		bysort pid (syear): egen totalbypid0802=total(!missing(chg_kkz)) if (syear>2002 & syear<2009) & same_firstlast==1
		bysort pid (syear): egen total_chg_kkz=total(chg_kkz) if (syear>2002 & syear<2009) & chg_kkz!=. & same_firstlast==1
		
		levelsof totalbypid0802
		levelsof total_chg_kkz
		
		bysort pid (syear): replace totalbypid0802=. if total_chg_kkz>0 
		bysort pid (syear): replace totalbypid0802=totalbypid0802[_n-1] if missing(totalbypid0802) & syear==2008 & diff==1
		bysort pid (syear): replace totalbypid0802=totalbypid0802[_n+1] if missing(totalbypid0802) & syear==2002 & diff[_n+1]==1
		drop total_chg_kkz same_firstlast
		
*Rename _ label variables
lab var hid "Current Household ID"
lab var pid "Personal ID"

lab var kkz_rek "District ID"
rename kkz_rek district

lab var Raumeinheit "City name"
rename Raumeinheit city

lab var Aggregat "Landkreis or kreisfreie City?"
rename Aggregat kreis

lab var sex "Gender"
lab var age "Age"
/*lab var u6 "Inhabitants <6 years"
lab var a6u18 "Inhabitants 6-17 years"
lab var a18u25 "Inhabitants 18-24 years"
lab var a25u30 "Inhabitants 25-29 years"
lab var a30u50 "Inhabitants 30-49 years"
lab var a50u65 "Inhabitants 50-64 years"
lab var a65 "Inhabitants >65 years"
lab var a75 "Inhabitants >75 years"
lab var Wa75 "Female Inhabitants >75 years"
lab var Wa18u25 "Female Inhabitants 18-24 years" 
lab var Wa25u30 "Female Inhabitants 25-29 years"
lab var Wa65 "Female Inhabitants >65 years"
lab var a65u75 "Inhabitants 65-74 years"
lab var Wa65u75 "Female Inhabitants 65-74 years"
lab var a75u85 "Inhabitants 75-84 years"
lab var a85 "Inhabitants >85 years"
lab var Wa85 "Female Inhabitants >85 years"
lab var Wa75u85 "Female Inhabitants 75-84 years"
lab var a85 "Inhabitants >85 years"
lab var u3 "Inhabitants <3 years"
lab var a3u6 "Inhabitants 3-5 years"
lab var avage "Mean age"
lab var child "Share children (<18 years)"
lab var adult "Share adults (18-65 years)"*/
lab var senior "Share seniors syear-6 (>65 years)"
/*lab var totalcontrol "Control variable"
lab var change_chi "Change in share of children between 1995 & 2019"
lab var change_adu "Change in share of adults between 1995 & 2019"*/
lab var change_sen "Change in share of seniors between 1995 & 2019"
/*lab var change_chi_1 "Yearly change in share of children"
lab var change_chi_2 "Biennial change in share of children"
lab var change_chi_5 "Five-Year change in share of children"
lab var change_adu_1 "Yearly change in share of adults"
lab var change_adu_2 "Biennial change in share of adults"
lab var change_adu_5 "Five-Year change in share of adults"*/
lab var change_sen_1 "Yearly change in share of seniors"
lab var change_sen_2 "Biennial change in share of seniors"
lab var change_sen_5 "Five-Year change in share of seniors"

/*Order variables
order hid pid syear district city kreis chg_kkz total* sex age mcs pcs /// 
u3 a3u6 u6 a6u18 a18u25 a25u30 a30u50 a50u65 a65 a65u75 a75 a75u85 a85 ///
Wa18u25 Wa25u30 Wa65 Wa65u75 Wa75 Wa75u85 Wa85 ///
avage child adult senior totalcontrol ///
change_chi change_adu change_sen ///
change_chi_1 change_chi_2 change_chi_5 ///
change_adu_1 change_adu_2 change_adu_5 ///
change_sen_1 change_sen_2 change_sen_5*/

*Clean the variables for mental/physical health
**# Bookmark #1
keep if mcs>-1 | pcs>-1 //376,795  obs. deleted
sum mcs
replace mcs=. if mcs<0 //1 real change made, 1 to missing
**# Bookmark #2
sum pcs
tab syear,m
**# Bookmark #3
drop if syear==2017 | syear==2019 //see mail from Dr. Markus Grabka & Odile 02nd/03rd March 2023); 3,029 obs. deleted
**# Bookmark #2
sort pid syear
tempfile Prep_clean
save `Prep_clean'

		**Prepare/Create health variables
		*Reshape long to wide for variables mcs and pcs
		use`Prep_clean', clear
		keep pid syear mcs pcs 
		reshape wide mcs pcs, i(pid) j(syear)
		tempfile wide_health
		save `wide_health'
		
		use `Prep_clean', clear
		joinby pid using `wide_health'
		
		clonevar mcs_6=mcs
		replace mcs_6=. if (syear>2001 & syear<2008)
		replace mcs_6=mcs2014 if syear==2020
		replace mcs_6=mcs2012 if syear==2018 
		replace mcs_6=mcs2010 if syear==2016
		replace mcs_6=mcs2008 if syear==2014
		replace mcs_6=mcs2006 if syear==2012
		replace mcs_6=mcs2004 if syear==2010
		replace mcs_6=mcs2002 if syear==2008
		drop mcs2*
		
		clonevar pcs_6=pcs
		replace pcs_6=. if (syear>2001 & syear<2008)
		replace pcs_6=pcs2014 if syear==2020
		replace pcs_6=pcs2012 if syear==2018 
		replace pcs_6=pcs2010 if syear==2016
		replace pcs_6=pcs2008 if syear==2014
		replace pcs_6=pcs2006 if syear==2012
		replace pcs_6=pcs2004 if syear==2010
		replace pcs_6=pcs2002 if syear==2008
		drop pcs2*	
		
cd "$data"
save "Clean_INKAR_regionl_ppathl_health.dta", replace
