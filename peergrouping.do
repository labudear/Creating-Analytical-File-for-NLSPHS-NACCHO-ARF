use "X:\xDATA\NLSPHS 2014\Analysis\data\SMALL_PEER_FINAL.dta", clear
rename peer peer_tbd
tab peer_tbd
replace nacchoid="MO130" if nacchoid=="MOXXX"
replace nacchoid="NJ014" if nacchoid=="NJXXX"
sort nacchoid
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\peersmall.dta", replace

sort nacchoid
gen clusanalysis=1
rename peer_tbd peerclus
sort nacchoid
tab peerclus

merge 1:m nacchoid using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214.dta"

drop _merge


br if nacchoid==""
replace nacchoid="ZZ002" if id1998==9999
sort nacchoid
save NLSPHS_SMALLPEER, replace

use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214.dta", clear
count
br if nacchoid==""
keep nacchoid peer yearsurvey id1998
*keep if Arm!=2 & Arm!=3
gen peer98=peer*1
keep if yearsurvey==1998
drop yearsurvey
count
replace nacchoid="ZZ002" if nacchoid==""
sort nacchoid

save part98, replace

merge 1:m nacchoid using NLSPHS_SMALLPEER

/*
peerclus is peer grouping obtained from cluster analysis for small size jurisdiction and these peer grouping are different than the 
peer grouping in variable peer for large size jurisdictions
*/

/*Looking for duplicates by nacchoid and yearsurvey and fixing them*/
duplicates list nacchoid yearsurvey
br nacchoid unid id* av1 yearsurvey survresp state2014 state if nacchoid=="NJ014" | nacchoid=="NC021" | nacchoid=="MN046" | nacchoid=="MN024" | nacchoid=="AZ003" | nacchoid=="MN032"
replace nacchoid="AZ003" if id2012==165 & nacchoid=="NC021"
replace id1998=1968 if id2012==165 & id1998==2657
drop if nacchoid=="AZ003" & yearsurvey==2012 & survresp==0
replace nacchoid="MN032" if id2012==212 & nacchoid=="MN024"
replace id1998=2071 if id2012==212 & id1998==1038
drop if nacchoid=="MN032" & yearsurvey==2012 & survresp==0
drop if nacchoid=="NJ014" & unid==99999 & survresp==0
drop if nacchoid=="MN046" & yearsurvey==2014 & survresp==0
duplicates list nacchoid yearsurvey
tab yearsurvey
tab yearsurvey survresp

save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214_final.dta", replace

export excel using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214_final.xlsx", firstrow(variables) replace

/*Subsetting data by yearsurvey*/
save nlsphsfull, replace
keep if yearsurvey==2014
count
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_14_final.dta", replace

export excel using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_14_final.xlsx", firstrow(variables) replace

use nlsphsfull, clear
keep if yearsurvey==2012
count
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_12_final.dta", replace

export excel using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_12_final.xlsx", firstrow(variables) replace

use nlsphsfull, clear
keep if yearsurvey==2006
count
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_06_final.dta", replace

export excel using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_06_final.xlsx", firstrow(variables) replace

use nlsphsfull, clear
keep if yearsurvey==1998
count
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98_final.dta", replace

export excel using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98_final.xlsx", firstrow(variables) replace

use nlsphsfull, clear
keep if yearsurvey==1998 | yearsurvey==2006
count
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_9806_final.dta", replace

export excel using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_9806_final.xlsx", firstrow(variables) replace
