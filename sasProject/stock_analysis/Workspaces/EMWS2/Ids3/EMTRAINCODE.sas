*------------------------------------------------------------*;
* Data Source Setup;
*------------------------------------------------------------*;
libname EMWS2 "C:\Users\dante\Documents\My SAS Files\9.4\stock3\Workspaces\EMWS2";
*------------------------------------------------------------*;
* Ids3: Creating DATA data;
*------------------------------------------------------------*;
data EMWS2.Ids3_DATA (label="")
/ view=EMWS2.Ids3_DATA
;
set AAEM61.DTSTOCK_TRAIN;
run;
