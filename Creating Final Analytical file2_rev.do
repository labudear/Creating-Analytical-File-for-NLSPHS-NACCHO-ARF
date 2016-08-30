/*Before running this file run :
C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\single sas file to create all4wavesnacarfnls.sas
*/

/*Merging all waves of NLSPHS*/
clear
clear matrix
clear mata
set maxvar 10000

/*FROM HERE***********************
********************
*********************
***********************************/
use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\all4wavesnacarfnls.dta", clear

br av1 eff1 lhd1 yearsurvey if survresp==1 & yearsurvey==2014
br av1 eff1 lhd1 yearsurvey if survresp==1 & yearsurvey==2012
br av1 eff1 lhd1 yearsurvey if survresp==1 & yearsurvey==2006
br av1 eff1 lhd1 yearsurvey if survresp==1 & yearsurvey==1998


forvalues i = 1/19 {
gen eff`i'_14=eff`i' if yearsurvey==2014 
gen lhd`i'_14=lhd`i' if yearsurvey==2014 


}

forvalues i = 1/19 {
gen eff`i'_14_rec=.
replace eff`i'_14_rec=0 if eff`i'_14==1
replace eff`i'_14_rec=.25 if eff`i'_14==2
replace eff`i'_14_rec=.5 if eff`i'_14==3
replace eff`i'_14_rec=.75 if eff`i'_14==4
replace eff`i'_14_rec=1 if eff`i'_14==5

replace eff`i'_14=eff`i'_14_rec
}

tab1 eff1 eff1_14 if yearsurvey==2014

forvalues i = 1/19 {
replace eff`i'=eff`i'_14 if yearsurvey==2014
}
tab1 eff1

forvalues i = 1/19 {
gen lhd`i'_14_rec=.
replace lhd`i'_14_rec=0 if lhd`i'_14==1
replace lhd`i'_14_rec=.25 if lhd`i'_14==2
replace lhd`i'_14_rec=.5 if lhd`i'_14==3
replace lhd`i'_14_rec=.75 if lhd`i'_14==4
replace lhd`i'_14_rec=1 if lhd`i'_14==5

replace lhd`i'_14=lhd`i'_14_rec
}
tab lhd1
tab lhd1_14
tab1 lhd1 lhd1_14 if yearsurvey==2014

forvalues i = 1/19 {
replace lhd`i'=lhd`i'_14 if yearsurvey==2014
}
tab1 lhd1

tab arm, m
tab arm yearsurvey

br nacchoid yearsurvey* arm survresp*

/*Let us impute nacchoid*/
save fulla, replace

import excel "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nacchoidnlsid98-12.xlsx", sheet("Sheet1") firstrow clear
drop if id1998==.
duplicates list id1998

keep id1998 nacchoid
rename nacchoid TBD_nacchoid

sort id1998
save id98, replace

use fulla, clear
sort id1998

merge m:1 id1998 using id98

replace nacchoid=TBD_nacchoid if nacchoid==""
drop TBD_nacchoid _merge


/*

/*Restricting data to 2014 waves only*/
keep if survresp_14==1
tab Arm_14
keep *_14

*/
/*Checking if the following variables are created.
*/
br yearsurvey avtot* efftot* lhdtot* pcttot* shatot* saotot* loctot* fedtot* phytot* hsptot* chctot* fbotot* nonotot* instot* emptot* schtot* unitot* othtot* if yearsurvey==2014 & survresp==1
br yearsurvey avtot* efftot* lhdtot* pcttot* shatot* saotot* loctot* fedtot* phytot* hsptot* chctot* fbotot* nonotot* instot* emptot* schtot* unitot* othtot* if yearsurvey==2012 & survresp==1

