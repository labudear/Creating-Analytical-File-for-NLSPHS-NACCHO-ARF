/*Let us make the data look similar to nlsphs_tot.dta*/
use "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb.dta", clear
lookfor fte
bysort yearsurvey: sum fte
bysort yearsurvey: sum c5q37
replace fte=c5q37 if yearsurvey>2006 // replace all those fte==.

replace ftecap=c5q37/pop*100000 if yearsurvey>2006
bysort yearsurvey: sum ftecap

order id1998 id2006 lhdnm06 lhdadd06 lhdcit06 lhdst06 lhdzip06 lhdsal06 lhdex06 lhdtit06 agency06 st06 namef_06 namem_06 namel_06 title06 phone06 fax06 addr1_06 addr2_06 addr3_06 addcy_06 addst_06 ///
zip_06 email_06 county_06 ptcnty_06 av1 av2 av3 av4 av5 av6 av7 av8 av9 av10 av11 av12 av13 av14 av15 av16 av17 av18 av19 av20 eff1 eff2 eff3 eff4 eff5 eff6 eff7 eff8 eff9 eff10 eff11 eff12 eff13 eff14 ///
eff15 eff16 eff17 eff18 eff19 lhd1 lhd2 lhd3 lhd4 lhd5 lhd6 lhd7 lhd8 lhd9 lhd10 lhd11 lhd12 lhd13 lhd14 lhd15 lhd16 lhd17 lhd18 lhd19 pct1 pct2 pct3 pct4 pct5 pct6 pct7 pct8 pct9 pct10 pct11 pct12 pct13 ///
pct14 pct15 pct16 pct17 pct18 pct19 avass avpol avasr avtot effass effpol effasr efftot lhdass lhdpol lhdasr lhdtot pctass pctpol pctasr pcttot sha1 sha2 sha3 sha4 sha5 sha6 sha7 sha8 sha9 sha10 sha11 ///
sha12 sha13 sha14 sha15 sha16 sha17 sha18 sha19 shaass shapol shaasr shatot sao1 sao2 sao3 sao4 sao5 sao6 sao7 sao8 sao9 sao10 sao11 sao12 sao13 sao14 sao15 sao16 sao17 sao18 sao19 saoass saopol saoasr ///
saotot sta1 sta2 sta3 sta4 sta5 sta6 sta7 sta8 sta9 sta10 sta11 sta12 sta13 sta14 sta15 sta16 sta17 sta18 sta19 staass stapol staasr statot loc1 loc2 loc3 loc4 loc5 loc6 loc7 loc8 loc9 loc10 loc11 loc12 ///
loc13 loc14 loc15 loc16 loc17 loc18 loc19 locass locpol locasr loctot fed1 fed2 fed3 fed4 fed5 fed6 fed7 fed8 fed9 fed10 fed11 fed12 fed13 fed14 fed15 fed16 fed17 fed18 fed19 fedass fedpol fedasr fedtot ///
phy1 phy2 phy3 phy4 phy5 phy6 phy7 phy8 phy9 phy10 phy11 phy12 phy13 phy14 phy15 phy16 phy17 phy18 phy19 phyass phypol phyasr phytot hsp1 hsp2 hsp3 hsp4 hsp5 hsp6 hsp7 hsp8 hsp9 hsp10 hsp11 hsp12 hsp13 ///
hsp14 hsp15 hsp16 hsp17 hsp18 hsp19 hspass hsppol hspasr hsptot chc1 chc2 chc3 chc4 chc5 chc6 chc7 chc8 chc9 chc10 chc11 chc12 chc13 chc14 chc15 chc16 chc17 chc18 chc19 chcass chcpol chcasr chctot fbo1 ///
fbo2 fbo3 fbo4 fbo5 fbo6 fbo7 fbo8 fbo9 fbo10 fbo11 fbo12 fbo13 fbo14 fbo15 fbo16 fbo17 fbo18 fbo19 fboass fbopol fboasr fbotot nono1 nono2 nono3 nono4 nono5 nono6 nono7 nono8 nono9 nono10 nono11 nono12 ///
nono13 nono14 nono15 nono16 nono17 nono18 nono19 nonoass nonopol nonoasr nonotot non1 non2 non3 non4 non5 non6 non7 non8 non9 non10 non11 non12 non13 non14 non15 non16 non17 non18 non19 nonass nonpol ///
nonasr nontot ins1 ins2 ins3 ins4 ins5 ins6 ins7 ins8 ins9 ins10 ins11 ins12 ins13 ins14 ins15 ins16 ins17 ins18 ins19 insass inspol insasr instot emp1 emp2 emp3 emp4 emp5 emp6 emp7 emp8 emp9 emp10 emp11 ///
emp12 emp13 emp14 emp15 emp16 emp17 emp18 emp19 empass emppol empasr emptot sch1 sch2 sch3 sch4 sch5 sch6 sch7 sch8 sch9 sch10 sch11 sch12 sch13 sch14 sch15 sch16 sch17 sch18 sch19 schass schpol schasr ///
schtot uni1 uni2 uni3 uni4 uni5 uni6 uni7 uni8 uni9 uni10 uni11 uni12 uni13 uni14 uni15 uni16 uni17 uni18 uni19 uniass unipol uniasr unitot oth1 oth2 oth3 oth4 oth5 oth6 oth7 oth8 oth9 oth10 oth11 oth12 ///
oth13 oth14 oth15 oth16 oth17 oth18 oth19 othass othpol othasr othtot peer ///
oldid newid nacchoid year lhdname city state zip juris pop racewh racebl raceam raceas racehs tribal boh bohgov bohpol bohadv bohele exp prexp revcit revcou revsta revpass revfed revmaid revmare revfou ///
revins revpat revfee revtri revoth revbtcdc revbthrs emp fte ftenur ftephy ftesan fteehs fteepi fteedu ftenut ftesw jurcity jurcnty jurccty jurtown jurdist jurstat jurothr svaimm svcimm svhivs svhivt svstds ///
svstdt svtubs svtubt svcan svcvd svdia svhbp svlea svfam svprn svobs svwic sveps svpri svhom svora svmen svsub svtob svinj svani svocc svvet svlab svsbc svsch svems svepid svaimmc svcimmc svhivsc svhivtc ///
svstdsc svstdtc svtubsc svtubtc svcanc svcvdc svdiac svhbpc svleac svfamc svprnc svobsc svwicc svepsc svpric svhomc svorac svmenc svsubc svtobc svinjc svanic svoccc svvetc svlabc svsbcc svschc svemsc svepidc ///
rgcosm rgpool rgfdmk rgfdsr rgpubw rgpriw rghfac ehiair ehradi ehvect ehgwat ehswat ehresp ehhazw ehnois rgcosmc rgpoolc rgfdmkc rgfdsrc rgpubwc rgpriwc rghfacc ehiairc ehradic ehvectc ehgwatc ehswatc ///
ehrespc ehhazwc ehnoisc fiscal popcat zip_code latitude longitude zip_class poname fipsst fipsco revclin cpiadj mcpiadj expadj expaclin expapop nfipsst nfipsco nzip hspnum fqhcnum hmoenr98 popco popco04 popco96 ///
popco92 medage00 cregion msa rururb urbinf econtype typefarm typemine typemanu typegovt typeserv typenons typehous typeeduc typeempl typeppov typepopl hpsa imrtot imrwh imrnonwh incpcap medinc uninstot unemp ///
popdens hmopen98 hmocmp98 ncounties multij arfhead modfips cdivis fregion msacode csacode contig1 contig2 contig3 contig4 contig5 contig6 contig7 contig8 contig9 contig10 contig11 contig12 contig13 contig14 ///
popimp93 popimp97 popimp05 demergepre demerge merge mergepre expcap expadjcap expc expp aexpc aexpp expccap exppcap aexpccap aexppcap ftecap scopprev scoptx scopspec scoppop scopreg scopeh msametro msamicro ///
hpsaany mdpcap hspany admpcap bedpcap alos erpcap fqhcany fqhcppov pctnonwh pct65 pctneng lbwrat lbwratb lbwratw pctnoprn dratinf draneo draihd draflu dracopd dradiab dratot povpct collpct central mixed clusttot ///
clust1 clust2 clust3 clust4 clust5 clust6 clust7 survresp survsamp yearnaccho yearsurvey id2012 subdate lhdnm12 lhdadd12 lhdadd212 lhdcit12 lhdst12 lhdzip12 lhdtit12 namef_12 namel_12 phone12 email_12 counties1 ///
counties2 eff20 lhd20 sha20 sao20 loc20 fed20 phy20 hsp20 chc20 fbo20 nono20 ins20 emp20 sch20 uni20 oth20 none1 none2 none3 none4 none5 none6 none7 none8 none9 none10 none11 none12 none13 none14 none15 none16 none17 ///
none18 none19 none20 overallph overallhe dissemail pct20 i j k orgass1 orgass2 orgass3 orgass4 orgass5 orgass6 orgass7 orgass8 orgass9 orgass10 orgass11 orgass12 orgass13 orgass14 orgass15 orgpol1 orgpol2 orgpol3 orgpol4 ///
orgpol5 orgpol6 orgpol7 orgpol8 orgpol9 orgpol10 orgpol11 orgpol12 orgpol13 orgpol14 orgpol15 orgasr1 orgasr2 orgasr3 orgasr4 orgasr5 orgasr6 orgasr7 orgasr8 orgasr9 orgasr10 orgasr11 orgasr12 orgasr13 orgasr14 orgasr15 ///
orgtot1 orgtot2 orgtot3 orgtot4 orgtot5 orgtot6 orgtot7 orgtot8 orgtot9 orgtot10 orgtot11 orgtot12 orgtot13 orgtot14 orgtot15 noneass nonepol noneasr nonetot revloc revfed2 revother comsys consys limsys

