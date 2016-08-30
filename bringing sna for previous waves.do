use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\lphs_sna2.dta", clear
tab yr_naccho
keep if yr_naccho!=2008
keep nacchoid yr_naccho pop bedpcap servdens-orgcent
duplicates list nacchoid yr_naccho

/*

. duplicates list nacchoid yr_naccho

Duplicates in terms of nacchoid yr_naccho

  +-------------------------------------+
  | group:   obs:   nacchoid   yr_nac~o |
  |-------------------------------------|
  |      1   4205      CA022       2010 |
  |      1   6749      CA022       2010 |
  |      2      8      CO069       2010 |
  |      2      9      CO069       2010 |
  |      3     10      CO071       2010 |
  |-------------------------------------|
  |      3     11      CO071       2010 |
  |      4   5198      NJ018       2010 |
  |      4   6686      NJ018       2010 |
  +-------------------------------------+


*/
sort nacchoid yr_naccho
quietly by nacchoid yr_naccho:  gen dup = cond(_N==1,0,_n)

br yr_naccho nacchoid servdens orgcent dup if nacchoid=="CA022" | nacchoid=="CO069" | nacchoid=="CO071" | nacchoid=="NJ018"

drop if nacchoid=="CA022" & yr_naccho==2010 & servdens==0
drop if nacchoid=="NJ018" & yr_naccho==2010 & servdens==0
drop if nacchoid=="CO069" & yr_naccho==2010 & servdens==0 & dup==2
drop if nacchoid=="CO071" & yr_naccho==2010 & servdens==0 & dup==2

duplicates list nacchoid yr_naccho

foreach X in pop bedpcap servdens scent1 scent2 scent3 scent4 scent5 scent6 scent7 scent8 scent9 scent10 scent11 scent12 scent13 scent14 scent15 scent16 scent17 scent18 scent19 maxscent servcent org1_1 org1_2 org1_3 org1_4 org1_5 org1_6 org1_7 org1_8 org1_9 org1_10 org1_11 org1_12 org2_1 org2_2 org2_3 org2_4 org2_5 org2_6 org2_7 org2_8 org2_9 org2_10 org2_11 org2_12 org3_1 org3_2 org3_3 org3_4 org3_5 org3_6 org3_7 org3_8 org3_9 org3_10 org3_11 org3_12 org4_1 org4_2 org4_3 org4_4 org4_5 org4_6 org4_7 org4_8 org4_9 org4_10 org4_11 org4_12 org5_1 org5_2 org5_3 org5_4 org5_5 org5_6 org5_7 org5_8 org5_9 org5_10 org5_11 org5_12 org6_1 org6_2 org6_3 org6_4 org6_5 org6_6 org6_7 org6_8 org6_9 org6_10 org6_11 org6_12 org7_1 org7_2 org7_3 org7_4 org7_5 org7_6 org7_7 org7_8 org7_9 org7_10 org7_11 org7_12 org8_1 org8_2 org8_3 org8_4 org8_5 org8_6 org8_7 org8_8 org8_9 org8_10 org8_11 org8_12 org9_1 org9_2 org9_3 org9_4 org9_5 org9_6 org9_7 org9_8 org9_9 org9_10 org9_11 org9_12 org10_1 org10_2 org10_3 org10_4 org10_5 org10_6 org10_7 org10_8 org10_9 org10_10 org10_11 org10_12 org11_1 org11_2 org11_3 org11_4 org11_5 org11_6 org11_7 org11_8 org11_9 org11_10 org11_11 org11_12 org12_1 org12_2 org12_3 org12_4 org12_5 org12_6 org12_7 org12_8 org12_9 org12_10 org12_11 org12_12 orgdens ocent1 ocent2 ocent3 ocent4 ocent5 ocent6 ocent7 ocent8 ocent9 ocent10 ocent11 ocent12 maxocent orgcent dup {
rename `X' TBD_`X'
}