/*Only 2012 wave was missing these variables:

lhdtot* shatot* saotot* loctot* fedtot* phytot* hsptot* chctot* fbotot* nonotot* instot* emptot* schtot* unitot* othtot* if yearsurvey==2012 & survresp==1

*/
/*
forvalues i=1/19 {
rename org`i' org`i'_old
} 

egen org1_12=rowtotal(sha1_12 sao1_12 loc1_12 fed1_12 phy1_12 hsp1_12 chc1_12 fbo1_12 nono1_12 ins1_12 emp1_12 sch1_12 uni1_12 oth1_12)
egen org2_12=rowtotal(sha2_12 sao2_12 loc2_12 fed2_12 phy2_12 hsp2_12 chc2_12 fbo2_12 nono2_12 ins2_12 emp2_12 sch2_12 uni2_12 oth2_12)
egen org3_12=rowtotal(sha3_12 sao3_12 loc3_12 fed3_12 phy3_12 hsp3_12 chc3_12 fbo3_12 nono3_12 ins3_12 emp3_12 sch3_12 uni3_12 oth3_12)
egen org4_12=rowtotal(sha4_12 sao4_12 loc4_12 fed4_12 phy4_12 hsp4_12 chc4_12 fbo4_12 nono4_12 ins4_12 emp4_12 sch4_12 uni4_12 oth4_12)
egen org5_12=rowtotal(sha5_12 sao5_12 loc5_12 fed5_12 phy5_12 hsp5_12 chc5_12 fbo5_12 nono5_12 ins5_12 emp5_12 sch5_12 uni5_12 oth5_12)
egen org6_12=rowtotal(sha6_12 sao6_12 loc6_12 fed6_12 phy6_12 hsp6_12 chc6_12 fbo6_12 nono6_12 ins6_12 emp6_12 sch6_12 uni6_12 oth6_12)
egen org7_12=rowtotal(sha7_12 sao7_12 loc7_12 fed7_12 phy7_12 hsp7_12 chc7_12 fbo7_12 nono7_12 ins7_12 emp7_12 sch7_12 uni7_12 oth7_12)
egen org8_12=rowtotal(sha8_12 sao8_12 loc8_12 fed8_12 phy8_12 hsp8_12 chc8_12 fbo8_12 nono8_12 ins8_12 emp8_12 sch8_12 uni8_12 oth8_12)
egen org9_12=rowtotal(sha9_12 sao9_12 loc9_12 fed9_12 phy9_12 hsp9_12 chc9_12 fbo9_12 nono9_12 ins9_12 emp9_12 sch9_12 uni9_12 oth9_12)
egen org10_12=rowtotal(sha10_12 sao10_12 loc10_12 fed10_12 phy10_12 hsp10_12 chc10_12 fbo10_12 nono10_12 ins10_12 emp10_12 sch10_12 uni10_12 oth10_12)
egen org11_12=rowtotal(sha11_12 sao11_12 loc11_12 fed11_12 phy11_12 hsp11_12 chc11_12 fbo11_12 nono11_12 ins11_12 emp11_12 sch11_12 uni11_12 oth11_12)
egen org12_12=rowtotal(sha12_12 sao12_12 loc12_12 fed12_12 phy12_12 hsp12_12 chc12_12 fbo12_12 nono12_12 ins12_12 emp12_12 sch12_12 uni12_12 oth12_12)
egen org13_12=rowtotal(sha13_12 sao13_12 loc13_12 fed13_12 phy13_12 hsp13_12 chc13_12 fbo13_12 nono13_12 ins13_12 emp13_12 sch13_12 uni13_12 oth13_12)
egen org14_12=rowtotal(sha14_12 sao14_12 loc14_12 fed14_12 phy14_12 hsp14_12 chc14_12 fbo14_12 nono14_12 ins14_12 emp14_12 sch14_12 uni14_12 oth14_12)
egen org15_12=rowtotal(sha15_12 sao15_12 loc15_12 fed15_12 phy15_12 hsp15_12 chc15_12 fbo15_12 nono15_12 ins15_12 emp15_12 sch15_12 uni15_12 oth15_12)
egen org16_12=rowtotal(sha16_12 sao16_12 loc16_12 fed16_12 phy16_12 hsp16_12 chc16_12 fbo16_12 nono16_12 ins16_12 emp16_12 sch16_12 uni16_12 oth16_12)
egen org17_12=rowtotal(sha17_12 sao17_12 loc17_12 fed17_12 phy17_12 hsp17_12 chc17_12 fbo17_12 nono17_12 ins17_12 emp17_12 sch17_12 uni17_12 oth17_12)
egen org18_12=rowtotal(sha18_12 sao18_12 loc18_12 fed18_12 phy18_12 hsp18_12 chc18_12 fbo18_12 nono18_12 ins18_12 emp18_12 sch18_12 uni18_12 oth18_12)
egen org19_12=rowtotal(sha19_12 sao19_12 loc19_12 fed19_12 phy19_12 hsp19_12 chc19_12 fbo19_12 nono19_12 ins19_12 emp19_12 sch19_12 uni19_12 oth19_12)

forvalues i=1/19 {
replace pct`i'_12=org`i'_12/14
}


forvalues i=1/19 {
replace  pct`i'_12=. if av`i'_12==.
}
*/
/*
egen avass_rec=rmean(av1-av6)
br avass_rec avass yearsurvey if survresp==1
replace avass=avass_rec

egen avpol_rec=rmean(av7-av13)
br avpol_rec avpol yearsurvey if survresp==1
replace avpol=avpol_rec

egen avasr_rec=rmean(av14-av20)
br avasr_rec avasr yearsurvey if survresp==1
replace avasr=avasr_rec


egen avtot_rec=rmean(avass avpol avasr)
br avtot_rec avtot yearsurvey if survresp==1
replace avtot=avtot_rec
*/

