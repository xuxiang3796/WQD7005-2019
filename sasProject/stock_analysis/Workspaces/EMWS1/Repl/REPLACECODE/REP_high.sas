* ;
*Variable: high;
* ;
Label REP_high= 'Replacement: high';
REP_high= high;
if high eq . then REP_high = .;
else
if high<0.01 then REP_high=.;