replace lhdname=c1q1 if lhdname==""
replace lhdname=lhd_name if lhdname==""

replace city=c1q7 if city==""

gen str2 state2014 = substr(nacchoid,1,2)

replace state=state2014 if state==""

replace zip=c1q9 if zip==""
replace zip=lhdzip12 if zip==""
rename zip zip_old

gen str5 zip_rec = substr(zip_old,1,5)

replace juris=1 if juris==. & jurcity==1
replace juris=2 if juris==. & jurcnty==1
replace juris=3 if juris==. & jurccty==1
replace juris=4 if juris==. & jurtown==1
replace juris=5 if juris==. & jurdist==1
replace juris=6 if juris==. & jurstat==1
replace juris=7 if juris==. & jurothr==1

tab c0jurisdiction
gen jurmcity=(c0jurisdiction=="multi-city") if yearsurvey>=2012
gen jurmcnty=(c0jurisdiction=="multi-county") if yearsurvey>=2012
gen jurctycnty=(c0jurisdiction=="city-county") if yearsurvey>=2012

replace juris=1 if juris==. & c0jurisdiction=="city"
replace juris=2 if juris==. & c0jurisdiction=="county"
replace juris=8 if juris==. & jurmcity==1
replace juris=9 if juris==. & jurmcnty==1
replace juris=10 if juris==. & jurctycnty==1

