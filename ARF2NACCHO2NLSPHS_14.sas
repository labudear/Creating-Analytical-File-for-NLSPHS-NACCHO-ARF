/*Read ARF 2014 data*/
filename arf14 "C:\Users\LRTI222\Dropbox\Data\AHRF_2013-2014\DOC";
%include arf14(AHRF2014);

libname nac13 "C:\Users\LRTI222\Dropbox\Data\NACCHO2013";
data nac2013;
set nac13.NAC2013;
run;

proc freq data=nac2013;
tables c0jurisdiction;
run;

/*Splitting the dataset by type of jurisdictions*/

data nac13_cty nac13_ctycnty nac13_cnty nac13_mcty nac13_mcnty;
set nac2013;
if c0jurisdiction="city" then output nac13_cty; 
else if c0jurisdiction="city-county" then output nac13_ctycnty;
else if c0jurisdiction="county" then output nac13_cnty;
else if c0jurisdiction="multi-city" then output nac13_mcty;
else if c0jurisdiction="multi-county" then output nac13_mcnty;
run;

/*Creating dummy variables to identify type of jurisdiction*/
data nac13_cty;
set nac13_cty;
nac13city=1;
run;

data nac13_ctycnty;
set nac13_ctycnty;
nac13ctycnty=1;
run;

data nac13_cnty;
set nac13_cnty;
nac13cnty=1;
run;

data nac13_mcty;
set nac13_mcty;
nac13mcty=1;
run;

data nac13_mcnty;
set nac13_mcnty;
nac13mcnty=1;
run;

proc sort data=nac13_cty;
by nacchoid;
run;

proc sort data=nac13_ctycnty;
by nacchoid;
run;

proc sort data=nac13_cnty;
by nacchoid;
run;

proc sort data=nac13_mcty;
by nacchoid;
run;

proc sort data=nac13_mcnty;
by nacchoid;
run;

/*Importing naccho boundary files*/

PROC IMPORT OUT= WORK.nacbound13 
            DATAFILE= "C:\Users\LRTI222\Dropbox\Data\NACCHO2013\nacchobound13.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="'Jurisdiction Table$'"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data nacbound13 (rename=(NACCHO_ID=nacchoid));
set nacbound13;
run;

proc freq data=nacbound13;
tables GIS_Cat;
run;

/*Splitting the boundary files into GIS_Categories (jurisidiction types)*/
data nacbnd_cty;
set nacbound13;
where GIS_Cat="single city";
run;

data nacbnd_mcty;
set nacbound13;
where GIS_Cat="multi-city";
run;

data nacbnd_mcnty;
set nacbound13;
where GIS_Cat="multi-county" ;
run;

data nacbnd_ctycnty;
set nacbound13;
where GIS_Cat="multi-county" | GIS_Cat="multi-city";
run;

data nacbnd_cnty;
set nacbound13;
where GIS_Cat="single county";
run;

data nacbnd_cmplx;
set nacbound13;
where GIS_Cat="complex";
run;

proc sort data=nacbnd_cty;
by nacchoid;
run;

/*Linking naccho data with the naccho boundary file to get FIPS code*/
data city;
merge nac13_cty nacbnd_cty;
by nacchoid;
run;

proc freq data=city;
tables nac13city;
run;

data cityonly;
set city;
where nac13city=1;
run;

proc sort data=nacbnd_ctycnty;
by nacchoid;
run;

data citycounty;
merge nac13_ctycnty nacbnd_ctycnty;
by nacchoid;
run;

proc freq data=citycounty;
tables nac13ctycnty;
run;

data citycountyonly;
set citycounty;
where nac13ctycnty=1;
run;

proc sort data=nacbnd_cnty;
by nacchoid;
run;

data county;
merge nac13_cnty nacbnd_cnty;
by nacchoid;
run;

proc freq data=county;
tables nac13cnty;
run;

data countyonly;
set county;
where nac13cnty=1;
run;

/*1:m match merge data sets from naccho and nacchobound*/
proc sort data=nacbnd_mcty;
by nacchoid;
run;

data multicity;
merge nac13_mcty nacbnd_mcty;
by nacchoid;
run;

proc freq data=multicity;
tables nac13mcty;
run;

data multicityonly;
set multicity;
where nac13mcty=1;
run;

/*1:m match merge*/
proc sort data=nacbnd_mcnty;
by nacchoid;
run;

data multicounty;
merge nac13_mcnty nacbnd_mcnty;
by nacchoid;
run;

proc freq data=multicounty;
tables nac13mcnty;
run;

data multicountyonly;
set multicounty;
where nac13mcnty=1;
run;

data naccho13fips;
set cityonly countyonly citycountyonly multicityonly multicountyonly;
run;

