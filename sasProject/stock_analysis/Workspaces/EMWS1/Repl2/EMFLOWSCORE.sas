   
* ;
* Defining New Variables;
* ;
Length REP_change_flag $3;
Label REP_change_flag='Replacement: change_flag';
format REP_change_flag $3.;
REP_change_flag= change_flag;
Length REP_trade_flag $4;
Label REP_trade_flag='Replacement: trade_flag';
format REP_trade_flag $4.;
REP_trade_flag= trade_flag;
   
* ;
* Replace Specific Class Levels ;
* ;
length _UFormat200 $200;
drop   _UFORMAT200;
_UFORMAT200 = " ";
* ;
* Variable: change_flag;
* ;
_UFORMAT200 = strip(
put(change_flag,$3.));
if _UFORMAT200 =  "pos" then
REP_change_flag="P";
else
if _UFORMAT200 =  "non" then
REP_change_flag="O";
else
if _UFORMAT200 =  "neg" then
REP_change_flag="N";
* ;
* Variable: trade_flag;
* ;
_UFORMAT200 = strip(
put(trade_flag,$4.));
if _UFORMAT200 =  "sell" then
REP_trade_flag="S";
else
if _UFORMAT200 =  "hold" then
REP_trade_flag="H";
else
if _UFORMAT200 =  "buy" then
REP_trade_flag="B";
