/*Bringing in previous waves of NLSPHS data*/
use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214.dta", clear
keep if yearsurvey==1998
keep if survresp!=.
count


keep nacchoid peer
duplicates list nacchoid

sort nacchoid
save peer98, replace 


use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_98061214.dta", clear
sort nacchoid
save NLSPHS_AllWaves, replace

use peer98, clear

merge 1:m nacchoid using NLSPHS_AllWaves
tab peer yearsurvey
replace peer=. if yearsurvey==2006 & survresp==. // create blank filed for peer for those that were not sampled in 2006
save NLSPHS_AllWaves_peer, replace

br peer Arm if Arm<4 & Arm>1 

/*We will be doing cluster analysis using some variables from AHRF file to create peer grouping for the small size jurisdictions*/ 
keep if Arm<4 & Arm>1 
keep nacchoid id1998 id2006 id2012 unid state* yearsurvey survresp Arm pop13
sort nacchoid
save NLSPHS14_Arm23, replace
count

/*
. count
  556
*/


import excel "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NACCHO_2013_LHDBoundaries_JurisdictionTable.xlsx", sheet("Jurisdiction Table") firstrow clear
rename NACCHO_ID nacchoid
sort nacchoid
save CNTYFIPS, replace

use NLSPHS14_Arm23, clear
merge nacchoid using CNTYFIPS

drop if Arm==.
duplicates list nacchoid

sort nacchoid

quietly by nacchoid: gen dup=cond(_N==1,0,_n) 
drop _merge
replace County_FIPS=substr(Cousub_FIPS,1,5) if County_FIPS==""
replace County_FIPS="39093" if County_FIPS=="" & Place_FIPS=="3925256"
replace County_FIPS="33011" if County_FIPS=="" & Place_FIPS=="3350260"
replace County_FIPS="09009" if County_FIPS=="" & Place_FIPS=="0982800"
replace County_FIPS="17031" if County_FIPS=="" & Place_FIPS=="1772676"
replace County_FIPS="55079" if County_FIPS=="" & Place_FIPS=="5585300"
replace County_FIPS="55101" if County_FIPS=="" & Place_FIPS=="5577925"
replace County_FIPS="42077" if County_FIPS=="" & Place_FIPS=="4206088"
replace County_FIPS="39017" if County_FIPS=="" & Place_FIPS=="3949840"
replace County_FIPS="09001" if County_FIPS=="" & Place_FIPS=="0955990"
replace County_FIPS="48071" if County_FIPS=="" & Place_FIPS=="4806128"
replace County_FIPS="23005" if County_FIPS=="" & Place_FIPS=="2360545"
replace County_FIPS="55079" if County_FIPS=="" & Place_FIPS=="5517975"
replace County_FIPS="09001" if County_FIPS=="" & Place_FIPS=="0918430"
replace County_FIPS="39167" if County_FIPS=="" & Place_FIPS=="3905424"
replace County_FIPS="09003" if County_FIPS=="" & Place_FIPS=="0908420"
replace County_FIPS="27053" if County_FIPS=="" & Place_FIPS=="2706616"
replace County_FIPS="55079" if County_FIPS=="" & Place_FIPS=="5527075"
replace County_FIPS="39139" if County_FIPS=="" & Place_FIPS=="3972102"
replace County_FIPS="55079" if County_FIPS=="" & Place_FIPS=="5532075"
replace County_FIPS="34031" if County_FIPS=="" & nacchoid=="NJ014"
replace County_FIPS="13197" if County_FIPS=="" & nacchoid=="GA101"
replace County_FIPS="13293" if County_FIPS=="" & nacchoid=="GA152"
replace County_FIPS="34033" if County_FIPS=="" & nacchoid=="NJ098"

sort County_FIPS
save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS_multijuris2013.dta", replace
save lrt1, replace
list nacchoid id1998 id2006 id2012 GIS_Cat dup if dup>1
br nacchoid id1998 id2006 id2012 GIS_Cat dup if dup==1
keep if dup>0
save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\multijuris2013.dta", replace
use lrt1, clear
drop if dup>1
count
/*
. count
  556
*/

sort County_FIPS

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS.dta", replace

/*
C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS_multijuris2013.dta

This data has duplicates nacchoid becuase of multicounty jurisdiction with the same nacchoid.
We will use aggregate information for the variables to use in cluster analysis using mulitple FIPS 
for same NACCHOIDs. From here we will use sas.

AHRF2014.sas which gives an OUTFILE= "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\AHRF1314_trunc.dta" 

*/

use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\AHRF1314_trunc.dta", clear
rename county_fips County_FIPS
sort County_FIPS

duplicates list County_FIPS

sort County_FIPS
 
save AHRF1314_trunc, replace

*merge County_FIPS using "X:\xDATA\NLSPHS 2014\Analysis\data\NLSPHS14_Arm23_FIPS.dta"
merge 1:m County_FIPS using "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS_multijuris2013.dta"

drop if Arm==. /*Limiting to our sample in the study*/
drop _merge

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS_for_Clustering.dta", replace

use "C:\Users\Lava\Dropbox\Data\NACCHO2013\2013 Profile_id.dta", clear
keep nacchoid c6q84a	c6q84b	c6q84i	c6q84f	c6q84g
sort nacchoid
save NACCHO2013EnviHlth, replace

use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS_for_Clustering.dta", clear
*drop _merge
sort nacchoid 

merge 1:1 nacchoid using NACCHO2013EnviHlth
count
drop if Arm==.
count
/*
. count
  556
*/

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS14_Arm23_FIPS_for_Clustering_final.dta", replace

/*
drop if f00008!=""

keep f0453710 f0978112 f1440808 nacchoid pop13 LHD_Name State Area Place_FIPS Cousub_FIPS GIS_Cat

save "X:\xDATA\NLSPHS 2014\Analysis\data\Arveen.dta", replace


import excel "X:\xDATA\NLSPHS 2014\Analysis\data\Arveen_Completed_Final.xlsx", sheet("Data") firstrow clear
keep f0453710 f0978112 f1440808 nacchoid Arm state2 state State pop13 Place_FIPS c6q84a
save arveen, replace



use "X:\xDATA\NLSPHS 2014\Analysis\data\NLSPHS14_Arm23_FIPS_for_Clustering_final.dta", clear

keep if f00008!=""
keep f0453710 f0978112 f1440808 nacchoid Arm state2 state State pop13 Place_FIPS c6q84a
save clust_trunc, replace
append using arveen
replace State0=State if State0==""
replace State0="MO" if nacchoid=="MOXXX"
*/

count

gen epi_direct=1 if c6q84a==1
replace epi_direct=0 if epi_direct==.

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_Small_Clustering.dta", replace
export excel using "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHS_Small_Clustering.xls", firstrow(variables) replace

/*Work in SAS to create "X:\xDATA\NLSPHS 2014\Analysis\data\SMALL_PEER_FINAL.dta". This dataset will have nacchoid and peer grouping vreated from cluster analysis using PROC FASTCLUS*/