/*
data nac2013;
set nac2013;
frmnaccho=1;
run;

proc sort data=nac2013;
by nacchoid;
proc sort data=nacbound13;
by nacchoid;
run;

data naccho13fips_alt;
merge nac2013 nacbound13;
by nacchoid;
run;

proc freq data=naccho13fips_alt;
tables frmnaccho;
run;

proc sort data=naccho13fips;
by nacchoid;
proc sort data=naccho13fips_alt;
by nacchoid;
run;

*naccho13fips_alt will include those jurisdictions who did not respond to naccho13. Recommended to use naccho13fips as an output;
*/

data naccho13fips_A (drop=State--Notes);
set naccho13fips;
where LHD_Name="";
complex=1;
run;

proc sort data=nacbnd_cmplx;
by nacchoid;
proc sort data=naccho13fips_A;
by nacchoid;
run;

data complex;
merge naccho13fips_A nacbnd_cmplx;
by nacchoid;
run;

proc freq data=complex;
tables complex;
run;

data complexonly;
set complex;
where complex=1;
run;

data naccho13fips_B ;
set naccho13fips;
where LHD_Name ne "";
run;

data naccho13fips_C;
set naccho13fips_B complexonly;
run;

proc freq data=naccho13fips_C;
tables c0govcat;
run;

data naccho13fips_C1;
set naccho13fips_C;
if County_FIPS=. then do;
County_FIPS=SUBSTR(Cousub_FIPS,1,5);
end;
run;

data naccho13fips_D naccho13fips_E;
set naccho13fips_C1;
if County_FIPS ne "" then output naccho13fips_D; else output naccho13fips_E;
run;

data tobeimpFIPS14 (keep=nacchoid c0state c1q1 c1q7 c1q9 County_FIPS Place_FIPS Cousub_FIPS Jurisdiction);
set naccho13fips_E;
run;

/*Using zip codes with county fips file to impute missing county_fips in naccho file such that each nacchoid will have its county fips linked*/
data Tobeimpfips14;
set Tobeimpfips14;
*ZIP_TBD=SCAN(c1q9, 1,'-');
*ZIP_TBD2=put(input(ZIP_TBD,best5.),z5.);
ZIP=put(input(SCAN(c1q9, 1,'-'),best5.),z5.);
run;

libname zip "C:\Users\LRTI222\Dropbox\Data\NACCHO2013";

data zip15 (keep=ZIP STATE COUNTY);
set zip.Zipcode_15q2_unique;
run;

data zip15 (keep=ZIP2 TBDCOUNTYFIPS);
set zip15;
ZIP1=put(ZIP,5. -L);
ZIP2=put(input(ZIP1,best5.),z5.);

TBDSTFIPS=put(STATE,best2.);
TBDSTFIPS2=put(input(TBDSTFIPS,best2.),z2.);
TBDCNTYFIPS=put(COUNTY,best3.);
TBDCNTYFIPS2=put(input(TBDCNTYFIPS,best3.),z3.);
TBDCOUNTYFIPS=CAT(TBDSTFIPS2,TBDCNTYFIPS2);
run;

data ZIP15 (rename=(ZIP2=ZIP));
set ZIP15;
run;

proc sort data=Tobeimpfips14;
by ZIP;
proc sort data=zip15;
by ZIP;
run;

data IMPFIPS14;
merge Tobeimpfips14 zip15;
by zip;
run;

data IMPFIPS14 (keep=nacchoid TBDCOUNTYFIPS);
set IMPFIPS14;
where nacchoid ne "";
run;

proc sort data=naccho13fips_C1;
by nacchoid;
proc sort data=IMPFIPS14;
by nacchoid;
run;

data naccho13fips_C1imp;
merge naccho13fips_C1 IMPFIPS14;
by nacchoid;
run;

data naccho13WITHALLFIPS (drop=nac13cnty--TBDCOUNTYFIPS);
set naccho13fips_C1imp;
if COUNTY_FIPS= "" then do;
COUNTY_FIPS=TBDCOUNTYFIPS;
end;
run;

/*No missing values for County_FIPS in naccho 2013. naccho13WITHALLFIPS dataset will have multi-county jurisdiction
split into its constituent counties. At some point later we need to request only unique nacchoids to get the dataset
for each naccho profile survey 2013 respondent*/
proc print data=naccho13WITHALLFIPS;
var nacchoid c1q9:;
where COUNTY_FIPS="";
run;


/*Based on county fips, linking naccho data with AHRF data*/
data AHRF14 ;
set AHRF13_14;
cntyfips=put(f00002,5. -L);
cntyfips2=put(input(cntyfips,best5.),z5.);
run;