sort nacchoid yr_naccho

save sna2_nodup, replace

use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb3.dta", clear
rename yearnaccho yr_naccho
drop _merge
sort nacchoid yr_naccho

merge m:1 nacchoid yr_naccho using sna2_nodup

br if _merge<3
drop if _merge==2 
lookfor c3q15

br hspnum mean_hospnum11 TBD_mean_hospnum10 hospnum10 yearsurvey
replace hspnum=hospnum10 if hspnum==. & yearsurvey==2012

br nacchoid exp c3q15 c3q15a TBD_c3q15 TBD_c3q15a pop  bedpcap  TBD_mean_bed10 fte c5q37 ftecap pct65 mean_65est10 TBD_mean_65est10 mdpcap TBD_mean_mds10  mean_mds10  TBD_mean_lndarea10 servdens  orgcent  yearsurvey if survresp==1
br nacchoid exp c3q15 c3q15a TBD_c3q15 TBD_c3q15a pop  bedpcap  TBD_mean_bed10 fte c5q37 ftecap pct65 mean_65est10 TBD_mean_65est10 mdpcap TBD_mean_mds10  mean_mds10 TBD_mean_lndarea10 servdens  orgcent  yearsurvey if survresp==1 & yr_naccho==2010

/*
foreach X in mean_lndarea10 mean_bed10 c5q37 c3q15 c3q15a mean_mds10  servcent org1_1 org1_2 org1_3 org1_4 org1_5 org1_6 org1_7 org1_8 org1_9 org1_10 org1_11 org1_12 org2_1 org2_2 org2_3 org2_4 org2_5 org2_6 org2_7 org2_8 org2_9 org2_10 org2_11 org2_12 org3_1 org3_2 org3_3 org3_4 org3_5 org3_6 org3_7 org3_8 org3_9 org3_10 org3_11 org3_12 org4_1 org4_2 org4_3 org4_4 org4_5 org4_6 org4_7 org4_8 org4_9 org4_10 org4_11 org4_12 org5_1 org5_2 org5_3 org5_4 org5_5 org5_6 org5_7 org5_8 org5_9 org5_10 org5_11 org5_12 org6_1 org6_2 org6_3 org6_4 org6_5 org6_6 org6_7 org6_8 org6_9 org6_10 org6_11 org6_12 org7_1 org7_2 org7_3 org7_4 org7_5 org7_6 org7_7 org7_8 org7_9 org7_10 org7_11 org7_12 org8_1 org8_2 org8_3 org8_4 org8_5 org8_6 org8_7 org8_8 org8_9 org8_10 org8_11 org8_12 org9_1 org9_2 org9_3 org9_4 org9_5 org9_6 org9_7 org9_8 org9_9 org9_10 org9_11 org9_12 org10_1 org10_2 org10_3 org10_4 org10_5 org10_6 org10_7 org10_8 org10_9 org10_10 org10_11 org10_12 org11_1 org11_2 org11_3 org11_4 org11_5 org11_6 org11_7 org11_8 org11_9 org11_10 org11_11 org11_12 org12_1 org12_2 org12_3 org12_4 org12_5 org12_6 org12_7 org12_8 org12_9 org12_10 org12_11 org12_12 orgdens ocent1 ocent2 ocent3 ocent4 ocent5 ocent6 ocent7 ocent8 ocent9 ocent10 ocent11 ocent12 maxocent orgcent dup {
replace `X'=TBD_`X' if `X'==. & yearsurvey<2014
}

replace bedpcap=TBD_mean_bed10/pop*100000 if bedpcap==. & yearsurvey==2012
replace bedpcap=TBD_mean_bed10/pop*100000 if bedpcap==. & yearsurvey==2012
replace bedpcap=TBD_mean_mds10/pop*100000 if mdpcap==. & yearsurvey==2012
*/

replace pct65=mean_65est10/pop*100 if pct65==. & yearsurvey==2012
replace ftecap=fte/pop*100000 if ftecap==. & yearsurvey==2012