br nacchoid yearsurvey juris c0jurisdiction

/****NEED TO IMPUTE FOLLOWING VARIABLES*******/
/*
population for 2012
racewh
racebl 
raceam
raceas
racehs
tribal lands included in jurisdiction
bohgov
bohpol
bohadv
bohele

LHD revenues and sources

FTE by occupation categories

LHD services by type
LHD services contract
LHD regulates
LHD environmental health
LHD regulates contract
LHD environmental health contract

latitude
longitude

COUNTY_FIPS for 2012

CPI adjustment factor
CPI medical adjustment factor

(Not Mean) Number of hospitals in jurisdiction
create hospany (for 1998, 2006 rename hspanyhospany)

(Not Mean) Number of FQHCs in jurisdictions

HMO enrollment in jurisdictions

Economy type- by types

Health Professional Shortage Area Type
create hpsaany

Infant Mortality Rate- total, wh, nonwh

incpcap for YEAR 2012 from census 2010

MEDIAN INCOME for YEAR 2012 from census 2010 & 2014 from 2012

UNINSTOT for YEAR 2012 from census 2010 

UNEMP fpr YEAR 2012 from 2012

land area for 2012 for calculating pop density

HMO penetration (1998)
HMO competition index (1998)

expadjusted

LHD scope of services offered by type

mdpcap for 2012

Hospital admission per capita: admpcap fro 2012 and 2014
ER admission per capita: erpcap fro 2012 and 2014

bedpcap for 2012

Average hospital length of stay (alos) for 2012 and 2014

FQHCNUM, FQHSANY FQHCPPOV (FQHC per 100,000 people in poverty) for 2012 and 2014

PCTWH for 2012

LBW rate-Total, BLACK WHITE for 2012 and 2014

PCT of birth with no prenatal care for 2012 and 2014

Death rates for 2012 & 2014 :
	Infant death rate
	Neonatal death rate
	IHD death rate
	Influenza death rate
	COPD death rate
	Diabetes death rate
	Total death rate



*/

replace boh=c2q301dicot if boh==. & yearsurvey==2012
replace boh=c2q301 if boh==. & yearsurvey==2014

replace exp=c3q15 if exp==.
replace prexp=c3q15a if prexp==.

replace emp=c5q36 if emp==.

gen curfy = year(c3q14)
replace fiscal=curfy if fiscal==.

tab1 msametro msamicro
replace msametro=1 if msametro==. & f1406713=="1"
replace msametro=0 if msametro==. & yearsurvey==2014 & f1406713!=""
replace msamicro=1 if msamicro==. & f1406713=="2"
replace msamicro=0 if msamicro==. & yearsurvey==2014 & f1406713!=""


