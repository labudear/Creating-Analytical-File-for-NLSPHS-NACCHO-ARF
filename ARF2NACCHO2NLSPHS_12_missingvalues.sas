/*Run ARF2NACCHO2NLSPHS_14.sas before this*/


/*Read ARF 2011 data*/
*filename arf11 "C:\Users\LRTI222\Dropbox\Data\AHRF_2011-2012";
*%include arf11(AHRF2011);

/*Read NACCHO 2010 data*/
libname nac10 "C:\Users\LRTI222\Dropbox\Data\NACCHO";
data nac2010;
set nac10.NACCHO2010;
run;

proc freq data=nac2010;
tables c0jurisdiction;
run;

/*Splitting the dataset by type of jurisdictions*/
data nac10_cty nac10_ctycnty nac10_cnty nac10_mcty nac10_mcnty;
set nac2010;
if c0jurisdiction="city" then output nac10_cty; 
else if c0jurisdiction="city-county" then output nac10_ctycnty;
else if c0jurisdiction="county" then output nac10_cnty;
else if c0jurisdiction="multi-city" then output nac10_mcty;
else if c0jurisdiction="multi-county" then output nac10_mcnty;
run;



data nac10_cty;
set nac10_cty;
nac10city=1;
run;

data nac10_ctycnty;
set nac10_ctycnty;
nac10ctycnty=1;
run;

data nac10_cnty;
set nac10_cnty;
nac10cnty=1;
run;

data nac10_mcty;
set nac10_mcty;
nac10mcty=1;
run;

data nac10_mcnty;
set nac10_mcnty;
nac10mcnty=1;
run;

/*
proc sort data=nac10_cty;
by nacchoid;
run;

proc sort data=nac10_ctycnty;
by nacchoid;
run;

proc sort data=nac10_cnty;
by nacchoid;
run;

proc sort data=nac10_mcty;
by nacchoid;
run;

proc sort data=nac10_mcnty;
by nacchoid;
run;
*/

proc sort data=nac2010;
by nacchoid;
run;

/*Importing naccho 2010 boundary files*/
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

data nacbound10_cnty;
set nacbound10;
if countyfp="" then delete;
run;

data nacbound10_plc;
set nacbound10;
if countyfp ne "" then delete;
run;

data nacbound10_plc;
set nacbound10_plc;
place=1;
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

data fips1;
set fips;
place_fips=cat(State_FIPS_Code, FIPS_Entity_Code);
run;

proc sort data=nacbound10_plc;
by place_fips;
proc sort data=fips1;
by place_fips;
run;

data nacbound10_plc2;
merge nacbound10_plc fips1;
by place_fips;
run;

data nacbound10_plc2 (keep=naccho_id  State_FIPS_Code County_FIPS_Code GU_Name);
set nacbound10_plc2;
where place=1;
run;

proc sort data=nacbound10_plc2;
by naccho_id;
proc sort data=nacbound10_plc;
by naccho_id;
run;

data nacbound10_plc1;
merge nacbound10_plc nacbound10_plc2;
by naccho_id;
run;

data nacchobound10imp;
set nacbound10_cnty nacbound10_plc1;
run;

data nacchobound10imp;
set nacchobound10imp;
if countyfp="" then do;
countyfp=County_FIPS_Code;
end;
if cntyidfp="" then do;
cntyidfp=cat(STATEFP, COUNTYFP);
end;
run;

data naccho10withallfips (keep=naccho_id COUNTY_FIPS);
set nacchobound10imp;
COUNTY_FIPS=cntyidfp;
run;

/*Read ARF 2014 data*/
filename arf14 "C:\Users\LRTI222\Dropbox\Data\AHRF_2013-2014\DOC";
%include arf14(AHRF2014);

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
pct65=f1484010/f0453010*100;
run;

data AHRF14(rename=(cntyfips2=COUNTY_FIPS));
set AHRF14;
run;

data naccho10WITHALLFIPS;
set naccho10WITHALLFIPS;
TBD_FRMNAC10=1;
run;

proc sort data=AHRF14;
by COUNTY_FIPS;
proc sort data=naccho10WITHALLFIPS;
by COUNTY_FIPS;
run;

data NAC10ARF14;
merge naccho10WITHALLFIPS AHRF14 ;
by COUNTY_FIPS;
run;

data NAC10ARF14;
set NAC10ARF14;
where TBD_FRMNAC10=1;
run;

/*For each nacchoid we identify max, minimum of cbsa, rucc and urbinfc variables. This will be useful is assigning rural/urban code for multicounties jurisdictions. Presence of at least one urban county makes the multicounty jurisdiction "Urban"*/
data NAC10ARF14 (rename=(naccho_id=nacchoid));
set NAC10ARF14;
cbsa=input(f1406713, 2.);
rucc=input(f0002013, 2.);
urbinfc=input(f1255913,2.);
run;

proc sort data=NAC10ARF14;
by nacchoid;
run;

proc means data=NAC10ARF14 noprint max nway missing; 
   class nacchoid;
   var cbsa rucc;
   output out=cbsa_max (drop=_type_ _freq_) max=cbsa_max;
run; 
proc means data=NAC10ARF14 noprint min nway missing; 
   class nacchoid;
   var rucc;
   output out=rucc_min (drop=_type_ _freq_) min=rucc_min;
run; 
proc means data=NAC10ARF14 noprint min nway missing; 
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
proc sort data=NAC10ARF14;
by nacchoid;
run;

data NAC10ARF14_A;
merge  NAC10ARF14 lrt1;
by nacchoid;
run;

/*Computing mean values for ARF variables for multicounties jurisdiction grouped by nachoid; 

below mean(varname) will not account for the missing data when calculating mean*/
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
		 mean(pct65) as mean_pct65est00,
		 mean(f0886810) as mean_hospnum10,
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
		 mean(f0972100) as mean_lndarea00 from NAC10ARF14_A
    group by nacchoid
    order by nacchoid;
quit;


data NACARFAVG (drop=f0885712--f0972100);
set NACARFAVG;
run;

proc sort data=NACARFAVG out=NACARFAVGunique nodupkey; 
by nacchoid;             
run; 

proc sort data=NAC2010;
by nacchoid;
proc sort data=NACARFAVGunique;
by nacchoid;
run;

data NAC10ARF14AVGunique (keep=nacchoid county_fips pct65 c3q15 c3q15a c5q36 c5q37 f0002013--mean_lndarea00);
merge NAC2010 NACARFAVGunique;
by nacchoid;
run;

libname lrt "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis";
data lrt.NAC10ARF14AVGunique;
set NAC10ARF14AVGunique;
run;

PROC EXPORT DATA= LRT.NAC10ARF14AVGunique 
            OUTFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\NAC10ARF14AVGunique.dta" 
            DBMS=STATA REPLACE;
RUN;

/*Use this file to impute missing values for 2010 data in the final dataset: C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb.dta"*/
/*Next use C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\Combining all 4 waves.sas*/

