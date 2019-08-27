

ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Regional Population.pdf'; 
Proc print data=sashelp.Demographics;run;
ods pdf close;
Proc contents data= sashelp.Demographics;run;
ods graphics;
title;
footnote;

*Project Problem:-1;

Proc sql;
options nodate nonumber;
Title1 'Total Population By Region';
Title2 "Date Created:- &sysdate";
Title3 'Prepared By Harsh';
Footnote j=r 'All Demographic Data is confidential';
Create Table RegionalPopulation as select region label='Region Name',sum(pop)format=comma15. as TotPop label='Total Population'
from sashelp.Demographics
Group by region;
quit;
ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Regional Population.pdf'; 
proc print data=RegionalPopulation label
style(header)={backgroundcolor=Yellow color=Blue just=c};
var region TotPop;
run;
ods pdf close;


*Project Problem:-2;

Proc format;
value ALrat
0-<0.5= 'Low Literacy rate'
0.5-<0.9 = 'Medium Literacy rate'
0.9-high = 'High Literacy rate'
other ='Missing value';
run;

ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Tabulate.pdf';
Proc tabulate data=sashelp.Demographics;
class region AdultLiteracypct;
Format AdultLiteracypct ALrat.;
Var pop popAGR popUrban;
label pop='Population' popAGR='% Population Annual Growth rate' popUrban='% Population in Urban Areas'
region='Region Name' AdultLiteracypct='Adult Literacy rate Level';
Table region*AdultLiteracypct, (pop*f=comma15.)(popAGR*f=percent9.2 popUrban*f=percent9.2)*mean / box='Region Vs Adult Literacy Rate';
keylabel 
Sum='Sum of Population'
mean='Average';
Title1 'Tabular report for Regional Adult Literacy Rate Level against Total Population
,%Population AGR & % Population in Urban Areas';
Title2 "Date Created:- &sysdate";
Title3 'Prepared By Harsh';
Footnote j=r 'All Demographic Data is confidential';
run;
ods pdf close;



*Project Problem:-3,A;

/*ods listing gpath='C:\Users\Harsh Mac Windows\Documents\SAS';
ODS graphics/
Reset imagename ='Vertical Bar Chart' outputfmt=JPEG /*height=8in width = 9in ;*/

ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Vbar.pdf';
Proc Sgplot data=sashelp.Demographics;
Vbar region /group=AdultLiteracypct response= pop datalabel groupdisplay=cluster;
yaxis grid
label= 'Population Numbers'
values= (0 to 1750000000 by 250000000);
Format AdultLiteracypct ALrat.; 
Label region='Region Name' AdultLiteracypct='Adult Literacy rate Level' pop='Population' ;
Title " Vertical Bar Chart for Total Population by Region with Groups by Adult Literacy rate Level (new indicator)";
Title2 "Date Created:- &sysdate";
Title3 'Prepared By Harsh';
Footnote j=l 'All Demographic Data is confidential';;
Run;
ods pdf close;

ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Vbar.pdf';
Proc Sgplot data=sashelp.Demographics;
Vbar region /group=AdultLiteracypct response=pop datalabel ;
yaxis grid label= 'Population Numbers' values= (0 to 1750000000 by 250000000);
Format AdultLiteracypct ALrat.; 
Label region='Region Name' AdultLiteracypct='Adult Literacy rate Level' pop='Population';
Title 'VerticalBar Chart for Total Population by Region with Groups by ALrat(new indicator)';
Title2 "Date Created:- &sysdate";
Title3 'Prepared By Harsh';
Footnote j=r 'All Demographic Data is confidential';
Run;
ods pdf close;

*Project Problem:-3,B;

proc sql;
create table UrbanPopulation as select pop label='Total Population',
popUrban label='% Urban Population',
pop*popUrban as TotPopUrban label='Total Population in Urban Area' format=comma15. 
from sashelp.Demographics;
quit;
ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Histogram.pdf';
Proc sgplot data=UrbanPopulation;
Histogram TotPopUrban/showbins nbins=10 transparency=.6;
yaxis grid label='Percent (%)';
Density TotPopUrban;
label TotPopUrban='Total Population in Urban Area';
Title 'Histogram with Normal Density Curve for Population in Urban Areas';
Title2 "Date Created:- &sysdate";
Title3 'Prepared By Harsh';
Footnote j=l 'All Demographic Data is confidential';
Run;
ods pdf close;

*Project Problem:-4;

Proc sql;
option nodate nonumber;
create table SubDemographic as 
select NAME label = 'Country Name',region label='Region Name',pop label= 'Population',
popUrban label= '% Urban Population',
GNI label='Per Capita Gross National Income',
case
when GNI =. then 'Missing Data- PCI not given' 
when GNI <=5000 then 'Low'
when GNI <=20000 then 'Middle'
when GNI >20000 then 'High'
end as PCILevel label= 'Per Capita GNI Level'
from sashelp.Demographics
where region in ('AMR' 'EUR');
quit;
ods pdf file='C:\Users\Harsh Mac Windows\Documents\SAS\Problem4.pdf'; 
proc print data=SubDemographic label
style(header)={backgroundcolor=Yellow color=Blue just=c};
var NAME region pop popUrban GNI PCILevel;
title 'Country wise Population, % Urban Population,
Per Capita GNI and Per Capita GNI Level for "AMR" & "EUR"  
Region';
Title2 "Date Created:- &sysdate";
Title3 'Prepared By Harsh';
Footnote j=r 'All Demographic Data is confidential';
run;
Ods pdf close;


data Subdemographics;
length percapita $8.;
 set sashelp.Demographics;
 where region in ("AMR" "EUR");
 if GNI=. then percapita='Missing Value';
if GNI<=5000 then percapita='Low';
  if 5000<GNI<=20000 then percapita='Middle';
  if GNI>20000 then percapita='High';
keep NAME GNI region pop popurban percapita   ;
run;

Proc print data=Subdemographics label noobs;
run;

proc freq data=Subdemographics;
 table percapita;
run;
Proc sort; by region;


