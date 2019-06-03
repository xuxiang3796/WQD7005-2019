Label _ReplaceCount1 = "close";
if close ne REP_close then
_DIFF1= 1;
 else 
_DIFF1= 0;
Label _ReplaceCount2 = "high";
if high ne REP_high then
_DIFF2= 1;
 else 
_DIFF2= 0;
Label _ReplaceCount3 = "low";
if low ne REP_low then
_DIFF3= 1;
 else 
_DIFF3= 0;
Label _ReplaceCount4 = "open";
if open ne REP_open then
_DIFF4= 1;
 else 
_DIFF4= 0;