data AHRF14(keep=
f00002   f00008 f12424 f00011 f00012 f04439 f04448 f04440 f04449 f00023 
f0885712 f0885711 f0885710 f0885708 f0885707 f0885706 f0885705 f0885704 f0885703 f0885702 f0885701 f0885700 f0885790 f0885780 f0885770 f0885760 f0885750 f0885740  /*Total Active M.D.s Non-Federal   Non-Fed; Excl Inact                  */
f0892211 f0892210 f0892205  /*Short Term General Hosp Beds     Coded '10-1'                         */
f1440808 f1440806 /*% Persons Below Poverty Level    (.1) Table B17001                    */
f1198413 f1198412 f1198411 /*Population Estimate              Whole Numbers                        */
f0453010 /*Census Population                Whole Numbers                        */
f1198409 f1198408 f1198407 f1198406 f1198405 f1198404 f1198403 f1198402 f1198401 /*Population Estimate              Whole Numbers                        */
f0453000 /*Census Population                Whole Numbers                        */
f1198499 f1198498 f1198497 f1198496 f1198495 f1198494 f1198493 f1198492 f1198491 /*Population Estimate              Whole Numbers                        */
f1408312 f1408311 /*Population Estimate 65+          Whole Numbers, Estimates             */
f1484010 /*Population 65+                   Table P12, Whole Numbers             */
f1408309 f1408308 f1408307 f1408306 f1408305 /*Population Estimate 65+          Whole Numbers, Estimates             */
f1348310 f1348300  /*Median Age                       Table P13, (.1)                      */
f0453710 f0453700 /*Percent White Population         Table P1, (.1), One Race Alone       */
f0978112 f0978111 f0978110 f0978109 f0978108 f0978107 f0978106 f0978105 /*Per Capita Personal Income       In Dollars                           */
f1332112 f1332111 f1332110 f1332109 f1332108 f1332107 f1332106 f1332105 /*Percent Persons in Poverty       (.1) Estimates                       */
f1475112 f1475111 f1475110 f1475109 f1475108 f1415607 f1415606  /*% <65 without Health Insurance   (.1) Estimates                       */
f0679513 f0679512 f0679511 f0679510 f0679509 f0679508 f0679507 f0679506 f0679505  /*Unemployment Rate, 16+           (.1) Unemplyd/Civil Lab Frce         */
f0972110 f0972100  /*Land Area in Square Miles        (.01) Geographic Header              */
f1448208 f1448206 /*% Persons 25+ w/4+ Yrs College   (.1) Table B15002                    */ 
f1389113  /*Core Based Stat Area Code(CBSA)  Metropolitan/Micropolitan            */
f1389213  /*Core Based Stat Area Name(CBSA)  Metropolitan/Micropolitan            */
f1406713  /*CBSA Indicator Code              0 = Not, 1 = Metro, 2 = Micro        */
f1419513  /*CBSA County Status               Central or Outlying                  */
f1419313  /*Metropolitan Division Code                                            */
f1419413  /*Metropolitan Division Name                                            */
f1389313  /*Combined Statistical Area Code                                        */
f1389413  /*Combined Statistical Area Name                                        */
f0002013  /*Rural-Urban Continuum Code                                            */
f1255913  /*Urban Influence Code                                                  */
f1397304  /*Economic-Dependnt Typology Code                                       */
f1332013 f1332012 f1332011 f1332010 /*Number of FQHCs in jurisdictions           */
f1322312 f1322311 f1322310 f1322309 /*Person in poverty estimated*/
f0890911 f0890910 f0890905 /*Hospital admissions*/
f0886811 f0886810 f0886805 /*Total Number of Hospitals*/
pct65 
cntyfips cntyfips2);
set AHRF14;
pct65=f1408312/f1198412*100;
run;

data AHRF14(rename=(cntyfips2=COUNTY_FIPS));
set AHRF14;
run;

data naccho13WITHALLFIPS;
set naccho13WITHALLFIPS;
TBD_FRMNAC13=1;
run;

proc sort data=AHRF14;
by COUNTY_FIPS;
proc sort data=naccho13WITHALLFIPS;
by COUNTY_FIPS;
run;

data NAC13ARF14;
merge naccho13WITHALLFIPS AHRF14 ;
by COUNTY_FIPS;
run;

data NAC13ARF14;
set NAC13ARF14;
where TBD_FRMNAC13=1;
run;

/*Converting character to numeric variables*/ 
data NAC13ARF14;
set NAC13ARF14;
cbsa=input(f1406713, 2.);
rucc=input(f0002013, 2.);
urbinfc=input(f1255913,2.);
run;

proc sort data=NAC13ARF14;
by nacchoid;
run;

/*For each nacchoid we identify max, minimum of cbsa, rucc and urbinfc variables. This will be useful is
assiging rural/urban code for multicounties jurisdictions. Presence of at least one urban county makes the 
multicounty jurisdiction "Urban"*/

proc means data=NAC13ARF14 noprint max nway missing; 
   class nacchoid;
   var cbsa rucc;
   output out=cbsa_max (drop=_type_ _freq_) max=cbsa_max;
run; 
proc means data=NAC13ARF14 noprint min nway missing; 
   class nacchoid;
   var rucc;
   output out=rucc_min (drop=_type_ _freq_) min=rucc_min;
run; 
proc means data=NAC13ARF14 noprint min nway missing; 
   class nacchoid;
   var urbinfc;
   output out=urbinfc_min (drop=_type_ _freq_) min=urbinfc_min;
run;

proc sort data=cbsa_max;
by nacchoid;
proc sort data=rucc_min;
by nacchoid;
proc sort data=urbinfc_min;
by nacchoid;
run;

