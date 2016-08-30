use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214_final.dta", clear
tab yearsurvey Arm
replace Arm=1 if Arm==.
tab Arm yearsurvey

save nlsfull, replace
use nlsfull, clear

/*Getting unid for all*/

keep unid Arm nacchoid yearsurvey

keep if yearsurvey==2014

count
br
duplicates list nacchoid

rename (unid Arm yearsurvey) (unid_rec  Arm_rec  yearsurvey_rec)
sort nacchoid
save unid, replace
use nlsfull, clear
drop _merge
merge m:1 nacchoid using unid

replace unid=unid_rec if unid==.
drop yearsurvey_rec - _merge

br unid nacchoid yearsurvey survresp if unid==.

/*

	unid	nacchoid	yearsurvey	survresp
							2012	0
				CA001		1998	0
				NJ068		1998	1
				NJ068		2012	1
				NJ068		2006	0
				ZZ002		1998	1
				ZZ002		2006	0
				ZZ002		2012	1

*/

replace unid=66 if unid==.  & nacchoid==""
replace unid=77 if unid==.  & nacchoid=="CA001"
replace unid=88 if unid==.  & nacchoid=="NJ068"
replace unid=99 if unid==.  & nacchoid=="ZZ002"

save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wavespanelUNID.dta", replace
use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wavespanelUNID.dta", clear
forvalues i=1/19 {
gen lhdn`i'=0 if lhd`i'==0
replace lhdn`i'=1 if lhd`i'>0 & lhd`i'<=1
}
tab yearsurvey survresp
tab lhd1 yearsurvey, miss
tab lhdn1 yearsurvey, miss

br unid Arm yearsurvey survresp lhdn1-lhdn19 sta1-sta19 loc1-loc19 fed1-fed19 ///
phy1-phy19 hsp1-hsp19 chc1-chc19 non1-non19 ins1-ins19 sch1-sch19 uni1-uni19 ///
oth1-oth19 fbo1-fbo19 emp1-emp19

sort unid yearsurvey
count
save nls4SNA, replace
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4SNA.dta", replace
use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4SNA.dta", clear

keep unid nacchoid Arm yearsurvey survresp lhd1-lhd19 lhdn1-lhdn19 sta1-sta19 loc1-loc19 fed1-fed19 ///
phy1-phy19 hsp1-hsp19 chc1-chc19 non1-non19 ins1-ins19 sch1-sch19 uni1-uni19 ///
oth1-oth19 fbo1-fbo19 emp1-emp19 ///
sha1-sha19 sao1-sao19 nono1-nono19 ///
pct* av* eff* lhdn*

save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA.dta", replace
export delimited using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA.csv", replace

save nls4waves, replace
keep if yearsurvey==2014

/*Checking if the following variables are created.*/
br avtot* efftot* lhdtot* pcttot* shatot* saotot* loctot* fedtot* phytot* hsptot* chctot* fbotot* nonotot* instot* emptot* schtot* unitot* othtot*

