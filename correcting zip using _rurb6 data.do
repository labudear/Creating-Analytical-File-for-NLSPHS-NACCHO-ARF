use "X:\xDATA\NLSPHS 2014\Analysis\AnalyticalFiles\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb6.dta", clear

/*Check clusttot*/

/*

. tab clusttot yearsurvey if large==1, col

+-------------------+
| Key               |
|-------------------|
|     frequency     |
| column percentage |
+-------------------+

  Typology |
   cluster |     Year of Mays survey (1998 or 2006)
   numbers |      1998       2006       2012       2014 |     Total
-----------+--------------------------------------------+----------
         1 |        44         50         29         58 |       181 
           |     12.54      21.46      12.03      20.64 |     16.37 
-----------+--------------------------------------------+----------
         2 |        18          9         15         30 |        72 
           |      5.13       3.86       6.22      10.68 |      6.51 
-----------+--------------------------------------------+----------
         3 |        23         27         31         29 |       110 
           |      6.55      11.59      12.86      10.32 |      9.95 
-----------+--------------------------------------------+----------
         4 |        12          7          9         13 |        41 
           |      3.42       3.00       3.73       4.63 |      3.71 
-----------+--------------------------------------------+----------
         5 |       164         72        109         99 |       444 
           |     46.72      30.90      45.23      35.23 |     40.14 
-----------+--------------------------------------------+----------
         6 |        43         42         28         23 |       136 
           |     12.25      18.03      11.62       8.19 |     12.30 
-----------+--------------------------------------------+----------
         7 |        47         26         20         29 |       122 
           |     13.39      11.16       8.30      10.32 |     11.03 
-----------+--------------------------------------------+----------
     Total |       351        233        241        281 |     1,106 
           |    100.00     100.00     100.00     100.00 |    100.00 


*/
br yearsurvey nacchoid zip* lhdzip* lhdname* nzip c1q9 if survresp==1 & zip_rec==""
replace zip_rec=lhdzip06 if zip_rec=="" & survresp==1
replace zip_rec=zip_06 if zip_rec=="" & survresp==1

br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="TX139"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA031"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="OH136"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="SC015"
replace zip_rec="29648" if zip_rec=="" & nacchoid=="SC015"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA071"
replace zip_rec="30046" if zip_rec=="" & nacchoid=="GA071"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="NM013"
replace zip_rec="88001" if zip_rec=="" & nacchoid=="NM013"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="NJ068"
replace zip_rec="07712" if zip_rec=="" & nacchoid=="NJ068"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="OH083"
replace zip_rec="43624" if zip_rec=="" & nacchoid=="OH083"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="LA064"
replace zip_rec="70301" if zip_rec=="" & nacchoid=="LA064"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA038"
replace zip_rec="31902" if zip_rec=="" & nacchoid=="GA038"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA034"
replace zip_rec="30008" if zip_rec=="" & nacchoid=="GA034"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="SC019"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA101"
replace zip_rec="31803" if zip_rec=="" & nacchoid=="GA101"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MS031"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA011"
replace zip_rec="31201" if zip_rec=="" & nacchoid=="GA011"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="WI092"
replace zip_rec="53188" if zip_rec=="" & nacchoid=="WI092"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="VA117"
replace zip_rec="23273" if zip_rec=="" & nacchoid=="VA117"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="WV033"
replace zip_rec="26651" if zip_rec=="" & nacchoid=="WV033"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MS026"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="TX136"
replace zip_rec="76104" if zip_rec=="" & nacchoid=="TX136"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="WI073"
replace zip_rec="53547" if zip_rec=="" & nacchoid=="WI073"
replace zip_rec="53547" if yearsurvey==2012 & nacchoid=="WI073"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MI030"
replace zip_rec="49221" if zip_rec=="" & nacchoid=="MI030"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MS024"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="IN083"
replace zip_rec="47901" if zip_rec=="" & nacchoid=="IN083"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="GA025"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="KY038"
replace zip_rec="42330" if zip_rec=="" & nacchoid=="KY038"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="NY041"
replace zip_rec="12866" if zip_rec=="" & nacchoid=="NY041"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MS042"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="CA004"
replace zip_rec="94704" if zip_rec=="" & nacchoid=="CA004"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="OH082"
replace zip_rec="44035" if zip_rec=="" & nacchoid=="OH082"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="SC010"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="CA052"
replace zip_rec="95404" if zip_rec=="" & nacchoid=="CA052"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MI024"
replace zip_rec="49202" if zip_rec=="" & nacchoid=="MI024"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="CA064"
replace zip_rec="93110" if zip_rec=="" & nacchoid=="CA064"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="TX189"
replace zip_rec="79105" if zip_rec=="" & nacchoid=="TX189"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MA266"
replace zip_rec="01772" if zip_rec=="" & nacchoid=="MA266"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="NJ067"
replace zip_rec="07712" if zip_rec=="" & nacchoid=="NJ067"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="IL074"
replace zip_rec="62703" if zip_rec=="" & nacchoid=="IL074"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="CT009"
replace zip_rec="06608" if zip_rec=="" & nacchoid=="CT009"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="CA047"
replace zip_rec="95061" if zip_rec=="" & nacchoid=="CA047"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MA016"
replace zip_rec="02630" if zip_rec=="" & nacchoid=="MA016"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="WI017"
replace zip_rec="53704" if zip_rec=="" & nacchoid=="WI017"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="SC003"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MT009"
replace zip_rec="59442" if zip_rec=="" & nacchoid=="MT009"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="NY039"
replace zip_rec="12180" if zip_rec=="" & nacchoid=="NY039"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MO002"
replace zip_rec="64485" if zip_rec=="" & nacchoid=="MO002"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="OH135"
replace zip_rec="44224" if zip_rec=="" & nacchoid=="OH135"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MS048"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="IN050"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="FL006"
replace zip_rec="32953" if zip_rec=="" & nacchoid=="FL006"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MS073"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="NC010"
replace zip_rec="28680" if zip_rec=="" & nacchoid=="NC010"
br yearsurvey zip* lhdzip* nzip c1q9 if nacchoid=="MT007"