data lrt1;
merge cbsa_max rucc_min urbinfc_min;
by nacchoid;
run;

proc sort data=lrt1;
by nacchoid;
proc sort data=NAC13ARF14;
by nacchoid;
run;

data NAC13ARF14_A;
merge  NAC13ARF14 lrt1;
by nacchoid;
run;

/*Computing mean values for ARF variables for multicounties jurisdiction groupped by nachoid;
mean(varname) will not account for the missing data when calculating mean*/
proc sql;
  create table nacarfavg as
  select *, mean(f0885712) as mean_mds12, 
         mean(f0885711) as mean_mds11, 
		 mean(f0885710) as mean_mds10,
		 mean(f0885708) as mean_mds08,
		 mean(f0885707) as mean_mds07,
		 mean(f0885706) as mean_mds06,
		 mean(f0885705) as mean_mds05,
		 mean(f0885704) as mean_mds04,
		 mean(f0885703) as mean_mds03,
		 mean(f0885702) as mean_mds02,
		 mean(f0885701) as mean_mds01,
		 mean(f0885700) as mean_mds00,
		 mean(f0885790) as mean_mds90,
		 mean(f0885780) as mean_mds80,
		 mean(f0885770) as mean_mds70,
		 mean(f0885760) as mean_mds60,
		 mean(f0885750) as mean_mds50,
		 mean(f0885740) as mean_mds40,
		 mean(f0892211) as mean_bed11,
		 mean(f0892210) as mean_bed10,
		 mean(f0892205) as mean_bed05,
		 mean(f1198413) as mean_popest13,
		 mean(f1198412) as mean_popest12,
		 mean(f1198411) as mean_popest11,
		 mean(f0453010) as mean_popcens10,
		 mean(f1198409) as mean_popest09,
		 mean(f1198408) as mean_popest08,
		 mean(f1198407) as mean_popest07,
		 mean(f1198406) as mean_popest06,
		 mean(f1198405) as mean_popest05,
		 mean(f1198404) as mean_popest04,
		 mean(f1198403) as mean_popest03,
		 mean(f1198402) as mean_popest02,
		 mean(f1198401) as mean_popest01,
		 mean(f0453000) as mean_popcens00,
		 mean(f1198499) as mean_popest99,
		 mean(f1198498) as mean_popest98,
		 mean(f1198497) as mean_popest97,
		 mean(f1198496) as mean_popest96,
		 mean(f1198495) as mean_popest95,
		 mean(f1198494) as mean_popest94,
		 mean(f1198493) as mean_popest93,
		 mean(f1198492) as mean_popest92,
		 mean(f1198491) as mean_popest91,
		 mean(f1408312) as mean_65est12,
		 mean(f1408311) as mean_65est11,
		 mean(f1484010) as mean_65est10,
		 mean(f1408309) as mean_65est09,
		 mean(f1408308) as mean_65est08,
		 mean(f1408307) as mean_65est07,
		 mean(f1408306) as mean_65est06,
		 mean(f1408305) as mean_65est05,
		 mean(f0886811) as mean_hospnum11,
		 mean(pct65) as mean_pct65est12,
		 mean(f1348310) as mean_medage10,
		 mean(f1348300) as mean_medage00,
		 mean(f0453710) as mean_pctwh10,
		 mean(f0453700) as mean_pctwh00,
		 mean(f0978112) as mean_pcapinc12,
		 mean(f0978111) as mean_pcapinc11,
		 mean(f0978110) as mean_pcapinc10,
		 mean(f0978109) as mean_pcapinc09,
		 mean(f0978108) as mean_pcapinc08,
		 mean(f0978107) as mean_pcapinc07,
		 mean(f0978106) as mean_pcapinc06,
		 mean(f0978105) as mean_pcapinc05,
		 mean(f1332112) as mean_pctpov12,
		 mean(f1332111) as mean_pctpov11,
		 mean(f1332110) as mean_pctpov10,
		 mean(f1332109) as mean_pctpov09,
		 mean(f1332108) as mean_pctpov08,
		 mean(f1332107) as mean_pctpov07,
		 mean(f1332106) as mean_pctpov06,
		 mean(f1332105) as mean_pctpov05,
		 mean(f1475112) as mean_pctnoins12,
		 mean(f1475111) as mean_pctnoins11,
		 mean(f1475110) as mean_pctnoins10,
		 mean(f1475109) as mean_pctnoins09,
		 mean(f1475108) as mean_pctnoins08,
		 mean(f1415607) as mean_pctnoins07,
		 mean(f1415606) as mean_pctnoins06,
		 mean(f1448208) as mean_collpct0812,
		 mean(f1448206) as mean_collpct0610,
		 mean(f0679513) as mean_unemppct13,
		 mean(f0679512) as mean_unemppct12,
		 mean(f0679511) as mean_unemppct11,
		 mean(f0679510) as mean_unemppct10,
		 mean(f0679509) as mean_unemppct09,
		 mean(f0679508) as mean_unemppct08,
		 mean(f0679507) as mean_unemppct07,
		 mean(f0679506) as mean_unemppct06,
		 mean(f0679505) as mean_unemppct05,
		 mean(f1332013) as mean_fqhcs13,
		 mean(f1332012) as mean_fqhcs12,
		 mean(f1332011) as mean_fqhcs11,
		 mean(f1332010) as mean_fqhcs10,
		 mean(f1322312) as mean_perspov12,
		 mean(f1322311) as mean_perspov11,
		 mean(f1322310) as mean_perspov10,
		 mean(f1322309) as mean_perspov09,
		 mean(f0890911) as mean_hospadm11,
		 mean(f0890910) as mean_hospadm10,
		 mean(f0890905) as mean_hospadm05,
		 mean(f0972110) as mean_lndarea10,
		 mean(f0972100) as mean_lndarea00 from NAC13ARF14_A
    group by nacchoid
    order by nacchoid;