foreach X in servdens scent1 scent2 scent3 scent4 scent5 scent6 scent7 scent8 scent9 scent10 scent11 scent12 scent13 scent14 scent15 scent16 scent17 scent18 scent19 maxscent servcent org1_1 org1_2 org1_3 org1_4 org1_5 org1_6 org1_7 org1_8 org1_9 org1_10 org1_11 org1_12 org2_1 org2_2 org2_3 org2_4 org2_5 org2_6 org2_7 org2_8 org2_9 org2_10 org2_11 org2_12 org3_1 org3_2 org3_3 org3_4 org3_5 org3_6 org3_7 org3_8 org3_9 org3_10 org3_11 org3_12 org4_1 org4_2 org4_3 org4_4 org4_5 org4_6 org4_7 org4_8 org4_9 org4_10 org4_11 org4_12 org5_1 org5_2 org5_3 org5_4 org5_5 org5_6 org5_7 org5_8 org5_9 org5_10 org5_11 org5_12 org6_1 org6_2 org6_3 org6_4 org6_5 org6_6 org6_7 org6_8 org6_9 org6_10 org6_11 org6_12 org7_1 org7_2 org7_3 org7_4 org7_5 org7_6 org7_7 org7_8 org7_9 org7_10 org7_11 org7_12 org8_1 org8_2 org8_3 org8_4 org8_5 org8_6 org8_7 org8_8 org8_9 org8_10 org8_11 org8_12 org9_1 org9_2 org9_3 org9_4 org9_5 org9_6 org9_7 org9_8 org9_9 org9_10 org9_11 org9_12 org10_1 org10_2 org10_3 org10_4 org10_5 org10_6 org10_7 org10_8 org10_9 org10_10 org10_11 org10_12 org11_1 org11_2 org11_3 org11_4 org11_5 org11_6 org11_7 org11_8 org11_9 org11_10 org11_11 org11_12 org12_1 org12_2 org12_3 org12_4 org12_5 org12_6 org12_7 org12_8 org12_9 org12_10 org12_11 org12_12 orgdens ocent1 ocent2 ocent3 ocent4 ocent5 ocent6 ocent7 ocent8 ocent9 ocent10 ocent11 ocent12 maxocent orgcent  {
replace `X' = TBD_`X' if `X'==.
}

drop dup full12 TBD_* eff1_14- othany_rec full12 
tab yearsurvey survresp 
bysort yearsurvey: sum orgdens orgcent servdens 

bysort yr_naccho: sum popdens if survresp==1
replace popdens=pop/mean_lndarea10 if popdens==. & yearsurvey==2012
gen popdens_rec=.
replace popdens_rec=pop/mean_lndarea10 if yearsurvey==2014
bysort yr_naccho: sum popdens popdens_rec if survresp==1

bysort yr_naccho: sum exp if survresp==1



save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb4.dta", replace

bysort yearsurvey: sum expcap fte ftecap pop popdens bedpcap mdpcap pct65 hspnum if survresp==1

gen metro=.
replace metro=1 if msametro==1
replace metro=1 if metro==. & (rucc==0 | rucc==1 | rucc==2 | rucc==3)
replace metro=1 if metro==. & msa==2

replace metro=0 if metro==. & msamicro==1
replace metro=0 if metro==. & (rucc==4 | rucc==5 | rucc==6 | rucc==7 | rucc==8 | rucc==9)
replace metro=0 if metro==. & msa==1

replace metro=0 if metro==. & msa==0

/*Taking care of duplicates*/
duplicates list nacchoid yr_naccho if survresp==1
sort nacchoid yr_naccho
quietly by nacchoid yr_naccho:  gen dup = cond(_N==1,0,_n)

br nacchoid id2012 if dup>1 & survresp==1
br nacchoid id2012 yr_naccho survresp avtot if nacchoid=="MN024" | nacchoid=="NC021"