replace rururb=rucc if rururb==.
replace urbinf=urbinfc_min if urbinf==.

replace econtype=1 if econtype==. & f1397304=="01"
replace econtype=2 if econtype==. & f1397304=="02"
replace econtype=3 if econtype==. & f1397304=="03"
replace econtype=4 if econtype==. & f1397304=="04"
replace econtype=5 if econtype==. & f1397304=="05"
replace econtype=6 if econtype==. & f1397304=="06"

replace incpcap=mean_pcapinc12 if incpcap==. & yearsurvey==2014

replace uninstot=mean_pctnoins12 if uninstot==. & yearsurvey==2014

replace unemp=mean_unemppct13 if unemp==. & yearsurvey==2014

replace popdens=pop/mean_lndarea10 if popdens==. & (yearsurvey==2012 | yearsurvey==2014)

replace expcap=exp/pop if expcap==. & exp!=.

replace mdpcap=mean_mds12/pop*100000 if mdpcap==. & yearsurvey==2014

replace bedpcap=mean_bed11/pop*100000 if bedpcap==. & yearsurvey==2014

replace pctnonwh=(100-mean_pctwh10) if pctnonwh==. & yearsurvey==2014
replace pct65=mean_pct65est12 if pct65==. & yearsurvey==2014
replace pct65=mean_65est12/pop*100 if pct65==. & yearsurvey==2014
replace povpct=mean_pctpov12 if povpct==. & yearsurvey==2014
replace collpct=mean_collpct0812 if collpct==. & yearsurvey==2014

replace fqhcnum=mean_fqhcs13 if fqhcnum==. & yearsurvey==2014
replace fqhcppov=fqhcnum/mean_perspov12*100000 if fqhcppov==. & yearsurvey==2014
replace admpcap=mean_hospadm11/pop*100000 if yearsurvey==2014

sort state
save lrt, replace

import excel "C:\Users\Lava\Dropbox\Research Projects\Dissertation\NLSPHSData\CentralDecentral.xlsx", sheet("Sheet1") firstrow clear
gen central98=.
gen mixed98=.
replace central98=(NACCHO98=="Centralized")
replace mixed98=(NACCHO98=="Mixed")
gen central07=.
gen mixed07=.
replace central07=(ASTH07=="Centralized")
replace mixed07=(ASTH07=="Mixed")
gen central02=.
gen mixed02=.
replace central02=(PHF02=="Centralized")
replace mixed02=(PHF02=="Mixed")
gen central11=.
gen mixed11=.
replace central11=(NORC11=="Centralized" | NORC11=="Largely Centralized")
replace mixed11=(NORC11=="Mixed- Centralized & Decentralized" | NORC11=="Mixed- Decentralized & Centralized" | NORC11=="Mixed- Shared (State Led) & Decentralized")
gen central12=.
gen mixed12=.
replace central12=(ASTHO12=="Centralized" | ASTHO12=="Largely Centralized")
replace mixed12=(ASTHO12=="Mixed")
tab1 central98 central07 central02 central11 central12
tab1 mixed98 mixed07 mixed02 mixed11 mixed12
drop State NACCHO98 ASTH07 PHF02 NORC11 ASTHO12
rename stateabr state

sort state
save central, replace
use lrt, clear
drop _merge
merge m:1 state using central
replace central=central98 if central==. & yearsurvey==1998
replace central=central07 if central==. & yearsurvey==2006
replace central=central11 if central==. & yearsurvey==2012
replace central=central12 if central==. & yearsurvey==2014

replace mixed=mixed98 if mixed==. & yearsurvey==1998
replace mixed=mixed07 if mixed==. & yearsurvey==2006
replace mixed=mixed11 if mixed==. & yearsurvey==2012
replace mixed=mixed12 if mixed==. & yearsurvey==2014

drop central98 central07 central11 central12 mixed98 mixed07 mixed11 mixed12 _merge

replace clusttot=clusttot_rec if clusttot==. & yearsurvey>2006
forvalues i=1/7 {
replace clust`i'=clusttot`i'_rec if clust`i'==. & yearsurvey>2006
}

replace comsys=(clusttot_rec==1 | clusttot_rec==2 | clusttot_rec==3) if comsys==. & yearsurvey>2006 & survresp==1
replace consys=(clusttot_rec==4 | clusttot_rec==5 ) if consys==. & yearsurvey>2006 & survresp==1
replace limsys=(clusttot_rec==6 | clusttot_rec==7 ) if limsys==. & yearsurvey>2006 & survresp==1

tab arm
gen large=(arm==1) if arm!=.

save "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb2.dta", replace
