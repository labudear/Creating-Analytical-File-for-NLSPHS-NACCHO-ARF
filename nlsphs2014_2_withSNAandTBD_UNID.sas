
/***********************************************************************************************

Program name: 	nlsphs2014_2.sas
Author:  		Glen Mays
Creation date:  27Mar2015
Revised date: 	17Apr2015

Purpose:  		Initial processing and variable creation using preliminary data from 
				Wave 4 (2014) of the National Longitudinal Survey of Public Health Systems (NLSPHS) 
				for the purpose of generating preliminary estimates for the original NLSPHS cohort. 
 

Files used: 	nlsphs2014poplation.sas7bdat
				(preliminary raw data file created by Lava on 27Mar2015 that includes survey data
				linked with jurisdiction population data from the 2013 NACCHO Profile. 

Files created:	nlsphs14.sas7bdat

Notes:			This is NOT the final dataset from Wave 4 NLSPHS. Does not contain full data on the
				expanded cohort of communities with <100000 residents. Data collection was ongoing
				at time of datefile creation.  


***********************************************************************************************/


libname lava "C:\Users\Lava\Dropbox\Data\NLSPHS\Analysis\data\CPHS Trend\QC";


proc freq data=lava.nlsphs2014_raw;
tables av19 av20;
run;

/*Reverse the code for av20 to make it similar to previous waves*/
data nlsphs14 (drop=av20_rec);
set lava.nlsphs2014_raw;
av20_rec=av20;
av20=1-av20_rec;
run;

proc freq data=nlsphs14;
tables av20 eff19 arm survresp yearsurvey;
run;


data nlsphs14 (keep=TBD_UNID arm av1-av20 eff1-eff20 lhd1-lhd20 
sha1-sha20 sao1-sao20 loc1-loc20 fed1-fed20 phy1-phy20 
hsp1-hsp20 chc1-chc20 fbo1-fbo20 nono1-nono20 ins1-ins20 
emp1-emp20 sch1-sch20 uni1-uni20 oth1-oth20 none1-none20 large);
set nlsphs14;
where yearsurvey=2014;
run;

data nlsphs14;
set nlsphs14;
where survresp=1;
run;

data temp;
set  nlsphs14;

array avail(*) av1-av20;
array eff(*) eff1-eff20;
array lhd(*) lhd1-lhd19 lhd20;
array org(15,20) sha1-sha20 sao1-sao20 loc1-loc20 fed1-fed20 phy1-phy20 hsp1-hsp20 chc1-chc20 fbo1-fbo20 nono1-nono20 ins1-ins20 emp1-emp20 sch1-sch20 uni1-uni20 oth1-oth20 none1-none20;
array pcont(*) pct1-pct20;
 
i=0;
do i=1 to 20;
		if avail(i)=0 then do;
			eff(i)=0;
			lhd(i)=0;
			pcont(i)=0;
			j=0;
			do j=1 to 15;
				org(j,i)=0;
			end;
		end;


		pcont(i)=0;
		k=0;
		if avail(i)^=. then do; 
			do k=1 to 15;
				if org(k,i)=. then org(k,i)=0;
				else if org(k,i)>0 then org(k,i)=1;
				if k<15 then pcont(i)=pcont(i)+org(k,i);
			end;
			pcont(i)=pcont(i)/14;
		end;
		if avail(i)=. then do;
			do k=1 to 15;
				org(k,i)=.;
			end;
			pcont(i)=.;
		end;

end;

avass=sum(of av1-av6)/n(of av1-av6);
avpol=sum(of av7-av13)/n(of av7-av13);
avasr=sum(of av14-av20)/n(of av14-av20);
avtot=(avass+avpol+avasr)/3;

effass=sum(of eff1-eff6)/n(of eff1-eff6);
effpol=sum(of eff7-eff13)/n(of eff7-eff13);
effasr=sum(of eff14-eff19)/n(of eff14-eff19);
efftot=(effass+effpol+effasr)/3;

