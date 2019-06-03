* ;
*Variable: close;
* ;
Label REP_close= 'Replacement: close';
REP_close= close;
if close eq . then REP_close = .;
else
if close<0.01 then REP_close=.;