quit;

data NACARFAVG (drop=f0885712--f0972100);
set NACARFAVG;
run;

/*Removing duplicates based on nacchoid. This will keep those observation at LHD level with mean ARF values for multicounty jurisdictions*/
proc sort data=NACARFAVG out=NACARFAVGunique nodupkey; 
by nacchoid;             
run; 

/*This dataset "LHD level information from NACCHO 2013 linked with ARF data at county level" is used later*/
libname lrt "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data";
data lrt.NACARFAVGunique;
set NACARFAVGunique;
run;

PROC EXPORT DATA= LRT.NACARFAVGunique 
            OUTFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NACARFAVGunique.dta" 
            DBMS=STATA REPLACE;
RUN;

/*Now we need to bring in NLSPHS 2014 with SNA data (nlsphs2014_final) and match-merge 1:1 with NACARFAVGunique */
data NACARFAVGunique;
set lrt.NACARFAVGunique;
run;
 
data nlsphs2014_final;
set lrt.nlsphs2014_final;
run;

proc sort data=nlsphs2014_final;
by nacchoid;
proc sort data=NACARFAVGunique;
by nacchoid;
run;

data nls14nac13arf1314;
merge NACARFAVGunique nlsphs2014_final ;
by nacchoid;
run;

/*This linked dataset will have missing for county fips and zip codes for those who did not respond to NACCHO 2013 and were the sample in our original cohort of NLSPHS*/
proc print data=nls14nac13arf1314;
var nacchoid c1q9 county_fips;
where c1q9="" | county_fips="";
run;

/*
NOTE: There were 130 observations read from the data set WORK.NLS14NAC13ARF1314.
      WHERE (c1q9=' ') or (county_fips=' ');

*/

/*Looking for missing fips and missing data on ARF variables

NOTE: The data set WORK.NLS14NAC13ARF1314_MISS has 107 observations and 2063 variables.

*/
data nls14nac13arf1314_nomiss nls14nac13arf1314_miss;
set nls14nac13arf1314;
if County_FIPS="" then output nls14nac13arf1314_miss; else output nls14nac13arf1314_nomiss;
run;

/*INSERTED HERE for 2012 missing variable in final dataset*/
data nls14nac13arf1314_miss;
set nls14nac13arf1314_miss;
if pct65=. then pct65=mean_pct65est12;
*if hspnum=. then hspnum=mean_hospnum11;
run;

data nls14nac13arf1314_miss (drop=f00002 f00008 f12424 f00011 f00012 f04439 f04448 f04440 f04449 f00023 f1389113 f1389213 f1406713 f1419513 
f1419313 f1419413 f1389313 f1389413 f0002013 f1255913 f1397304 cntyfips cbsa rucc urbinfc cbsa_max rucc_min urbinfc_min mean_:);
set nls14nac13arf1314_miss;
run;

/*Bringing in nacchoboundary 2010 files to impute missing fips code*/

PROC IMPORT OUT= WORK.nacbound10 
            DATAFILE= "C:\Users\LRTI222\Dropbox\Data\NACCHO\Shapefiles\LHDBoundariesByFIPS_10\Final\FIPS_Codes for 2010 Prfile.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Lookup$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data nacbound10(rename=(naccho_id=nacchoid));
set nacbound10;
run;

proc sort data=nacbound10;
by nacchoid;
proc sort data=nls14nac13arf1314_miss;
by nacchoid;
run;

data nls14nac13arf1314_miss_1;
merge nacbound10 nls14nac13arf1314_miss ;
by nacchoid;
run;