egen effass_rec=rmean(eff1-eff6)
br effass_rec effass yearsurvey if survresp==1
replace effass=effass_rec if yearsurvey==2014
egen effpol_rec=rmean(eff7-eff13)
br effpol_rec effpol yearsurvey if survresp==1
replace effpol=effpol_rec if yearsurvey==2014
egen effasr_rec=rmean(eff14-eff19)
br effasr_rec effasr yearsurvey if survresp==1
replace effasr=effasr_rec if yearsurvey==2014


egen efftot_rec=rmean(effass effpol effasr)
replace efftot=efftot_rec if yearsurvey==2014

egen lhdass_rec=rmean(lhd1-lhd6)
replace lhdass=lhdass_rec if yearsurvey==2014
egen lhdpol_rec=rmean(lhd7-lhd13)
replace lhdpol=lhdpol_rec if yearsurvey==2014
egen lhdasr_rec=rmean(lhd14-lhd19)
replace lhdasr=lhdasr_rec if yearsurvey==2014


egen lhdtot_rec=rmean(lhdass lhdpol lhdasr)
replace lhdtot=lhdtot_rec if yearsurvey==2014


br yearsurvey avtot* efftot* lhdtot* pcttot* shatot* saotot* loctot* fedtot* phytot* hsptot* chctot* fbotot* nonotot* instot* emptot* schtot* unitot* othtot* if yearsurvey==2014 & survresp==1


/*
egen pctass_14_rec=rmean(pct1_14-pct6_14)
replace pctass_14=pctass_14_rec
egen pctpol_14_rec=rmean(pct7_14-pct13_14)
replace pctpol_14=pctpol_14_rec
egen pctasr_14_rec=rmean(pct14_14-pct19_14)
replace pctasr_14=pctasr_14_rec


egen pcttot_14_rec=rmean(pctass_14 pctpol_14 pctasr_14)
replace pcttot_14=pcttot_14_rec
*/


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

egen av1av6_rec=rownonmiss(av1 - av6)
br av1av6 av1av6_rec yearsurvey if survresp==1
replace av1av6=av1av6_rec

egen av7av13_rec=rownonmiss(av7 - av13)
br av7av13 av7av13_rec yearsurvey if survresp==1
replace av7av13=av7av13_rec

egen av14av19_rec=rownonmiss(av14 - av19)
br av14av19 av14av19_rec yearsurvey if survresp==1
replace av14av19=av14av19_rec

