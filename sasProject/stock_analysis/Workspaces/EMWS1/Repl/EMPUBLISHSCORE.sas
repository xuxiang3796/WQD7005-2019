* ;
* Variable: close ;
* ;
Label REP_close='Replacement: close';
REP_close =close ;
if close  eq . then REP_close = . ;
else
if close <0.01  then REP_close  = . ;
* ;
* Variable: high ;
* ;
Label REP_high='Replacement: high';
REP_high =high ;
if high  eq . then REP_high = . ;
else
if high <0.01  then REP_high  = . ;
* ;
* Variable: low ;
* ;
Label REP_low='Replacement: low';
REP_low =low ;
if low  eq . then REP_low = . ;
else
if low <0.01  then REP_low  = . ;
* ;
* Variable: open ;
* ;
Label REP_open='Replacement: open';
REP_open =open ;
if open  eq . then REP_open = . ;
else
if open <0.01  then REP_open  = . ;
