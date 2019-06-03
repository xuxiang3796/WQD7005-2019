*------------------------------------------------------------*;
* Part: Retrieving stratification variable(s) levels;
*------------------------------------------------------------*;
proc freq data=EMWS1.Repl_TRAIN noprint;
format
trade_flag $4.
;
table
trade_flag
/out=WORK.Part_FREQ(drop=percent);
run;
proc sort data=WORK.Part_FREQ;
by descending count;
run;
* Part: Retrieving levels that meet minimum requirement;
data WORK.Part_FREQ2(keep = count);
set WORK.Part_FREQ;
where (.01 * 70 * count) >= 3;
run;
*------------------------------------------------------------*;
* Part: Create stratified partitioning;
*------------------------------------------------------------*;
data
EMWS1.Part_TRAIN(label="")
EMWS1.Part_VALIDATE(label="")
;
retain _seed_ 12345;
drop _seed_ _genvalue_;
call ranuni(_seed_, _genvalue_);
label _dataobs_ = "%sysfunc(sasmsg(sashelp.dmine, sample_dataobs_vlabel, NOQUOTE))";
_dataobs_ = _N_;
drop _c00:;
set EMWS1.Repl_TRAIN;
length _Pformat1 $54;
drop _Pformat1;
_Pformat1 = strip(put(trade_flag, $4.));
if
_Pformat1 = 'sell'
then do;
if (98+1-_C000003)*_genvalue_ <= (69 - _C000001) then do;
_C000001 + 1;
output EMWS1.Part_TRAIN;
end;
else do;
_C000002 + 1;
output EMWS1.Part_VALIDATE;
end;
_C000003+1;
end;
else if
_Pformat1 = 'hold'
then do;
if (63+1-_C000006)*_genvalue_ <= (44 - _C000004) then do;
_C000004 + 1;
output EMWS1.Part_TRAIN;
end;
else do;
_C000005 + 1;
output EMWS1.Part_VALIDATE;
end;
_C000006+1;
end;
else if
_Pformat1 = 'buy'
then do;
if (35+1-_C000009)*_genvalue_ <= (25 - _C000007) then do;
_C000007 + 1;
output EMWS1.Part_TRAIN;
end;
else do;
_C000008 + 1;
output EMWS1.Part_VALIDATE;
end;
_C000009+1;
end;
run;
