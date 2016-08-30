/*before running this run ARF2NACCHO2NLSPHS_14.sas*/

libname ref "C:\Users\LRTI222\Dropbox\Data\NACCHO";

data nlsphs_tot;
set ref.nlsphs_tot;
run;

proc freq data=nlsphs_tot;
tables yearsurvey;
run;

proc freq data=nlsphs_tot ;
tables yearsurvey*survresp/nocol norow nopercent ;
run;

proc sort data=nlsphs_tot;
by id1998;
run;

/*Split nlsphs_tot into nlsphs9806 and nlsphs12*/
data nlsphs_tot9806 nlsphs_tot12;
set nlsphs_tot;
if yearsurvey=2012 then output nlsphs_tot12; else output nlsphs_tot9806;
run;

data nlsphs_tot98 (keep=id1998);
set nlsphs_tot;
where survresp eq 1 & yearsurvey=1998 ;
run;

data insamp12 (keep=id1998);
set  nlsphs_tot98;
insamp=1;
yrsurvey12=1;
run;

data nlsphs_tot12_trunc(keep=id1998 innls);
set nlsphs_tot12;
innls=1;
run;

proc sort data=insamp12;
by id1998;
proc sort data=nlsphs_tot12_trunc;
by id1998;
run;

data test1;
merge insamp12 nlsphs_tot12_trunc;
by id1998;
run;

data test1;
set test1;
*if innls=. & insamp=1 then survresp=0;
if id1998=. then delete;
cohort12=1;
run;

PROC IMPORT OUT= WORK.NID 
            DATAFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nacchoidnlsid98-12.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

proc sort data=NID;
by id1998;
run;

data nid (keep=id1998 nacchoid);
set nid;
if id1998=. then delete;
run;

proc sort data=nid;
by id1998;
proc sort data=test1;
by id1998;
run;

data nid12;
merge test1 nid;
by id1998;
*if innls=. then delete;
run;

proc freq data=nid12;
tables innls;
run;

libname nac10 "C:\Users\LRTI222\Dropbox\Data\NACCHO";
data nac2010;
set nac10.NACCHO2010;
run;

proc sort data=nid12;
by nacchoid;
proc sort data=nac2010;
by nacchoid;
run;

data nidnac;
merge nid12 nac2010;
by nacchoid;
run;

data notinnls;
set nidnac;
if innls = 1 then delete;
run;

proc freq data=notinnls;
tables cohort12;
run;

data nls980612_tot;
set notinnls nlsphs_tot ;
*if cohort12=1 then survresp=0;
run;

data nls980612_tot;
set nls980612_tot;
if yearsurvey=. then yearsurvey=2012;
if cohort12 ne . then do;
if cohort12=1 & yearsurvey=2012 then survresp=0;
end;
run;

proc freq data=nls980612_tot ;
tables survresp yearsurvey yearsurvey*survresp cohort12;
run;

libname final "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data";
data final.nlsphs_tot_NAC10;
set nls980612_tot;
run;
