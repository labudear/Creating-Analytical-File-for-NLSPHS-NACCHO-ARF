/*before running this run nl980612withNACCHO10full.sas*/

libname nls9806 "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data";

data Nls14nac13arf1314_final;
set nls9806.Nls14nac13arf1314_final;
run;

data Nlsphs_tot_nac10;
set nls9806.Nlsphs_tot_nac10;
format c4q24_rec mmddyy10.;
c3q301_rec=put(c3q301, 1.);
c4q24_rec=input(trim(c4q24),MMDDYY10.);
*yearnaccho=2010;
run;

data Nlsphs_tot_nac10 (drop=c4q24 c3q301);
set Nlsphs_tot_nac10;
run;

data Nlsphs_tot_nac10(rename=(c4q24_rec=c4q24 c3q301_rec=c3q301));
set Nlsphs_tot_nac10;
run;

data Nls14nac13arf1314_final (rename=(pct65=pct65_rec));
set Nls14nac13arf1314_final;
run;

data full;
set Nls14nac13arf1314_final Nlsphs_tot_nac10 ;
run;

proc freq data=full;
tables arm yearsurvey;
run;

data full1;
set full;
if yearsurvey=. then yearsurvey=2014;
if yearsurvey=2012 then yearnaccho=2010; 
if yearsurvey=2014 then yearnaccho=2013;
if pct65=. then pct65=pct65_rec;
if arm=. then do;
if survresp ne . then arm=1;
end;
run;

proc freq data=full1;
tables yearsurvey yearnaccho survresp arm yearsurvey*arm yearsurvey*survresp;
run;

proc freq data=full1;
tables yearsurvey*survresp yearsurvey*av1 yearsurvey*eff1 yearsurvey*lhd1 hspnum;
run;

data nls9806.All4WavesNACARFNLS;
set full1;
run;

PROC EXPORT DATA= nls9806.ALL4WAVESNACARFNLS 
            OUTFILE= "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\all4wavesnacarfnls.dta" 
            DBMS=STATA REPLACE;
RUN;

/*Rename variables as is in nlsphs_tot*/
*libname ref "U:\NLSPHS2014\Analysis\AnalyticalFiles\NLSPHSOLD";

*ods csv file="C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nlsphs_tot_varnum.csv";
*proc contents data=ref.nlsphs_tot varnum;
*run;
*ods csv close;

*ods csv file="C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nlsphs_full_varnum.csv";
*proc contents data=full1 varnum;
*run;
*ods csv close;


/*Then use Creating Final Analytical file2_rev.do file*/
