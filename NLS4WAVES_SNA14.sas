/*****************************************************************************************************************************
Create network analytic measures from NLSPHS data

NOTE that the code below uses the external program: U:\Projects\PHPBRN\Research Projects\NLSPHS\Network analysis\bcent.sas

*****************************************************************************************************************************/

*note: in the array below i use only the org categories that were used in both 1998 and 2006, so i drop SHA, SAO, FBO, NONo, EMP.  Check  this;

/*Import data "nls4wvs_forSNA_YY.csv" created in "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Creating analytical file for SNA.do"*/

/*Read .xpt file instead of .csv file into SPSS and save it as .sas7bdat file and then import it here*/
/*
PROC IMPORT OUT= WORK.temp2
            DATAFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_14.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


PROC IMPORT OUT= WORK.TEMP2 
            DATAFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\nls4wvs_forSNA_14.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="nls4wvs_forSNA_14$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

*/

libname sna "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data";

data temp2 (rename=(YEARSURV=yearsurvey));
set sna.Nls4wvs_forsna_14;
run;

data temp3;
set temp2;


array serv (14,19) /*creating an array called serv 14 rows and 19 columns*/
lhdn1-lhdn19
sta1-sta19
loc1-loc19
fed1-fed19
phy1-phy19
hsp1-hsp19
chc1-chc19
non1-non19 
ins1-ins19 
sch1-sch19
uni1-uni19
oth1-oth19
fbo1-fbo19
emp1-emp19;



if yearsurvey in (1998, 2006) then numorgs=12; /*two org types not included in these surveyyears*/
else if yearsurvey in (2012, 2014) then numorgs=14;

*construct density measure;
servdens=0;
do i=1 to numorgs;
	do j=1 to 19;
		if serv(i,j)^=. then servdens=servdens+serv(i,j);		
	end;
end;
servdens=servdens/(numorgs*19);

 
*construct degree centrality measures for each service;
array scent (19) scent1-scent19;
do j=1 to 19;
	scent(j)=0;
	do i=1 to numorgs;
		if serv(i,j)^=. then scent(j)=scent(j)+serv(i,j);
	end;
	scent(j)=scent(j)/numorgs;
end;

*construct degree centrality measure for overall network;
maxscent=max(of scent1-scent19);
servcent=0;
do j=1 to 19;
	if scent(j)^=. then servcent=servcent+(maxscent-scent(j));
end;
servcent=servcent/(19-2);



*Next construct network measures at the organizational level.  This will be an 12x12 matrix with cells defined by the pct of services that 
each pair of organizations collaborate in performing;


array org (14,14) 
org1_1-org1_14
org2_1-org2_14
org3_1-org3_14
org4_1-org4_14
org5_1-org5_14
org6_1-org6_14
org7_1-org7_14
org8_1-org8_14
org9_1-org9_14
org10_1-org10_14
org11_1-org11_14
org12_1-org12_14
org13_1-org13_14
org14_1-org14_14
;

do i=1 to numorgs;
	do j=1 to numorgs;
		org(i,j)=0;
		do k=1 to 19;
			if serv(i,k)=1 and serv(j,k)=1 then org(i,j)=org(i,j)+1;  
		end;
		org(i,j)=org(i,j)/19;
	end;
end;


*construct density measure for org network;
orgdens=0;
do i=1 to numorgs;
	do j=1 to numorgs;
		if org(i,j)^=. then orgdens=orgdens+org(i,j);		
	end;
end;
orgdens=orgdens/(numorgs*numorgs);

*construct degree centrality measures for each org;
array ocent (14) ocent1-ocent14;
do j=1 to numorgs;
	ocent(j)=0;
	do i=1 to numorgs;
		if org(i,j)^=. then ocent(j)=ocent(j)+org(i,j);
	end;
	ocent(j)=ocent(j)/numorgs;
end;

*construct degree centrality measure for overall network;
maxocent=max(of ocent1-ocent14);
orgcent=0;
do j=1 to numorgs;
	if ocent(j)^=. then orgcent=orgcent+(maxocent-ocent(j));
end;
orgcent=orgcent/(numorgs-2);

run;

proc sort data=temp3;
by unid arm yearsurvey survresp;
run;


/******************************************************************
	IML programming routines for calculating betweeness centrality
******************************************************************/


