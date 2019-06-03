if NAME="change_flag" then ROLE="REJECTED";
else
if NAME="REP_change_flag" then do;
ROLE="INPUT";
LEVEL="NOMINAL";
end;
else
if NAME="trade_flag" then ROLE="REJECTED";
else
if NAME="REP_trade_flag" then do;
ROLE="TARGET";
LEVEL="NOMINAL";
end;