data nls14nac13arf1314_miss_2;
set nls14nac13arf1314_miss_1;
COUNTY_FIPS=CNTYIDFP;
if COUNTY_FIPS="" then do;
COUNTY_FIPS=CNTYIDFP;
end;
if COUNTY_FIPS="" & COUNTYFP ne "" then do;
COUNTY_FIPS=CAT(STATEFP, COUNTYFP);
end;
TBD_FRMNAC13_miss_2=1;
/*
run;

data missnac;
set nls14nac13arf1314_miss_2;
where COUNTY_FIPS="";
run;
*/
if COUNTY_FIPS="" then do;
if nacchoid="AL053" then COUNTY_FIPS="01105";
if nacchoid="AR059" then COUNTY_FIPS="05119";
if nacchoid="CA004" then COUNTY_FIPS="06001";
if nacchoid="CO016" then COUNTY_FIPS="08031";
if nacchoid="CT009" then COUNTY_FIPS="09001";
if nacchoid="CT043" then COUNTY_FIPS="09003";
if nacchoid="CT057" then COUNTY_FIPS="09007";
if nacchoid="GA031" then COUNTY_FIPS="13241";
if nacchoid="GA038" then COUNTY_FIPS="13215";
if nacchoid="HI002" then COUNTY_FIPS="15001";
if nacchoid="HI005" then COUNTY_FIPS="15009";
if nacchoid="IL074" then COUNTY_FIPS="17167";
if nacchoid="IN027" then COUNTY_FIPS="18089";
if nacchoid="MS024" then COUNTY_FIPS="28047";
if nacchoid="MS026" then COUNTY_FIPS="28049";
if nacchoid="MS031" then COUNTY_FIPS="28059";
if nacchoid="MS042" then COUNTY_FIPS="28081";
if nacchoid="MS048" then COUNTY_FIPS="28093";
if nacchoid="MS062" then COUNTY_FIPS="28121";
if nacchoid="MS073" then COUNTY_FIPS="28145";
if nacchoid="OH136" then COUNTY_FIPS="39153";
if nacchoid="SC003" then COUNTY_FIPS="45045";
if nacchoid="SC008" then COUNTY_FIPS="45003";
if nacchoid="SC009" then COUNTY_FIPS="45063";
if nacchoid="SC010" then COUNTY_FIPS="45041";
if nacchoid="SC015" then COUNTY_FIPS="45047";
if nacchoid="SC019" then COUNTY_FIPS="45057";
if nacchoid="SC020" then COUNTY_FIPS="45085";
if nacchoid="TX005" then COUNTY_FIPS="48439";
if nacchoid="TX128" then COUNTY_FIPS="48085";
if nacchoid="TX136" then COUNTY_FIPS="48121";
if nacchoid="TX139" then COUNTY_FIPS="48139";
if nacchoid="TX148" then COUNTY_FIPS="48113";
if nacchoid="TX168" then COUNTY_FIPS="48245";
if nacchoid="VA042" then COUNTY_FIPS="51840";
if nacchoid="VA132" then COUNTY_FIPS="51700";
if nacchoid="WI017" then COUNTY_FIPS="55025";
if nacchoid="WI056" then COUNTY_FIPS="55079";
if nacchoid="WV999" then COUNTY_FIPS="54081";
end;
run;

data nls14nac13arf1314_miss_2_A nls14nac13arf1314_miss_2_B;
set nls14nac13arf1314_miss_2;
if COUNTY_FIPS ne "" then output nls14nac13arf1314_miss_2_A; else if COUNTY_FIPS="" then output nls14nac13arf1314_miss_2_B;
run;

PROC IMPORT OUT= WORK.fips 
            DATAFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\fips_codes_website.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="cqr_universe_fixedwidth_all$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data fips1 (keep=State_FIPS_Code County_FIPS_Code PLACE_FIPS);
set fips;
PLACE_FIPS=cat(State_FIPS_Code, FIPS_Entity_Code);
run;

data nls14nac13arf1314_miss_2_B;
set nls14nac13arf1314_miss_2_B;
from_B=1;
run;

proc sort data=nls14nac13arf1314_miss_2_B;
by PLACE_FIPS;
proc sort data=fips1;
by PLACE_FIPS;
run;

data nls14nac13arf1314_miss_2_Bimp;
merge nls14nac13arf1314_miss_2_B fips1;
by PLACE_FIPS;
run;

data nls14nac13arf1314_miss_2_Bimp;
set nls14nac13arf1314_miss_2_Bimp;
where from_B=1;
COUNTY_FIPS=CAT(State_FIPS_Code, County_FIPS_Code);
run;

data nls14nac13arf1314_miss_3;
set nls14nac13arf1314_miss_2_A nls14nac13arf1314_miss_2_Bimp;
run;

proc sort data=AHRF14;
by COUNTY_FIPS;
proc sort data=nls14nac13arf1314_miss_3;
by COUNTY_FIPS;
run;


data NAC13ARF14_miss_2;
merge nls14nac13arf1314_miss_3 AHRF14 ;
by COUNTY_FIPS;
run;

data NAC13ARF14_miss_2;
set NAC13ARF14_miss_2;
where TBD_FRMNAC13_miss_2=1;
run;

data NAC13ARF14_miss_2;
set NAC13ARF14_miss_2;
cbsa=input(f1406713, 2.);
rucc=input(f0002013, 2.);
urbinfc=input(f1255913,2.);
run;

proc sort data=NAC13ARF14_miss_2;
by nacchoid;
run;


