use "C:\Users\LAVA\Dropbox\Data\NLSPHS\Analysis\NAC10ARF14AVGunique.dta", clear
rename county_fips TBD_county_fips
foreach X in c3q15 c3q15a c5q36 c5q37 f0002013 f1255913 f1397304 cntyfips pct65 cbsa rucc urbinfc cbsa_max rucc_min urbinfc_min mean_mds12 mean_mds11 mean_mds10 mean_mds08 mean_mds07 mean_mds06 mean_mds05 mean_mds04 mean_mds03 mean_mds02 mean_mds01 mean_mds00 mean_mds90 mean_mds80 mean_mds70 mean_mds60 mean_mds50 mean_mds40 mean_bed11 mean_bed10 mean_bed05 mean_popest13 mean_popest12 mean_popest11 mean_popcens10 mean_popest09 mean_popest08 mean_popest07 mean_popest06 mean_popest05 mean_popest04 mean_popest03 mean_popest02 mean_popest01 mean_popcens00 mean_popest99 mean_popest98 mean_popest97 mean_popest96 mean_popest95 mean_popest94 mean_popest93 mean_popest92 mean_popest91 mean_65est12 mean_65est11 mean_65est10 mean_65est09 mean_65est08 mean_65est07 mean_65est06 mean_65est05 mean_pct65est00 mean_hospnum10 mean_medage10 mean_medage00 mean_pctwh10 mean_pctwh00 mean_pcapinc12 mean_pcapinc11 mean_pcapinc10 mean_pcapinc09 mean_pcapinc08 mean_pcapinc07 mean_pcapinc06 mean_pcapinc05 mean_pctpov12 mean_pctpov11 mean_pctpov10 mean_pctpov09 mean_pctpov08 mean_pctpov07 mean_pctpov06 mean_pctpov05 mean_pctnoins12 mean_pctnoins11 mean_pctnoins10 mean_pctnoins09 mean_pctnoins08 mean_pctnoins07 mean_pctnoins06 mean_collpct0812 mean_collpct0610 mean_unemppct13 mean_unemppct12 mean_unemppct11 mean_unemppct10 mean_unemppct09 mean_unemppct08 mean_unemppct07 mean_unemppct06 mean_unemppct05 mean_fqhcs13 mean_fqhcs12 mean_fqhcs11 mean_fqhcs10 mean_perspov12 mean_perspov11 mean_perspov10 mean_perspov09 mean_hospadm11 mean_hospadm10 mean_hospadm05 mean_lndarea10 mean_lndarea00 {
rename `X' TBD_`X'
}
sort nacchoid
save nac10ARF, replace
use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb2.dta", clear
br county_fips nacchoid yearsurvey if yearsurvey==2012
save full1, replace
drop if yearsurvey==2012 
save full980614, replace
use full1, clear
keep if yearsurvey==2012
save full12, replace
keep if nacchoid==""
save nacmiss12, replace
use full12, clear
gen full12=1
drop if nacchoid==""
sort nacchoid
merge m:1 nacchoid using nac10ARF
keep if full12==1
replace county_fips=TBD_county_fips if county_fips==""

save full12_rec, replace

append using nacmiss12

append using full980614
drop if yearsurvey==.
count

replace msametro=1 if msametro==. & TBD_cbsa==1
replace msametro=0 if msametro==. & yearsurvey==2012 & TBD_cbsa!=.
replace msamicro=1 if msamicro==. & TBD_cbsa==2
replace msamicro=0 if msamicro==. & yearsurvey==2012 & TBD_cbsa!=.

replace rucc=TBD_rucc_min if rucc ==. & yearsurvey==2012
replace urbinf=TBD_urbinfc_min if urbinf ==. & yearsurvey==2012

replace econtype=1 if econtype==. & TBD_f1397304=="01" & yearsurvey==2012
replace econtype=2 if econtype==. & TBD_f1397304=="02" & yearsurvey==2012
replace econtype=3 if econtype==. & TBD_f1397304=="03" & yearsurvey==2012
replace econtype=4 if econtype==. & TBD_f1397304=="04" & yearsurvey==2012
replace econtype=5 if econtype==. & TBD_f1397304=="05" & yearsurvey==2012
replace econtype=6 if econtype==. & TBD_f1397304=="06" & yearsurvey==2012

replace incpcap=TBD_mean_pcapinc10 if incpcap==. & yearsurvey==2012

replace uninstot=TBD_mean_pctnoins10 if uninstot==. & yearsurvey==2012

replace unemp=TBD_mean_unemppct12 if unemp==. & yearsurvey==2012
replace pop=TBD_mean_popcens10 if pop==. & yearsurvey==2012

replace popdens=pop/TBD_mean_lndarea10 if popdens==. & yearsurvey==2012 

replace mdpcap=TBD_mean_mds10/pop*100000 if mdpcap==. & yearsurvey==2012

replace bedpcap=TBD_mean_bed10/pop*100000 if bedpcap==. & yearsurvey==2012

replace pctnonwh=(100-TBD_mean_pctwh10) if pctnonwh==. & yearsurvey==2012

replace pct65=mean_pct65est12/pop if pct65==. & yearsurvey==2014
replace pct65=TBD_mean_pct65est00 if pct65==. & yearsurvey==2012
replace pct65=TBD_mean_65est10/pop if pct65==. & yearsurvey==2012
replace pct65=TBD_mean_65est10/pop if pct65==. & yearsurvey==2012

gen hospnum10=TBD_mean_hospnum10 if yearsurvey==2012

/*
replace pct65=mean_65est12/pop if pct65==. & yearsurvey==2014
replace pct65=TBD_mean_65est10/pop if pct65==. & yearsurvey==2012
*/

replace povpct=TBD_mean_pctpov10 if povpct==. & yearsurvey==2012

replace collpct=TBD_mean_collpct0610 if collpct==. & yearsurvey==2012

replace fte=TBD_c5q37 if fte==. & yearsurvey==2012
replace exp=TBD_c3q15 if exp==. & yearsurvey==2012
replace prexp=TBD_c3q15a if prexp==. & yearsurvey==2012

replace fqhcnum=TBD_mean_fqhcs10 if fqhcnum==. & yearsurvey==2012
replace fqhcppov=fqhcnum/TBD_mean_perspov10*100000 if fqhcppov==. & yearsurvey==2012
replace admpcap=TBD_mean_hospadm10/pop*100000 if yearsurvey==2012


br juris pop boh exp emp fiscal fqhcnum admpcap TBD_mean_hospadm10 ///
if yearsurvey==2012

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb3.dta", replace