br nacchoid id2012 yr_naccho survresp avtot if id2012==234 | id2012==212 | id2012==165
/*Note one of those MN024 is MN032*/
/*Note that MN032 & MN024 both have same county fips*/

br nacchoid county_fips id2006 id1998 id2012 avtot yr_naccho yearsurvey survresp if nacchoid=="MN024" | nacchoid=="NC021" | nacchoid=="MN032"

drop if nacchoid=="MN032" & yr_naccho==2010 & avtot==.
replace nacchoid="MN032" if nacchoid=="MN024" & id2012==212 & yr_naccho==2010

/*Note one of those NC021 is AZ003*/

br nacchoid county_fips id2006 id1998 id2012 avtot yr_naccho yearsurvey survresp if nacchoid=="NC021" | nacchoid=="AZ003"

drop if nacchoid=="AZ003" & yr_naccho==2010 & avtot==.
replace nacchoid="AZ003" if nacchoid=="NC021" & id2012==165 & yr_naccho==2010
replace county_fips="04005" if nacchoid=="AZ003" & yr_naccho==2010

replace nacchoid="ZZ001" if nacchoid=="" & id2012==193 & yr_naccho==2010
replace nacchoid="ZZ002" if nacchoid=="" & id2012==234 & yr_naccho==2010

replace fqhcany=1 if fqhcany==. & fqhcnum>0 & yr_naccho>2005
replace fqhcany=0 if fqhcany==. & fqhcnum==0 & yr_naccho>2005
 
save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb5.dta", replace
 bysort yr_naccho: sum orgdens orgcent servdens popdens incpcap unemp bedpcap ftecap mdpcap pctnonwh pct65 uninstot collpct hspnum
br nacchoid county_fips yr_naccho if county_fips==""

 /*Imputing missing county fips for 197, 2005 and 2010*/
 save fullq, replace
 keep if yearsurvey==2014
 keep nacchoid county_fips
 rename county_fips TBD_county_fips
 sort nacchoid
 save cntyfips, replace
 use fullq, clear
 drop _merge
 sort nacchoid
 merge m:1 nacchoid using cntyfips
 replace county_fips=TBD_county_fips if county_fips==""
 drop TBD_county_fips
/*Getting fips code for missing county_fips*/
 
replace county_fips="22057" if nacchoid=="LA064" 

replace county_fips="51700" if nacchoid=="VA132" 
replace county_fips="34025" if nacchoid=="NJ068" 

replace county_fips="45085" if nacchoid=="SC020" 
replace county_fips="45063" if nacchoid=="SC009" 
replace county_fips="51840" if nacchoid=="VA042" 
replace county_fips="48139" if nacchoid=="TX139" /*instead of 48113*/
replace county_fips="39035" if nacchoid=="OH029" 
replace county_fips="24510" if nacchoid=="MD004" 
replace county_fips="48041" if nacchoid=="TX112" 

save fullr, replace
/*Bringing in zipcode file for 2010*/

insheet using "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\zcta_county_rel_10.txt", clear
keep zcta5 state county geoid
rename (state county geoid) (TBD_state TBD_county TBD_geoid)
br
gen str5 TBD_zcta5 = string(zcta5,"%05.0f")

sort TBD_zcta5

quietly by TBD_zcta5:  gen dup = cond(_N==1,0,_n)
drop if dup>1
duplicates list zcta5

sort TBD_zcta5

save zcta5, replace

use fullr, clear
gen TBD_zcta5=zip_rec
sort TBD_zcta5
drop _merge
count

merge m:1 TBD_zcta5 using zcta5
drop if _merge==2
count

gen str5 TBD_zcta5_geoid = string(TBD_geoid,"%05.0f")

replace county_fips=TBD_zcta5_geoid if county_fips=="" & TBD_zcta5_geoid!="."
drop TBD_zcta5 - TBD_zcta5_geoid

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb5.dta", replace

 