/*********FROM HERE*********/
/*
foreach X in sha sao loc fed phy hsp chc fbo nono ins emp sch uni oth  {
egen `X'ass_total=rowtotal(`X'1 -`X'6)
gen `X'ass_rec=`X'ass_total/av1av6
replace `X'ass=`X'ass_rec if yearsurvey==2014
egen `X'pol_total=rowtotal(`X'7 -`X'13)
gen `X'pol_rec=`X'pol_total/av7av13
replace `X'pol=`X'pol_rec if yearsurvey==2014
egen `X'asr_total=rowtotal(`X'14 -`X'19)
gen `X'asr_rec=`X'asr_total/av14av19
replace `X'asr=`X'asr_rec if yearsurvey==2014
egen `X'tot_rec=rmean(`X'ass `X'pol `X'asr)
replace `X'tot=`X'tot_rec if yearsurvey==2014
}


foreach X in ass_total pol_total asr_total  {
drop sha`X' sao`X' loc`X' fed`X' phy`X' hsp`X' chc`X' fbo`X' nono`X' ins`X' emp`X' sch`X' uni`X' oth`X' 
}

foreach X in ass_rec pol_rec asr_rec tot_rec {
drop av`X' eff`X' lhd`X' sha`X' sao`X' loc`X' fed`X' phy`X' hsp`X' chc`X' fbo`X' nono`X' ins`X' emp`X' sch`X' uni`X' oth`X' 
}

*/

/*
br avass* avpol* avasr* avtot* effass* effpol* effasr* efftot* lhdass* lhdpol* lhdasr* lhdtot*
*/

br shatot saotot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot

br shatot saotot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot if yearsurvey==2014 & survresp==1
br shatot saotot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot if yearsurvey==2012 & survresp==1
br shatot saotot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot if yearsurvey==1998 & survresp==1
br shatot saotot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot if yearsurvey==2006 & survresp==1

br staass stapol staasr if yearsurvey==2014 & survresp==1

/*THIS FOREACH LOOP*/
forvalues j = 1/19 {

 egen sta`j'_14=rowmax(sha`j' sao`j') 
 replace sta`j'_14=. if av`j'==.
 } 

br sta1 sta1_14 sha1 sao1 yearsurvey if survresp==1
forvalues j = 1/19 {
replace sta`j'=sta`j'_14 if 
egen staass_total=rowtotal(sta1-sta6)
gen staass_rec=staass_total/av1av6
br staass staass_total sta1-sta6 sha1-sha6 staass_rec yearsurvey if survresp==1
replace staass=staass_rec if yearsurvey==2014

egen stapol_total=rowtotal(sta7-sta13)
gen stapol_rec=stapol_total/av7av13
br stapol stapol_rec yearsurvey if survresp==1
replace stapol=stapol_rec if yearsurvey==2014

egen staasr_total=rowtotal(sta14-sta19)
gen staasr_rec=staasr_total/av14av19
replace staasr=staasr_rec if yearsurvey==2014

egen statot_rec=rmean(staass stapol staasr)
replace statot=statot_rec if yearsurvey==2014

drop staass_total staass_rec stapol_total stapol_rec staasr_total staasr_rec statot_rec 

br staass stapol staasr if yearsurvey==2014 & survresp==1


*drop non1 non10-non19 
rename non1 non1_old

forvalues j = 2/9 {
rename non`j' non`j'_old
}

forvalues j = 10/19 {
rename non`j' non`j'_old
}

forvalues j = 1/19 {
 egen non`j'=rowmax(fbo`j' nono`j') 
 replace non`j'=. if av`j'==.
 } 
 
egen nonass_total=rowtotal(non1-non6)
gen nonass_rec=nonass_total/av1av6
br non1-non6 non1_old-non6_old
br av1-av6 fbo1-fbo6 nono1-nono6 non1-non6 av1av6 nonass nonass_rec yearsurvey if survresp==1
replace nonass=nonass_rec if yearsurvey==2014

egen nonpol_total=rowtotal(non7-non13)
gen nonpol_rec=nonpol_total/av7av13
replace nonpol=nonpol_rec if yearsurvey==2014

egen nonasr_total=rowtotal(non14-non19)
gen nonasr_rec=nonasr_total/av14av19
replace nonasr=nonasr_rec if yearsurvey==2014

