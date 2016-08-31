use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb5.dta", clear
gen TBD_UNID=_n
save full_lrt, replace
keep if yearsurvey==2014

keep TBD_UNID yearsurvey survresp arm large av1-av20 lhd1-lhd19 eff1-eff19 sha1-sha19 sha20 ///
sao1-sao19 sao20 loc1-loc19 loc20 fed1-fed19 fed20 phy1-phy19 phy20 ///
hsp1-hsp19 hsp20 chc1-chc19 chc20 fbo1-fbo19 fbo20 nono1-nono19 nono20 ///
ins1-ins19 ins20 emp1-emp19 emp20 sch1-sch19 sch20 uni1-uni19 uni20 oth1-oth19 oth20 ///
none1-none19 none20 

export excel using "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\CPHS Trend\QC\NLSPHS2014_raw.xlsx", firstrow(variables) replace
 
/*Then use C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\nlsphs2014_2_withSNAandTBD_UNID.sas
The output from this file will be:
C:\Users\LRTI222\Dropbox\Data\NLSPHS\Glen\nlsphs2014_SNAandCLUSTTOT.dta
This data will have TBD_unid as merging variable*/

use "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Glen\nlsphs2014_SNAandCLUSTTOT.dta", clear

foreach x of var * { 
	rename `x' `x'_clussna 
} 

rename tbd_unid_clussna TBD_UNID

sort TBD_UNID
save clussna, replace

use full_lrt, clear
sort TBD_UNID

merge 1:1 TBD_UNID using clussna
/*
forval j = 1/15 {
foreach x of varlist  orgass`j' {
         replace `x' = `x'_clussna if yearsurvey==2014
}
}

forval j = 1/15 {
foreach x of varlist  orgpol`j' {
         replace `x' = `x'_clussna if yearsurvey==2014
}
}

forval j = 1/15 {
foreach x of varlist  orgasr`j' {
         replace `x' = `x'_clussna if yearsurvey==2014
}
}

forval j = 1/15 {
foreach x of varlist  orgtot`j' {
         replace `x' = `x'_clussna if yearsurvey==2014
}
}

forval j = 1/19 {
foreach x of varlist  sta`j' {
         replace `x' = `x'_clussna if yearsurvey==2014
}
}
foreach x of varlist  staass stapol staasr statot {
         replace `x' = `x'_clussna if yearsurvey==2014
}

replace staany=staany_clussna if yearsurvey==2014

*/


