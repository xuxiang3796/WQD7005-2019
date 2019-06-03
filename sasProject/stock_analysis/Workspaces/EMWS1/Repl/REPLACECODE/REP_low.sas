* ;
*Variable: low;
* ;
Label REP_low= 'Replacement: low';
REP_low= low;
if low eq . then REP_low = .;
else
if low<0.01 then REP_low=.;