egen nontot_rec=rmean(nonass nonpol nonasr)
replace nontot=nontot_rec if yearsurvey==2014

drop nonass_total nonass_rec nonpol_total nonpol_rec nonasr_total nonasr_rec nontot_rec

foreach X in sha sao sta loc fed phy hsp chc fbo nono ins emp sch uni oth {
gen `X'any_rec=1 if `X'tot>0 
replace `X'any_rec=0 if `X'tot==0 
replace `X'any=`X'any_rec
}
 
br shaany_rec shaany yearsurvey if survresp==1

/*
foreach X in sha sao sta loc fed phy hsp chc fbo nono ins emp sch uni oth {
replace `X'any=`X'any_rec
}
*/

 /***************************************
Create Typology variables: 2014
Lava's Note: It uses threshold cretaed by logit/probit command in 1998 data. For better comparability across the waves of NLSPHS we will stck with
this threshold for both small and large size jurisdictions.
***************************************/

/*Integration*/
    gen hiparsta=(statot>.50) if !missing(statot)
	gen hiparloc=(loctot>.46) if !missing(statot)
	gen hiparnon=(nontot>.46) if !missing(statot)
	gen hiparhsp=(hsptot>.50) if !missing(statot)
	gen hiparphy=(phytot>.31) if !missing(statot)
	gen hiparchc=(chctot>.15) if !missing(statot)
	gen hiparuni=(unitot>.26) if !missing(statot)
	gen hiparfed=(fedtot>.11) if !missing(statot)
	gen hiparins=(instot>.11) if !missing(statot)
	gen hiparoth=(othtot>.11) if !missing(statot)

gen hiparsum=hiparsta+hiparloc+hiparnon+hiparhsp+hiparphy+hiparchc+hiparuni+hiparfed+hiparins+hiparoth if !missing(statot)
gen hipargov=hiparsta+hiparloc+hiparfed if !missing(statot)
gen hiparcli=hiparhsp+hiparphy+hiparchc if !missing(statot)
gen hiparots=hiparnon+hiparuni+hiparins+hiparoth if !missing(statot)

gen clustpart=1	if hipargov>1 & hiparcli>1 & hiparots>2 & !missing(statot)
    replace clustpart=2 if clustpart==. & hipargov>1 & hiparcli>1 & hiparots<3  & !missing(statot)
	replace clustpart=3 if clustpart==. & hipargov>1 & hiparcli<2 & hiparots>2  & !missing(statot)
	replace clustpart=3 if clustpart==. & hipargov>1 & hiparcli<2 & hiparots<3  & !missing(statot)
	replace clustpart=4 if clustpart==. & hipargov<2 & hiparcli>1 & hiparots<3  & !missing(statot)
	replace clustpart=4 if clustpart==. & hipargov<2 & hiparcli>1 & hiparots>2  & !missing(statot)
	replace clustpart=5 if clustpart==. & hipargov<2 & hiparcli<2 & hiparots>2  & !missing(statot)
	replace clustpart=5 if clustpart==. & hipargov<2 & hiparcli<2 & hiparots>1  & !missing(statot)
	replace clustpart=7 if clustpart==. & hipargov==0 & hiparcli==0 & hiparots==0  & !missing(statot)
	replace clustpart=6 if clustpart==. & hipargov<2 & hiparcli<2 & hiparots<2  & !missing(statot)
tab clustpart

/*Centralization*/
clonevar lhdeff1=lhdass
clonevar lhdeff2=lhdpol
clonevar lhdeff3=lhdasr

 
gen clustlhd=.
replace clustlhd=1 if lhdeff1>0.5 & lhdeff2>0.5 & (1>=lhdeff3 & lhdeff3>0.5)   
replace clustlhd=2 if clustlhd==. & lhdeff1>0.5 & lhdeff2<=0.5 & lhdeff3>0.5  
replace clustlhd=3 if clustlhd==. & lhdeff1<=0.5 & lhdeff2>0.5 & lhdeff3>0.5  
replace clustlhd=4 if clustlhd==. & lhdeff1<=0.5 & lhdeff2<=0.5 & lhdeff3>0.5  
replace clustlhd=5 if clustlhd==. & lhdeff1>0.5 & lhdeff2>0.5 & lhdeff3<=0.5  
replace clustlhd=5 if clustlhd==. & lhdeff1>0.5 & lhdeff2<=0.5 & lhdeff3<=0.5  
replace clustlhd=5 if clustlhd==. & lhdeff1<=0.5 & lhdeff2>0.5 & lhdeff3<=0.5  
replace clustlhd=6 if clustlhd==. & lhdeff1<=0.5 & lhdeff2<=0.5 & lhdeff3<=0.5 & lhdeff3!=.  
tab clustlhd