lhdass=sum(of lhd1-lhd6)/n(of lhd1-lhd6);
lhdpol=sum(of lhd7-lhd13)/n(of lhd7-lhd13);
lhdasr=sum(of lhd14-lhd19)/n(of lhd14-lhd19);
lhdtot=(lhdass+lhdpol+lhdasr)/3;

pctass=sum(of pct1-pct6)/n(of pct1-pct6);
pctpol=sum(of pct7-pct13)/n(of pct7-pct13);
pctasr=sum(of pct14-pct19)/n(of pct14-pct19);
pcttot=(pctass+pctpol+pctasr)/3;

array orgass (*) orgass1-orgass15;
array orgpol (*) orgpol1-orgpol15;
array orgasr (*) orgasr1-orgasr15;
array orgtot (*) orgtot1-orgtot15;

j=0;
do j=1 to 15;
	orgass(j)=0;
	orgpol(j)=0;
	orgasr(j)=0;
	i=0;
	do i=1 to 19;
		if i<7 then orgass(j)=orgass(j)+org(j,i);
		else if i<14 then orgpol(j)=orgpol(j)+org(j,i);
		else if i>13 then orgasr(j)=orgasr(j)+org(j,i);
	end;
	orgass(j)=orgass(j)/n(of av1-av6);
	orgpol(j)=orgpol(j)/n(of av7-av13);
	orgasr(j)=orgasr(j)/n(of av14-av19);
	orgtot(j)=(orgass(j)+orgpol(j)+orgasr(j))/3;
end;


array newvar (*) 
shaass shapol shaasr shatot
saoass saopol saoasr saotot
locass locpol locasr loctot
fedass fedpol fedasr fedtot
phyass phypol phyasr phytot
hspass hsppol hspasr hsptot
chcass chcpol chcasr chctot
fboass fbopol fboasr fbotot
nonoass nonopol nonoasr nonotot
insass inspol insasr instot
empass emppol empasr emptot
schass schpol schasr schtot
uniass unipol uniasr unitot
othass othpol othasr othtot
noneass nonepol noneasr nonetot
;

array oldvar (*) 
orgass1 orgpol1 orgasr1 orgtot1
orgass2 orgpol2 orgasr2 orgtot2
orgass3 orgpol3 orgasr3 orgtot3
orgass4 orgpol4 orgasr4 orgtot4
orgass5 orgpol5 orgasr5 orgtot5
orgass6 orgpol6 orgasr6 orgtot6
orgass7 orgpol7 orgasr7 orgtot7
orgass8 orgpol8 orgasr8 orgtot8
orgass9 orgpol9 orgasr9 orgtot9
orgass10 orgpol10 orgasr10 orgtot10
orgass11 orgpol1 orgasr11 orgtot11
orgass12 orgpol2 orgasr12 orgtot12
orgass13 orgpol3 orgasr13 orgtot13
orgass14 orgpol4 orgasr14 orgtot14
orgass15 orgpol5 orgasr15 orgtot15;

i=0;
do i=1 to 60;
	newvar(i)=oldvar(i);
end;

array stnew (*) sta1-sta19;
array sha (*) sha1-sha19;
array sao (*) sao1-sao19;
i=0;
do i=1 to hbound(stnew);
	stnew(i)=max(sha(i), sao(i));
end;

staass=sum(of sta1-sta6)/n(of av1-av6);
stapol=sum(of sta7-sta13)/n(of av7-av13);
staasr=sum(of sta14-sta19)/n(of av14-av19);
statot=(staass+stapol+staasr)/3;

array nonnew (*) non1-non19;
array fbo (*) fbo1-fbo19;
array nono (*) nono1-nono19;
i=0;
do i=1 to hbound(nonnew);
	nonnew(i)=max(fbo(i), nono(i));
end;

nonass=sum(of non1-non6)/n(of av1-av6);
nonpol=sum(of non7-non13)/n(of av7-av13);
nonasr=sum(of non14-non19)/n(of av14-av19);
nontot=(nonass+nonpol+nonasr)/3;