local clustsna sha1 sha2 sha3 sha4 sha5 sha6 sha7 sha8 sha9 sha10 ///
sha11 sha12 sha13 sha14 sha15 sha16 sha17 sha18 sha19 sao1 sao2  ///
sao3 sao4 sao5 sao6 sao7 sao8 sao9 sao10 sao11 sao12 sao13 ///
sao14 sao15 sao16 sao17 sao18 sao19 loc1 loc2 loc3 loc4 loc5 ///
loc6 loc7 loc8 loc9 loc10 loc11 loc12 loc13 loc14 loc15 loc16 ///
loc17 loc18 loc19 fed1 fed2 fed3 fed4 fed5 fed6 fed7 fed8 fed9 ///
fed10 fed11 fed12 fed13 fed14 fed15 fed16 fed17 fed18 fed19 phy1 ///
phy2 phy3 phy4 phy5 phy6 phy7 phy8 phy9 phy10 phy11 phy12 phy13 ///
phy14 phy15 phy16 phy17 phy18 phy19 hsp1 hsp2 hsp3 hsp4 hsp5 hsp6 ///
hsp7 hsp8 hsp9 hsp10 hsp11 hsp12 hsp13 hsp14 hsp15 hsp16 hsp17 hsp18 ///
hsp19 chc1 chc2 chc3 chc4 chc5 chc6 chc7 chc8 chc9 chc10 chc11 ///
chc12 chc13 chc14 chc15 chc16 chc17 chc18 chc19 fbo1 fbo2 fbo3 fbo4 ///
fbo5 fbo6 fbo7 fbo8 fbo9 fbo10 fbo11 fbo12 fbo13 fbo14 fbo15 fbo16 ///
fbo17 fbo18 fbo19 nono1 nono2 nono3 nono4 nono5 nono6 nono7 nono8 nono9 ///
nono10 nono11 nono12 nono13 nono14 nono15 nono16 nono17 nono18 nono19 ins1 ///
ins2 ins3 ins4 ins5 ins6 ins7 ins8 ins9 ins10 ins11 ins12 ins13 ///
ins14 ins15 ins16 ins17 ins18 ins19 emp1 emp2 emp3 emp4 emp5 emp6 ///
emp7 emp8 emp9 emp10 emp11 emp12 emp13 emp14 emp15 emp16 emp17 emp18 ///
emp19 sch1 sch2 sch3 sch4 sch5 sch6 sch7 sch8 sch9 sch10 sch11 ///
sch12 sch13 sch14 sch15 sch16 sch17 sch18 sch19 uni1 uni2 uni3 uni4 ///
uni5 uni6 uni7 uni8 uni9 uni10 uni11 uni12 uni13 uni14 uni15 uni16 ///
uni17 uni18 uni19 oth1 oth2 oth3 oth4 oth5 oth6 oth7 oth8 oth9 ///
oth10 oth11 oth12 oth13 oth14 oth15 oth16 oth17 oth18 oth19 ///
yearsurvey sha20 sao20 loc20 fed20 phy20 hsp20 chc20 fbo20 nono20 ins20 ///
emp20 sch20 uni20 oth20 none1 none2 none3 none4 none5 none6 none7 none8 ///
none9 none10 none11 none12 none13 none14 none15 none16 none17 none18 none19 ///
none20 arm large eff20 lhd20 pct1 pct2 pct3 pct4 pct5 pct6 pct7 ///
pct8 pct9 pct10 pct11 pct12 pct13 pct14 pct15 pct16 pct17 pct18 pct19 ///
pct20 i j k avass avpol avasr avtot effass effpol effasr efftot ///
lhdass lhdpol lhdasr lhdtot pctass pctpol pctasr pcttot orgass1 orgass2 orgass3 ///
orgass4 orgass5 orgass6 orgass7 orgass8 orgass9 orgass10 orgass11 orgass12 orgass13 ///
orgass14 orgass15 orgpol1 orgpol2 orgpol3 orgpol4 orgpol5 orgpol6 orgpol7 orgpol8 ///
orgpol9 orgpol10 orgpol11 orgpol12 orgpol13 orgpol14 orgpol15 orgasr1 orgasr2 orgasr3 ///
orgasr4 orgasr5 orgasr6 orgasr7 orgasr8 orgasr9 orgasr10 orgasr11 orgasr12 orgasr13 ///
orgasr14 orgasr15 orgtot1 orgtot2 orgtot3 orgtot4 orgtot5 orgtot6 orgtot7 orgtot8 ///
orgtot9 orgtot10 orgtot11 orgtot12 orgtot13 orgtot14 orgtot15 shaass shapol shaasr ///
shatot saoass saopol saoasr saotot locass locpol locasr loctot fedass fedpol ///
fedasr fedtot phyass phypol phyasr phytot hspass hsppol hspasr hsptot chcass ///
chcpol chcasr chctot fboass fbopol fboasr fbotot nonoass nonopol nonoasr nonotot ///
insass inspol insasr instot empass emppol empasr emptot schass schpol schasr ///
schtot uniass unipol uniasr unitot othass othpol othasr othtot noneass nonepol ///
noneasr nonetot sta1 sta2 sta3 sta4 sta5 sta6 sta7 sta8 sta9 sta10 ///
sta11 sta12 sta13 sta14 sta15 sta16 sta17 sta18 sta19 staass stapol staasr ///
statot non1 non2 non3 non4 non5 non6 non7 non8 non9 non10 non11 non12 ///
non13 non14 non15 non16 non17 non18 non19 nonass nonpol nonasr nontot shaany ///
saoany staany locany fedany phyany hosany chcany fboany nonoany insany empany ///
schany uniany othany noneany hiparsta hiparloc hiparnon hiparhsp hiparphy hiparchc ///
hiparuni hiparfed hiparins hiparoth hiparsum hipargov hiparcli hiparots clustpart lhdeff1 ///
lhdeff2 lhdeff3 clustlhd clustav loav lopart lolhd avass_new avpol_new avasr_new avtot_new ///
effass_new effpol_new effasr_new efftot_new lhdass_new lhdpol_new lhdasr_new lhdtot_new lhdn1 ///
lhdn2 lhdn3 lhdn4 lhdn5 lhdn6 lhdn7 lhdn8 lhdn9 lhdn10 lhdn11 lhdn12 lhdn13 ///
lhdn14 lhdn15 lhdn16 lhdn17 lhdn18 lhdn19 numorgs servdens scent1 scent2 scent3 ///
scent4 scent5 scent6 scent7 scent8 scent9 scent10 scent11 scent12 scent13 scent14 ///
scent15 scent16 scent17 scent18 scent19 maxscent servcent org1_1 org1_2 org1_3 ///
org1_4 org1_5 org1_6 org1_7 org1_8 org1_9 org1_10 org1_11 org1_12 org1_13 org1_14 ///
org2_1 org2_2 org2_3 org2_4 org2_5 org2_6 org2_7 org2_8 org2_9 org2_10 org2_11 ///
org2_12 org2_13 org2_14 org3_1 org3_2 org3_3 org3_4 org3_5 org3_6 org3_7 org3_8 ///
org3_9 org3_10 org3_11 org3_12 org3_13 org3_14 org4_1 org4_2 org4_3 org4_4 org4_5 ///
org4_6 org4_7 org4_8 org4_9 org4_10 org4_11 org4_12 org4_13 org4_14 org5_1 org5_2 ///
org5_3 org5_4 org5_5 org5_6 org5_7 org5_8 org5_9 org5_10 org5_11 org5_12 org5_13 ///
org5_14 org6_1 org6_2 org6_3 org6_4 org6_5 org6_6 org6_7 org6_8 org6_9 org6_10 ///
org6_11 org6_12 org6_13 org6_14 org7_1 org7_2 org7_3 org7_4 org7_5 org7_6 org7_7 ///
org7_8 org7_9 org7_10 org7_11 org7_12 org7_13 org7_14 org8_1 org8_2 org8_3 org8_4 ///
org8_5 org8_6 org8_7 org8_8 org8_9 org8_10 org8_11 org8_12 org8_13 org8_14 org9_1 ///
org9_2 org9_3 org9_4 org9_5 org9_6 org9_7 org9_8 org9_9 org9_10 org9_11 org9_12 ///
org9_13 org9_14 org10_1 org10_2 org10_3 org10_4 org10_5 org10_6 org10_7 org10_8 org10_9 ///
org10_10 org10_11 org10_12 org10_13 org10_14 org11_1 org11_2 org11_3 org11_4 org11_5 ///
org11_6 org11_7 org11_8 org11_9 org11_10 org11_11 org11_12 org11_13 org11_14 org12_1 ///
org12_2 org12_3 org12_4 org12_5 org12_6 org12_7 org12_8 org12_9 org12_10 org12_11 ///
org12_12 org12_13 org12_14 org13_1 org13_2 org13_3 org13_4 org13_5 org13_6 org13_7 ///
org13_8 org13_9 org13_10 org13_11 org13_12 org13_13 org13_14 org14_1 org14_2 org14_3 ///
org14_4 org14_5 org14_6 org14_7 org14_8 org14_9 org14_10 org14_11 org14_12 org14_13 ///
org14_14 orgdens ocent1 ocent2 ocent3 ocent4 ocent5 ocent6 ocent7 ocent8 ocent9 ///
ocent10 ocent11 ocent12 ocent13 ocent14 maxocent orgcent betw1 betw2 betw3 betw4 ///
betw5 betw6 betw7 betw8 betw9 betw10 betw11 betw12 betw13 betw14

foreach x of local clustsna {
replace `x'=`x'_clussna if yearsurvey==2014
}

/*clusttot clusttot1 clusttot2 clusttot3 clusttot4 clusttot5 clusttot6 clusttot7 */
replace clusttot=clusttot_clussna if yearsurvey==2014
replace clusttot_rec=clusttot_clussna if yearsurvey==2014
forvalues i=1/7 {
replace clust`i'=clusttot`i'_clussna if yearsurvey==2014
}

forvalues i=1/7 {
replace clusttot`i'_rec=clusttot`i'_clussna if yearsurvey==2014
}

drop TBD_UNID - _merge

tab clusttot yearsurvey if large==1, col

recode clusttot (1/3=1) (4/5=2) (6/7=3), gen(phtyp)
recode clusttot (1/3=1) (4/7=0), gen(comp)

tab phtyp yearsurvey, col

save "X:\xDATA\NLSPHS 2014\Analysis\AnalyticalFiles\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb6.dta", replace

save "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb6.dta", replace