br yearsurvey nacchoid zip* lhdzip* lhdname* nzip c1q9 if survresp==1 & zip_rec==""

replace zip_rec="29720" if zip_rec=="" & nacchoid=="SC019"
replace zip_rec="39581" if zip_rec=="" & nacchoid=="MS031"
replace zip_rec="75050" if zip_rec=="" & nacchoid=="TX139"
replace zip_rec="39213" if zip_rec=="" & nacchoid=="MS026"
replace zip_rec="39501" if zip_rec=="" & nacchoid=="MS024"
replace zip_rec="31416" if zip_rec=="" & nacchoid=="GA025"
replace zip_rec="38802" if zip_rec=="" & nacchoid=="MS042"
replace zip_rec="29506" if zip_rec=="" & nacchoid=="SC010"
replace zip_rec="25801" if zip_rec=="" & nacchoid=="WV999"
replace zip_rec="44313" if zip_rec=="" & nacchoid=="OH136"
replace zip_rec="29602" if zip_rec=="" & nacchoid=="SC003"
replace zip_rec="38635" if zip_rec=="" & nacchoid=="MS048"
replace zip_rec="46350" if zip_rec=="" & nacchoid=="IN050"
replace zip_rec="32953" if zip_rec=="" & nacchoid=="FL006"
replace zip_rec="38652" if zip_rec=="" & nacchoid=="MS073"
replace zip_rec="28655" if zip_rec=="" & nacchoid=="NC010"
replace zip_rec="59324" if zip_rec=="" & nacchoid=="MT007"
replace zip_rec="30236" if zip_rec=="" & nacchoid=="GA031"

br yearsurvey nacchoid zip* lhdzip* lhdname* nzip c1q9 if survresp==1 & zip_rec==""

save full, replace

import excel "X:\xDATA\NLSPHS 2014\Analysis\AnalyticalFiles\data\ListofSample2014.xlsx", sheet("Sheet1") firstrow clear
sort nacchoid
save list, replace
duplicates list nacchoid

list if nacchoid=="" | nacchoid=="MN046"
drop if _n==514
count if nacchoid==""
drop if nacchoid==""
duplicates list nacchoid

sort nacchoid
save list, replace

use full, clear
sort nacchoid
merge m:1 nacchoid using list

br unid yearsurvey nacchoid zip* lhdzip* lhdname* nzip c1q9 del_* if zip_rec==""