*next set of code recalculates the pct* vars using only the org categories on the 1998 survey;
array newpct (*) pct1-pct19;
array orgpct (10,19)
sta1-sta19
loc1-loc19
fed1-fed19
phy1-phy19
hsp1-hsp19
chc1-chc19
non1-non19
ins1-ins19
uni1-uni19
oth1-oth19
;

i=0; j=0;
pctass=0;
pctpol=0;
pctasr=0;
pcttot=0;
do i=1 to 19;
	newpct(i)=0;
	do j=1 to 10;
		newpct(i)=newpct(i)+orgpct(j,i);
	end;
	newpct(i)=newpct(i)/10;
	if i<7 then pctass=pctass+newpct(i);
	else if i<14 then pctpol=pctpol+newpct(i);
	else if i<20 then pctasr=pctasr+newpct(i);
end;
pctass=pctass/n(of av1-av6);
pctpol=pctpol/n(of av7-av13);
pctasr=pctasr/n(of av14-av19);
pcttot=(pctass+pctpol+pctasr)/3;

yearsurvey=2014;
survresp=1;
survsamp=1;

run;

*create ANY variables;
data temp;
set temp;

array any (*) shaany saoany staany locany fedany phyany hosany chcany fboany nonoany insany empany schany uniany othany noneany;
array tot (*) shatot saotot statot loctot fedtot phytot hsptot chctot fbotot nonotot instot emptot schtot unitot othtot nonetot;

do i=1 to hbound(tot);
	if tot(i)>0 then any(i)=1;
	else if tot(i)=0 then any(i)=0;
end;

run;


/*
proc means n mean min max data=temp;
var avass--avtot;
run;

proc means n mean min max data=temp;
where pop13>=100000;
var avass--avtot;
run;

proc univariate data=temp;
var avass--avtot;
run;
*/


/***************************************
Create Typology variables
***************************************/

data temp2;
set  temp;

if statot>. then do;
	hiparsta=statot>.50;
	hiparloc=loctot>.46;
	hiparnon=nontot>.46;
	hiparhsp=hsptot>.50;
	hiparphy=phytot>.31;
	hiparchc=chctot>.15;
	hiparuni=unitot>.26;
	hiparfed=fedtot>.11;
	hiparins=instot>.11;
	hiparoth=othtot>.11;

	hiparsum=hiparsta+hiparloc+hiparnon+hiparhsp+hiparphy+hiparchc+hiparuni+hiparfed+hiparins+hiparoth;
	hipargov=hiparsta+hiparloc+hiparfed;
	hiparcli=hiparhsp+hiparphy+hiparchc;
	hiparots=hiparnon+hiparuni+hiparins+hiparoth;

	if hipargov>1 and hiparcli>1 and hiparots>2 then clustpart=1; 
    else if hipargov>1 and hiparcli>1 and hiparots<3 then clustpart=2; 
	else if hipargov>1 and hiparcli<2 and hiparots>2 then clustpart=3; 
	else if hipargov>1 and hiparcli<2 and hiparots<3 then clustpart=3; 
	else if hipargov<2 and hiparcli>1 and hiparots<3 then clustpart=4; 
	else if hipargov<2 and hiparcli>1 and hiparots>2 then clustpart=4; 
	else if hipargov<2 and hiparcli<2 and hiparots>2 then clustpart=5;
	else if hipargov<2 and hiparcli<2 and hiparots>1 then clustpart=5;
	else if hipargov=0 and hiparcli=0 and hiparots=0 then clustpart=7; 
	else if hipargov<2 and hiparcli<2 and hiparots<2 then clustpart=6; 

end;

