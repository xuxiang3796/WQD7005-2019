* ;
*Variable: open;
* ;
Label REP_open= 'Replacement: open';
REP_open= open;
if open eq . then REP_open = .;
else
if open<0.01 then REP_open=.;