egen org1=rowtotal(sha1 sao1 loc1 fed1 phy1 hsp1 chc1 fbo1 nono1 ins1 emp1 sch1 uni1 oth1)
egen org2=rowtotal(sha2 sao2 loc2 fed2 phy2 hsp2 chc2 fbo2 nono2 ins2 emp2 sch2 uni2 oth2)
egen org3=rowtotal(sha3 sao3 loc3 fed3 phy3 hsp3 chc3 fbo3 nono3 ins3 emp3 sch3 uni3 oth3)
egen org4=rowtotal(sha4 sao4 loc4 fed4 phy4 hsp4 chc4 fbo4 nono4 ins4 emp4 sch4 uni4 oth4)
egen org5=rowtotal(sha5 sao5 loc5 fed5 phy5 hsp5 chc5 fbo5 nono5 ins5 emp5 sch5 uni5 oth5)
egen org6=rowtotal(sha6 sao6 loc6 fed6 phy6 hsp6 chc6 fbo6 nono6 ins6 emp6 sch6 uni6 oth6)
egen org7=rowtotal(sha7 sao7 loc7 fed7 phy7 hsp7 chc7 fbo7 nono7 ins7 emp7 sch7 uni7 oth7)
egen org8=rowtotal(sha8 sao8 loc8 fed8 phy8 hsp8 chc8 fbo8 nono8 ins8 emp8 sch8 uni8 oth8)
egen org9=rowtotal(sha9 sao9 loc9 fed9 phy9 hsp9 chc9 fbo9 nono9 ins9 emp9 sch9 uni9 oth9)
egen org10=rowtotal(sha10 sao10 loc10 fed10 phy10 hsp10 chc10 fbo10 nono10 ins10 emp10 sch10 uni10 oth10)
egen org11=rowtotal(sha11 sao11 loc11 fed11 phy11 hsp11 chc11 fbo11 nono11 ins11 emp11 sch11 uni11 oth11)
egen org12=rowtotal(sha12 sao12 loc12 fed12 phy12 hsp12 chc12 fbo12 nono12 ins12 emp12 sch12 uni12 oth12)
egen org13=rowtotal(sha13 sao13 loc13 fed13 phy13 hsp13 chc13 fbo13 nono13 ins13 emp13 sch13 uni13 oth13)
egen org14=rowtotal(sha14 sao14 loc14 fed14 phy14 hsp14 chc14 fbo14 nono14 ins14 emp14 sch14 uni14 oth14)
egen org15=rowtotal(sha15 sao15 loc15 fed15 phy15 hsp15 chc15 fbo15 nono15 ins15 emp15 sch15 uni15 oth15)
egen org16=rowtotal(sha16 sao16 loc16 fed16 phy16 hsp16 chc16 fbo16 nono16 ins16 emp16 sch16 uni16 oth16)
egen org17=rowtotal(sha17 sao17 loc17 fed17 phy17 hsp17 chc17 fbo17 nono17 ins17 emp17 sch17 uni17 oth17)
egen org18=rowtotal(sha18 sao18 loc18 fed18 phy18 hsp18 chc18 fbo18 nono18 ins18 emp18 sch18 uni18 oth18)
egen org19=rowtotal(sha19 sao19 loc19 fed19 phy19 hsp19 chc19 fbo19 nono19 ins19 emp19 sch19 uni19 oth19)

forvalues i=1/19 {
replace pct`i'=org`i'/14
}


forvalues i=1/19 {
replace  pct`i'=. if av`i'==.
}

egen avass_rec=rmean(av1-av6)
replace avass=avass_rec
egen avpol_rec=rmean(av7-av13)
replace avpol=avpol_rec
egen avasr_rec=rmean(av14-av20)
replace avasr=avasr_rec


egen avtot_rec=rmean(avass avpol avasr)
replace avtot=avtot_rec

egen effass_rec=rmean(eff1-eff6)
replace effass=effass_rec
egen effpol_rec=rmean(eff7-eff13)
replace effpol=effpol_rec
egen effasr_rec=rmean(eff14-eff19)
replace effasr=effasr_rec


egen efftot_rec=rmean(effass effpol effasr)
replace efftot=efftot_rec

egen lhdass_rec=rmean(lhdn1-lhdn6)
gen lhdass=lhdass_rec
egen lhdpol_rec=rmean(lhdn7-lhdn13)
gen lhdpol=lhdpol_rec
egen lhdasr_rec=rmean(lhdn14-lhdn19)
gen lhdasr=lhdasr_rec


egen lhdtot_rec=rmean(lhdass lhdpol lhdasr)
gen lhdtot=lhdtot_rec

egen pctass_rec=rmean(pct1-pct6)
replace pctass=pctass_rec
egen pctpol_rec=rmean(pct7-pct13)
replace pctpol=pctpol_rec
egen pctasr_rec=rmean(pct14-pct19)
replace pctasr=pctasr_rec


egen pcttot_rec=rmean(pctass pctpol pctasr)
replace pcttot=pcttot_rec


/* Creating following variables using foreach loop***/
/*
shaass shapol shaasr shatot
saoass saopol saoasr saotot
locass locpol locasr loctot
fedass fedpol fedasr fedtot
phyass phypol phyasr phytot
hspass hsppol hspasr hsptot
chcass chcpol chcasr chctot
fboass fbopol fboasr fbotot
nonoass nonopol nonoasr nonotot
insass inspol insasr instot
empass emppol empasr emptot
schass schpol schasr schtot
uniass unipol uniasr unitot
othass othpol othasr othtot
noneass nonepol noneasr nonetot
*/