replace zip_rec=del_zip if zip_rec==""
drop del_*

save full, replace


replace zip_rec="30236" if zip_rec=="" & nacchoid=="GA031"

/*Use NACCHO profile survey and/or google to find zip codes for remaining missing data"*/

replace zip_rec="35630" if zip_rec=="" & nacchoid=="AL040"
replace zip_rec="06095" if zip_rec=="" & nacchoid=="CT116"
replace zip_rec="66066" if zip_rec=="" & nacchoid=="KS034"
replace zip_rec="02030" if zip_rec=="" & nacchoid=="MA074"
replace zip_rec="01571" if zip_rec=="" & nacchoid=="MA077"
replace zip_rec="59422" if zip_rec=="" & nacchoid=="MT051"
replace zip_rec="07083" if zip_rec=="" & nacchoid=="NJ021"
replace zip_rec="07093" if zip_rec=="" & nacchoid=="NJ131"
replace zip_rec="73759" if zip_rec=="" & nacchoid=="OK027"
replace zip_rec="38261" if zip_rec=="" & nacchoid=="TN071"
replace zip_rec="75401" if zip_rec=="" & nacchoid=="TX141"
replace zip_rec="54773" if zip_rec=="" & nacchoid=="WI085"
replace zip_rec="45640" if zip_rec=="" & nacchoid=="WV017"
/*2005*/ 
replace zip_rec="68731" if zip_rec=="" & nacchoid=="NE003"
replace zip_rec="57438" if zip_rec=="" & nacchoid=="SD022"
/*1997*/
replace zip_rec="94607" if zip_rec=="" & nacchoid=="CA001"
replace zip_rec="81611" if zip_rec=="" & nacchoid=="CO003"
replace zip_rec="81201" if zip_rec=="" & nacchoid=="CO008"
replace zip_rec="06249" if zip_rec=="" & nacchoid=="CT019"
replace zip_rec="06268" if zip_rec=="" & nacchoid=="CT052"
replace zip_rec="06109" if zip_rec=="" & nacchoid=="CT112"
replace zip_rec="50701" if zip_rec=="" & nacchoid=="IA125"
replace zip_rec="01039" if zip_rec=="" & nacchoid=="MA095"
replace zip_rec="55720" if zip_rec=="" & nacchoid=="MN008"
replace zip_rec="56267" if zip_rec=="" & nacchoid=="MN023"
replace zip_rec="55604" if zip_rec=="" & nacchoid=="MN025"
replace zip_rec="55955" if zip_rec=="" & nacchoid=="MN036"
replace zip_rec="56510" if zip_rec=="" & nacchoid=="MN057"
replace zip_rec="55981" if zip_rec=="" & nacchoid=="MN066"
replace zip_rec="39304" if zip_rec=="" & nacchoid=="MS084"
replace zip_rec="28713" if zip_rec=="" & nacchoid=="NC088"
replace zip_rec="68305" if zip_rec=="" & nacchoid=="NE012"
replace zip_rec="07961" if zip_rec=="" & nacchoid=="NJ004"
replace zip_rec="07675" if zip_rec=="" & nacchoid=="NJ024"

replace zip_rec="07013" if zip_rec=="" & nacchoid=="NJ014"
replace zip_rec="65775" if zip_rec=="" & nacchoid=="MO130"
replace zip_rec="94403" if zip_rec=="" & nacchoid=="CA044"

bysort yearsurvey: count if zip_rec==""

bysort yearsurvey: count if zip_rec=="" & survresp!=.

bysort yearsurvey: count if zip_rec=="" & survresp==1

/*

. bysort yearsurvey: count if zip_rec==""

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 1998
  62
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2006
  1
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2012
  2
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2014
  2

. 
. bysort yearsurvey: count if zip_rec=="" & survresp!=.

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 1998
  2
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2006
  1
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2012
  1
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2014
  1

. 
. bysort yearsurvey: count if zip_rec=="" & survresp==1

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 1998
  1
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2006
  0
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2012
  0
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-> yearsurvey = 2014
  0


*/
save "X:\xDATA\NLSPHS 2014\Analysis\AnalyticalFiles\data\NLSPHSNACCHOARFAll4Waves_wts_peer_rurb7.dta", replace