proc iml;
%include '\\prdcphfs1\netusers\lrti222\NLSPHS2014\Network Analysis\bcent.sas';  /* run bcent.sas  */

use temp3;

z = {. . . . . . . . . . . . . . . . . .}; /** z is 1x18 numerical vector with all missing values**/
create work.outData from z[colname={"unid" "arm" "yearsurvey" "survresp" "betw1" "betw2" "betw3" "betw4" "betw5" "betw6" "betw7" "betw8" "betw9" "betw10" "betw11" "betw12" "betw13" "betw14" }];

setin temp3; /** make this dataset current for reading **/
setout work.outData; /** make this dataset current for writing **/


do data;
	read next var {org1_1 org1_2 org1_3 org1_4 org1_5 org1_6 org1_7 org1_8 org1_9 org1_10 org1_11 org1_12,
  				   org2_1 org2_2 org2_3 org2_4 org2_5 org2_6 org2_7 org2_8 org2_9 org2_10 org2_11 org2_12,
				   org3_1 org3_2 org3_3 org3_4 org3_5 org3_6 org3_7 org3_8 org3_9 org3_10 org3_11 org3_12,
				   org4_1 org4_2 org4_3 org4_4 org4_5 org4_6 org4_7 org4_8 org4_9 org4_10 org4_11 org4_12,
				   org5_1 org5_2 org5_3 org5_4 org5_5 org5_6 org5_7 org5_8 org5_9 org5_10 org5_11 org5_12,
				   org6_1 org6_2 org6_3 org6_4 org6_5 org6_6 org6_7 org6_8 org6_9 org6_10 org6_11 org6_12,
				   org7_1 org7_2 org7_3 org7_4 org7_5 org7_6 org7_7 org7_8 org7_9 org7_10 org7_11 org7_12,
				   org8_1 org8_2 org8_3 org8_4 org8_5 org8_6 org8_7 org8_8 org8_9 org8_10 org8_11 org8_12,
				   org9_1 org9_2 org9_3 org9_4 org9_5 org9_6 org9_7 org9_8 org9_9 org9_10 org9_11 org9_12,
				   org10_1 org10_2 org10_3 org10_4 org10_5 org10_6 org10_7 org10_8 org10_9 org10_10 org10_11 org10_12,
				   org11_1 org11_2 org11_3 org11_4 org11_5 org11_6 org11_7 org11_8 org11_9 org11_10 org11_11 org11_12,
				   org12_1 org12_2 org12_3 org12_4 org12_5 org12_6 org12_7 org12_8 org12_9 org12_10 org12_11 org12_12, 
				   org13_1 org13_2 org13_3 org13_4 org13_5 org13_6 org13_7 org13_8 org13_9 org13_10 org13_11 org13_12,
				   org14_1 org14_2 org14_3 org14_4 org14_5 org14_6 org14_7 org14_8 org14_9 org14_10 org14_11 org14_12}
	into M;
	
	read current var {unid arm yearsurvey survresp} into D;  /* get identification variables */

	t=loc(M);

	N=shape(M,14);

	*if ncol(t)>2 then print N;

	if ncol(t)>2 then y=bcent(N,0,1);  /* call bcent macro routine */
	else y=z[ ,5:18]`;  /* pick up the missing values */

	*b=missing(y);
	*c=b[,+];
	*d=c[+,];

	*if d<1 then append from y;

	p=y`;  /*transpose matrix*/
	
	q= D || p; /* add columns for ID variables */

	append from q; 	/* write to output dataset */

end;

close temp3 work.outData;

quit;

proc sort data=temp3;
by unid yearsurvey;
run;

proc sort data=outData;
by unid yearsurvey;
run;

data nlsphs2014_final;
merge temp3 outData;
by 	unid yearsurvey;
run;

data sna.nlsphs2014_final;
set nlsphs2014_final;
run;

data outData1(keep=unid arm yearsurvey survresp numorgs servdens scent1--org14_14 orgdens--betw14);
set nlsphs2014_final;
run;

PROC EXPORT DATA= WORK.outData1 
            OUTFILE= "C:\Users\LRTI222\Dropbox\Data\NLSPHS\Analysis\data\outData14.dta" 
            DBMS=STATA REPLACE;
RUN;