/*Scope*/

	gen clustav=1 if avass>0.75 & avpol>0.75 & avasr>0.75 & avtot<=1 & !missing(avtot)
	replace clustav=2 if clustav==. & avass>0.75 & avpol<=0.75 & avasr>0.75 & !missing(avtot)
	replace clustav=3 if clustav==. & avass<=0.75 & avpol>0.75 & avasr>0.75  & !missing(avtot)
	replace clustav=5 if clustav==. & avass<=0.75 & avpol<=0.75 & avasr>0.75 & !missing(avtot)
	replace clustav=4 if clustav==. & avass>0.75 & avpol>0.75 & avasr<=0.75 & !missing(avtot)
	replace clustav=5 if clustav==. & avass>0.75 & avpol<=0.75 & avasr<=0.75   & !missing(avtot)
	replace clustav=5 if clustav==. & avass<=0.75 & avpol>0.75 & avasr<=0.75   & !missing(avtot)
	replace clustav=7 if clustav==. & avass<=0.5 & avpol<=0.5 & avasr<=0.5 & !missing(avtot)
	replace clustav=6 if clustav==. & avass<=0.75 & avpol<=0.75 & avasr<=0.75  & !missing(avtot)
	 

tab clustav

	gen loav=clustav>4 if !missing(avtot)
	gen lopart=clustpart>4 if !missing(avtot)
	gen lolhd=clustlhd>3 if !missing(avtot)
	replace lolhd=0 if clustlhd==5 & !missing(avtot)


/*Typology*/
gen clusttot_rec=.
replace clusttot_rec=1 if loav==0 & lopart==0 & lolhd==0 & !missing(avtot)  
replace clusttot_rec=2 if clusttot_rec==. & loav==0 & lopart==1 & lolhd==0  & !missing(avtot)
replace clusttot_rec=3 if clusttot_rec==. & loav==0 & lopart==0 & lolhd==1  & !missing(avtot)
replace clusttot_rec=4 if clusttot_rec==. & loav==0 & lopart==1 & lolhd==1  & !missing(avtot)
replace clusttot_rec=5 if clusttot_rec==. & loav==1 & lopart==1 & lolhd==1 & !missing(avtot)
replace clusttot_rec=6 if clusttot_rec==. & loav==1 & lopart==0 & lolhd==1 & !missing(avtot)
replace clusttot_rec=7 if clusttot_rec==. & loav==1 & lopart==1 & lolhd==0 & !missing(avtot)
replace clusttot_rec=7 if clusttot_rec==. & loav==1 & lopart==0 & lolhd==0 & !missing(avtot)
tab clusttot_rec
tab clusttot yearsurvey
tab clusttot_rec yearsurvey

/*
*/
bysort yearsurvey: sum statot staass stapol staasr avass avpol avasr avtot lhdeff1 lhdeff2 lhdeff3 loav lopart lolhd
/*
*/
recode arm (1=1) (2/3=0), gen(arm_rec)
bysort arm_rec: tab clusttot_rec yearsurvey

br clusttot clusttot_rec yearsurvey if survresp==1

sort clusttot_rec clustav clustpart clustlhd
br clustav loav clustpart lopart clustlhd lolhd clusttot_rec clusttot survresp yearsurvey

/*Create clusttot1_rec--clusttot7_rec*/
forvalues i = 1/7 {
gen clusttot`i'_rec=(clusttot_rec==`i') if !missing(clusttot_rec)
}