lhdeff1=lhdass;
lhdeff2=lhdpol;
lhdeff3=lhdasr;

 
if lhdeff1>0.50 and lhdeff2>0.50 and lhdeff3>0.50 and lhdeff3<=1 then clustlhd=1; 
else if lhdeff1>0.50 and lhdeff2<=0.50 and lhdeff3>0.50  then clustlhd=2; 
else if lhdeff1<=0.50 and lhdeff2>0.50 and lhdeff3>0.50 then clustlhd=3; 
else if lhdeff1<=0.50 and lhdeff2<=0.50 and lhdeff3>0.50 then clustlhd=4; 
else if lhdeff1>0.50 and lhdeff2>0.50 and lhdeff3<=0.50 then clustlhd=5; 
else if lhdeff1>0.50 and lhdeff2<=0.50 and lhdeff3<=0.50 then clustlhd=5; 
else if lhdeff1<=0.50 and lhdeff2>0.50 and lhdeff3<=0.50 then clustlhd=5; 
else if lhdeff1<=0.50 and lhdeff2<=0.50 and lhdeff3<=0.50 and lhdeff3^=. then clustlhd=6; 


if avtot>. then do;
	if avass>0.75 and avpol>0.75 and avasr>0.75 and avtot<=1 then clustav=1; 
	else  if avass>0.75 and avpol<=0.75 and avasr>0.75 then clustav=2;
	else if avass<=0.75 and avpol>0.75 and avasr>0.75 then clustav=3; 
	else if avass<=0.75 and avpol<=0.75 and avasr>0.75 then clustav=5;
	else if avass>0.75 and avpol>0.75 and avasr<=0.75 then clustav=4; 
	else if avass>0.75 and avpol<=0.75 and avasr<=0.75 then clustav=5;  
	else if avass<=0.75 and avpol>0.75 and avasr<=0.75 then clustav=5;  
	else if avass<=0.5 and avpol<=0.5 and avasr<=0.5 then clustav=7; 
	else if avass<=0.75 and avpol<=0.75 and avasr<=0.75 then clustav=6; 
	 
end;

if avtot>. then do;
	loav=clustav>4;
	lopart=clustpart>4;
	lolhd=clustlhd>3;
	if clustlhd=5 then lolhd=0;
end;

if loav=0 and lopart=0 and lolhd=0 then clusttot=1; 
else if loav=0 and lopart=1 and lolhd=0 then clusttot=2; 
else if loav=0 and lopart=0 and lolhd=1 then clusttot=3; 
else if loav=0 and lopart=1 and lolhd=1 then clusttot=4; 
else if loav=1 and lopart=1 and lolhd=1 then clusttot=5;
else if loav=1 and lopart=0 and lolhd=1 then clusttot=6;
else if loav=1 and lopart=1 and lolhd=0 then clusttot=7;
else if loav=1 and lopart=0 and lolhd=0 then clusttot=7;

run;


data temp2;
set  temp2;
 array clus (*) clusttot1-clusttot7;
 do i=1 to hbound(clus);
 	if clusttot>. then do;
		clus(i)=0;
		if clusttot=i then clus(i)=1;
	end;
end;
run;

proc means n mean stddev uclm lclm data=temp2;
var clusttot1--clusttot7;
run;

proc freq data=temp2;
tables clust:;
run;


proc freq data=temp2;
tables clusttot;
where large=1;
run;

proc freq data=temp2;
tables clusttot;
where large=0;
run;

proc freq data=temp2;
tables av1-av20 ;
where large=1;
run;

proc freq data=temp2;
tables av1-av20 ;
where large=0;
run;

data temp2;
set  temp2;
/*Newer ordering of variables*/
avass_new=sum(of av1-av6)/n(of av1-av6);
avpol_new=sum(of av7-av13 av18 av19)/n(of av7-av13 av18 av19);
avasr_new=sum(of av14-av17 av20)/n(of av14-av17 av20);
avtot_new=(avass_new+avpol_new+avasr_new)/3;

effass_new=sum(of eff1-eff6)/n(of eff1-eff6);
effpol_new=sum(of eff7-eff13 eff18 eff19)/n(of eff7-eff13 eff18 eff19);
effasr_new=sum(of eff14-eff17 eff20)/n(of eff14-eff17 eff20);
efftot_new=(effass_new+effpol_new+effasr_new)/3;