proc means data=NAC13ARF14_miss_2 noprint max nway missing; 
   class nacchoid;
   var cbsa rucc;
   output out=cbsa_max_miss_2 (drop=_type_ _freq_) max=cbsa_max;
run; 
proc means data=NAC13ARF14_miss_2 noprint min nway missing; 
   class nacchoid;
   var rucc;
   output out=rucc_min_miss_2 (drop=_type_ _freq_) min=rucc_min;
run; 
proc means data=NAC13ARF14_miss_2 noprint min nway missing; 
   class nacchoid;
   var urbinfc;
   output out=urbinfc_min_miss_2 (drop=_type_ _freq_) min=urbinfc_min;
run;

proc sort data=cbsa_max_miss_2;
by nacchoid;
proc sort data=rucc_min_miss_2;
by nacchoid;
proc sort data=urbinfc_min_miss_2;
by nacchoid;
run;

data lrt1_miss_2;
merge cbsa_max_miss_2 rucc_min_miss_2 urbinfc_min_miss_2;
by nacchoid;
run;

proc sort data=lrt1_miss_2;
by nacchoid;
proc sort data=NAC13ARF14_miss_2;
by nacchoid;
run;

data NAC13ARF14_A_miss_2;
merge  NAC13ARF14_miss_2 lrt1_miss_2;
by nacchoid;
run;


/*below mean(varname) will not account for the missing data when calculating mean*/
proc sql;
  create table nacarfavg_miss_2 as
  select *, mean(f0885712) as mean_mds12, 
         mean(f0885711) as mean_mds11, 
		 mean(f0885710) as mean_mds10,
		 mean(f0885708) as mean_mds08,
		 mean(f0885707) as mean_mds07,
		 mean(f0885706) as mean_mds06,
		 mean(f0885705) as mean_mds05,
		 mean(f0885704) as mean_mds04,
		 mean(f0885703) as mean_mds03,
		 mean(f0885702) as mean_mds02,
		 mean(f0885701) as mean_mds01,
		 mean(f0885700) as mean_mds00,
		 mean(f0885790) as mean_mds90,
		 mean(f0885780) as mean_mds80,
		 mean(f0885770) as mean_mds70,
		 mean(f0885760) as mean_mds60,
		 mean(f0885750) as mean_mds50,
		 mean(f0885740) as mean_mds40,
		 mean(f0892211) as mean_bed11,
		 mean(f0892210) as mean_bed10,
		 mean(f0892205) as mean_bed05,
		 mean(f1198413) as mean_popest13,
		 mean(f1198412) as mean_popest12,
		 mean(f1198411) as mean_popest11,
		 mean(f0453010) as mean_popcens10,
		 mean(f1198409) as mean_popest09,
		 mean(f1198408) as mean_popest08,
		 mean(f1198407) as mean_popest07,
		 mean(f1198406) as mean_popest06,
		 mean(f1198405) as mean_popest05,
		 mean(f1198404) as mean_popest04,
		 mean(f1198403) as mean_popest03,
		 mean(f1198402) as mean_popest02,
		 mean(f1198401) as mean_popest01,
		 mean(f0453000) as mean_popcens00,
		 mean(f1198499) as mean_popest99,
		 mean(f1198498) as mean_popest98,
		 mean(f1198497) as mean_popest97,
		 mean(f1198496) as mean_popest96,
		 mean(f1198495) as mean_popest95,
		 mean(f1198494) as mean_popest94,
		 mean(f1198493) as mean_popest93,
		 mean(f1198492) as mean_popest92,
		 mean(f1198491) as mean_popest91,
		 mean(f1408312) as mean_65est12,
		 mean(f1408311) as mean_65est11,
		 mean(f1484010) as mean_65est10,
		 mean(f1408309) as mean_65est09,
		 mean(f1408308) as mean_65est08,
		 mean(f1408307) as mean_65est07,
		 mean(f1408306) as mean_65est06,
		 mean(f1408305) as mean_65est05,
		 mean(pct65) as mean_pct65est12,
		 mean(f0886811) as mean_hospnum11,
 		 mean(f1348310) as mean_medage10,
		 mean(f1348300) as mean_medage00,
		 mean(f0453710) as mean_pctwh10,
		 mean(f0453700) as mean_pctwh00,
		 mean(f0978112) as mean_pcapinc12,
		 mean(f0978111) as mean_pcapinc11,
		 mean(f0978110) as mean_pcapinc10,
		 mean(f0978109) as mean_pcapinc09,
		 mean(f0978108) as mean_pcapinc08,
		 mean(f0978107) as mean_pcapinc07,
		 mean(f0978106) as mean_pcapinc06,
		 mean(f0978105) as mean_pcapinc05,
		 mean(f1332112) as mean_pctpov12,
		 mean(f1332111) as mean_pctpov11,
		 mean(f1332110) as mean_pctpov10,
		 mean(f1332109) as mean_pctpov09,
		 mean(f1332108) as mean_pctpov08,
		 mean(f1332107) as mean_pctpov07,
		 mean(f1332106) as mean_pctpov06,
		 mean(f1332105) as mean_pctpov05,
		 mean(f1475112) as mean_pctnoins12,
		 mean(f1475111) as mean_pctnoins11,
		 mean(f1475110) as mean_pctnoins10,
		 mean(f1475109) as mean_pctnoins09,
		 mean(f1475108) as mean_pctnoins08,
		 mean(f1415607) as mean_pctnoins07,
		 mean(f1415606) as mean_pctnoins06,
		 mean(f1448208) as mean_collpct0812,
		 mean(f1448206) as mean_collpct0610,
		 mean(f0679513) as mean_unemppct13,
		 mean(f0679512) as mean_unemppct12,
		 mean(f0679511) as mean_unemppct11,
		 mean(f0679510) as mean_unemppct10,
		 mean(f0679509) as mean_unemppct09,
		 mean(f0679508) as mean_unemppct08,
		 mean(f0679507) as mean_unemppct07,
		 mean(f0679506) as mean_unemppct06,
		 mean(f0679505) as mean_unemppct05,
		 mean(f1332013) as mean_fqhcs13,
		 mean(f1332012) as mean_fqhcs12,
		 mean(f1332011) as mean_fqhcs11,
		 mean(f1332010) as mean_fqhcs10,
		 mean(f1322312) as mean_perspov12,
		 mean(f1322311) as mean_perspov11,
		 mean(f1322310) as mean_perspov10,
		 mean(f1322309) as mean_perspov09,
		 mean(f0890911) as mean_hospadm11,
		 mean(f0890910) as mean_hospadm10,
		 mean(f0890905) as mean_hospadm05,
		 mean(f0972110) as mean_lndarea10,
		 mean(f0972100) as mean_lndarea00 from NAC13ARF14_A_miss_2
    group by nacchoid
    order by nacchoid;