/*************************************************************
We will use the older convention of creating composite variables and 
in later do file we will revert it back to GPM's newer
conventions of creating the composite variables
******************************************************************/

egen av1av6=rownonmiss(av1 - av6)
egen av7av13=rownonmiss(av7 - av13)
egen av14av19=rownonmiss(av14 - av19)


foreach X in sha sao loc fed phy hsp chc fbo nono ins emp sch uni oth  {
egen `X'ass_total=rowtotal(`X'1 -`X'6)
gen `X'ass_rec=`X'ass_total/av1av6
gen `X'ass=`X'ass_rec
egen `X'pol_total=rowtotal(`X'7 -`X'13)
gen `X'pol_rec=`X'pol_total/av7av13
gen `X'pol=`X'pol_rec
egen `X'asr_total=rowtotal(`X'14 -`X'19)
gen `X'asr_rec=`X'asr_total/av14av19
gen `X'asr=`X'asr_rec
egen `X'tot_rec=rmean(`X'ass `X'pol `X'asr)
gen `X'tot=`X'tot_rec
}


foreach X in ass_total pol_total asr_total  {
drop sha`X' sao`X' loc`X' fed`X' phy`X' hsp`X' chc`X' fbo`X' nono`X' ins`X' emp`X' sch`X' uni`X' oth`X' 
}

foreach X in ass_rec pol_rec asr_rec tot_rec {
drop av`X' eff`X' lhd`X' pct`X' sha`X' sao`X' loc`X' fed`X' phy`X' hsp`X' chc`X' fbo`X' nono`X' ins`X' emp`X' sch`X' uni`X' oth`X' 
}

/*
br avass* avpol* avasr* avtot* effass* effpol* effasr* efftot* lhdass* lhdpol* lhdasr* lhdtot*
*/

br shatot saotot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot

*drop sta1-sta19
forvalues j = 1/19 {

 egen sta_rec`j'=rowtotal(sha`j' sao`j') 
 replace sta_rec`j'=. if av`j'==.
 } 
forvalues j = 1/19 {
replace sta`j'=sta_rec`j'
}
drop sta_rec1-sta_rec19

br sta1 sha1 sao1

egen staass_total=rowtotal(sta1-sta6)
gen staass=staass_total/av1av6
egen stapol_total=rowtotal(sta7-sta13)
gen stapol=stapol_total/av7av13
egen staasr_total=rowtotal(sta14-sta19)
gen staasr=staasr_total/av14av19
egen statot_rec=rmean(staass stapol staasr)
gen statot=statot_rec

drop staass_total staass stapol_total stapol staasr_total staasr statot_rec 

forvalues j = 1/19 {
 egen non_rec`j'=rowmax(fbo`j' nono`j') 
 replace non_rec`j'=. if av`j'==.
 } 
forvalues j = 1/19 {
replace non`j'=non_rec`j'
}
drop non_rec1-non_rec19
 
egen nonass_total=rowtotal(non1-non6)
gen nonass=nonass_total/av1av6
egen nonpol_total=rowtotal(non7-non13)
gen nonpol=nonpol_total/av7av13
egen nonasr_total=rowtotal(non14-non19)
gen nonasr=nonasr_total/av14av19
egen nontot=rmean(nonass nonpol nonasr)


drop nonass_total nonass nonpol_total nonpol nonasr_total nonasr nontot

foreach X in sha sao sta loc fed phy hsp chc fbo nono ins emp sch uni oth {
gen `X'any=1 if `X'tot>0 
replace `X'any=0 if `X'tot==0
}
 


save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_14.dta", replace
export delimited using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_14.csv", replace
export sasxport "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_14.xpt", rename

use nls4waves, clear
keep if yearsurvey==2012
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_12.dta", replace
export delimited using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_12.csv", replace
export sasxport "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_12.xpt", rename 

use nls4waves, clear
keep if yearsurvey==2006
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_06.dta", replace
export delimited using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_06.csv", replace

use nls4waves, clear
keep if yearsurvey==1998
save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_98.dta", replace
export delimited using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_98.csv", replace


/*Now we work for SNA in SAS using "C:\Users\LRTI222\Dropbox\Data\NLSPHS\NLS4WAVES_SNA.sas" and get an output data
outData.dta to be processed further*/