lhdass_new=sum(of lhd1-lhd6)/n(of lhd1-lhd6);
lhdpol_new=sum(of lhd7-lhd13 lhd18 lhd19)/n(of lhd7-lhd13 lhd18 lhd19);
lhdasr_new=sum(of lhd14-lhd17 lhd20)/n(of lhd14-lhd17 lhd20);
lhdtot_new=(lhdass_new+lhdpol_new+lhdasr_new)/3;
run;

proc means data=temp2;
var avass_new avpol_new avasr_new avtot_new;
where large=1;
run;

proc means data=temp2;
var avass_new avpol_new avasr_new avtot_new;
where large=0;
run;

/*
proc means n mean stddev uclm lclm data=temp2;
var clusttot1--clusttot7;
run;

proc means n mean stddev uclm lclm data=temp2;
where pop13>=100000;
var clusttot1--clusttot7;
run;

*/


/*****************************************************************************************************************************
Create network analytic measures from NLSPHS data

NOTE that the code below uses the external program: U:\Projects\PHPBRN\Research Projects\NLSPHS\Network analysis\bcent.sas

*****************************************************************************************************************************/

*note: in the array below i use only the org categories that were used in both 1998 and 2006, so i drop SHA, SAO, FBO, NONo, EMP.  Check  this;

data temp3;
set temp2;

array lhd (19) lhd1-lhd19;
array  lhdn (19) lhdn1-lhdn19;
do i=1 to hbound(lhd);
	lhdn(i)=lhd(i);
	if lhdn(i)>0 then lhdn(i)=1;
end;

array serv (14,19) 
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

if yearsurvey in (1998, 2006) then numorgs=12;
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
by TBD_UNID arm yearsurvey survresp;
run;


/******************************************************************
	IML programming routines for calculating betweeness centrality
******************************************************************/


proc iml;
%include 'C:\Users\Lava\Dropbox\bcent.sas';  /* run bcent.sas  */

use temp3;

z = {. . . . . . . . . . . . . . . . . .}; /** z is 1x18 numerical vector with all missing values**/
create lava.outData from z[colname={"tbd_unid" "arm" "yearsurvey" "survresp" "betw1" "betw2" "betw3" "betw4" "betw5" "betw6" "betw7" "betw8" "betw9" "betw10" "betw11" "betw12" "betw13" "betw14" }];

setin temp3; /** make this dataset current for reading **/
setout lava.outData; /** make this dataset current for writing **/


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
	
	read current var {tbd_unid arm yearsurvey survresp} into D;  /* get identification variables */

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

close temp3 lava.outData;

quit;

proc sort data=temp3;
by tbd_unid yearsurvey;
run;

proc sort data=lava.outData;
by tbd_unid yearsurvey;
run;

data lava.nlsphs2014;
merge temp3 lava.outData;
by 	tbd_unid yearsurvey;
run;

options pagesize=3000;

proc means n mean stddev min max data=lava.nlsphs2014;
class yearsurvey;
var av1-av19 avass--avtot lhdn1-lhdn19 phy1-phy19 phyass--phytot chc1-chc19 chcass--chctot hsp1-hsp19 hspass--hsptot ins1-ins19 emp1-emp19 ocent1-ocent14 betw1-betw14 orgdens orgcent ocent1-ocent14 org1_1-org1_14 org5_1-org5_14 org6_1-org6_14 org7_1-org7_14 org9_1-org9_14 org14_1-org14_14
clusttot clusttot1--clusttot7;
where survresp=1 and large=1;
run;

PROC EXPORT DATA= LAVA.NLSPHS2014 
            OUTFILE= "C:\Users\Lava\Dropbox\Data\NLSPHS\Glen\nlsphs2014_SNAandCLUSTTOT.dta" 
            DBMS=STATA REPLACE;
RUN;