quit;


data NACARFAVG_miss_2 (drop=f0885712--f0972100);
set NACARFAVG_miss_2;
run;

proc sort data=NACARFAVG_miss_2 out=NACARFAVGunique_miss_2 nodupkey; 
by nacchoid;             
run; 


data nls14nac13arf1314_miss;
set nls14nac13arf1314_miss;
keep=1;
run;

proc sort data=nls14nac13arf1314_miss;
by nacchoid;
proc sort data=NACARFAVGunique_miss_2;
by nacchoid;
run;

data nls14nac13arf1314_miss_imp;
merge nls14nac13arf1314_miss NACARFAVGunique_miss_2;
by nacchoid;
run;

proc freq data=nls14nac13arf1314_miss_imp;
tables keep;
run;

data nls14nac13arf1314_miss_imp;
set nls14nac13arf1314_miss_imp;
where keep=1;
run;

data nls14nac13arf1314_final;
set nls14nac13arf1314_nomiss nls14nac13arf1314_miss_imp;
run;

/*
data nls14nac13arf1314_final_TBD;
set nls14nac13arf1314_final;
if COUNTY_FIPS="" then output;
run;
*/

proc freq data=nls14nac13arf1314_final;
tables survresp;
run;

data lrt.nls14nac13arf1314_final;
set nls14nac13arf1314_final;
YEAR=2013;
run;


/*Renaming all variables as is in nlsphs_tot*/
/*
data nls14nac13arf1314_final_trunc;
set nls14nac13arf1314_final;
YEAR=2013;
run;






/*

data nls14nac13arf1314;
set nls14nac13arf1314;
TBD_FROMNNA=1;
run;

data TBD_nacbound13 (rename=(State=TBD_State LHD_Name=TBD_LHD_Name Area=TBD_Area County_FIPS=TBD_COUNTY_FIPS Place_FIPS=TBD_Place_FIPS Cousub_FIPS=TBD_Cousub_FIPS GIS_Cat=TBD_GIS_Cat Jurisdiction=TBD_Jurisdiction Notes=TBD_Notes));
set nacbound13;
run;

proc sort data=TBD_nacbound13;
by nacchoid;
proc sort data=nls14nac13arf1314;
by nacchoid;
run;

data nls14nac13arf1314_rec;
merge nls14nac13arf1314 TBD_nacbound13;
by nacchoid;
run;

data nls14nac13arf1314_rec2;
set nls14nac13arf1314_rec;
if COUNTY_FIPS="" then do;
COUNTY_FIPS=TBD_COUNTY_FIPS;
end;
run;

proc freq data=nls14nac13arf1314_rec2;
tables TBD_FROMNNA;
run;

data nls14nac13arf1314_rec2;
set nls14nac13arf1314_rec2;
if TBD_FROMNNA=. then delete;
run;

proc sort data=nls14nac13arf1314_rec2 out=NACARFAVGunique2 nodupkey; 
by nacchoid;             
run; 

proc freq data=nls14nac13arf1314;
tables survresp*lhd1;
run;

data lrt.nls14nac13arf1314;
set nls14nac13arf1314;
run;