/*Public Health System: 1998, 2006, 2012, 2014*/

label define sysfx 1 "Comprehensive" 2 "Conventional" 3 "Limited"

recode clusttot_rec (1/3=1) (4/5=2) (6/7=3), gen(system_rec)
label variable system_rec "Public Health System Capital"
label value system_rec sysfx
tab1 system system_rec 
tab system yearsurvey
tab system_rec yearsurvey


sort nacchoid
save fullb, replace

/*Bringing in the adjusted weights calculated in Stata "full NLSPHS with weights.do"*/

use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_2014_wts_adj.dta", replace

sum wt_adj
count
count if nacchoid!=""
keep nacchoid pw wt_adj fpc region popcat

foreach X in pw wt_adj fpc region popcat {
rename `X' TBD_`X'
}

sort nacchoid
save wts, replace

use fullb, clear
count
merge m:m nacchoid using wts
drop _merge
count

rename popcat jurpopcat
gen wt_adj=TBD_wt_adj if yearsurvey==2014
gen popcat=TBD_popcat if yearsurvey==2014
gen region=TBD_region


gen strata_rec=.
replace strata_rec=1 if region==1 & popcat==1
replace strata_rec=2 if region==1 & popcat==2
replace strata_rec=3 if region==1 & popcat==3
replace strata_rec=4 if region==2 & popcat==1
replace strata_rec=5 if region==2 & popcat==2
replace strata_rec=6 if region==2 & popcat==3
replace strata_rec=7 if region==3 & popcat==1
replace strata_rec=8 if region==3 & popcat==2
replace strata_rec=9 if region==3 & popcat==3
replace strata_rec=10 if region==4 & popcat==1
replace strata_rec=11 if region==4 & popcat==2
replace strata_rec=12 if region==4 & popcat==3
tab strata_rec 

sort nacchoid
merge m:1 nacchoid using "C:\Users\Lava\Dropbox\strata.dta"
drop if _merge==2
count
drop _merge

replace county_fips=modfips if county_fips==""
replace pop=c0population if pop==.
replace pop=mean_popest13 if pop==. & yearsurvey==2014
replace hspnum=mean_hospnum11 if hspnum==. & yearsurvey==2014

br yearsurvey survresp pop c0pop* mean_pop* if pop==.


*save "U:\NLSPHS2014\Analysis\AnalyticalFiles\NLSPHSNACCHOARFAll4Waves_wts.dta", replace
save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts.dta", replace

/*Bringing in peer values*/

use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\FINALNLSNACARF_RURB.dta", clear
tab1 peer*
keep nacchoid yearsurvey peer* rucc*
tab yearsurvey
drop if yearsurvey==.
duplicates list nacchoid yearsurvey
drop if nacchoid=="ZZNNN"
tab1 peer*
rename (peer98 peerclus peer) (TBD_peer98 TBD_peerclus TBD_peer)
sort nacchoid yearsurvey
save peer, replace

use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts.dta", clear
gen TBD_keep=1
sort nacchoid yearsurvey
merge m:1 nacchoid yearsurvey using peer
drop if TBD_keep==.

replace peer=TBD_peer if peer==.
replace rucc=ruccode if yearsurvey==2012 & rucc==.
replace rucc=ruccode if rucc==.

rename (TBD_peer98 TBD_peerclus) (peer98 peerclus)

drop TBD_*

tab1 peer peerclus peer98

*save "U:\NLSPHS2014\Analysis\AnalyticalFiles\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb.dta", replace
save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb.dta", replace

/*
use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts.dta", clear

save "C:\Users\LRTI222\Dropbox\NLSPHSNACCHOARFAll4Waves_wts.dta", replace

keep nacchoid strata
sort nacchoid
quietly by nacchoid:  gen dup = cond(_N==1,0,_n)
drop if dup>1
	
sort nacchoid
save strata, replace
save "C:\Users\LRTI222\Dropbox\strata.dta", replace
*/

/*****************************************************************************************************************************
Use SAS to Create network analytic measures from NLSPHS data
*****************************************************************************************************************************/
