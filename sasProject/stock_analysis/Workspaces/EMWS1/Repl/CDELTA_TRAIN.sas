if NAME="close" then do;
ROLE="REJECTED";
COMMENT= "Replaced by Repl";
end;
else
if NAME="REP_close" then do;
ROLE="INPUT";
LEVEL="INTERVAL";
end;
else
if NAME="high" then do;
ROLE="REJECTED";
COMMENT= "Replaced by Repl";
end;
else
if NAME="REP_high" then do;
ROLE="INPUT";
LEVEL="INTERVAL";
end;
else
if NAME="low" then do;
ROLE="REJECTED";
COMMENT= "Replaced by Repl";
end;
else
if NAME="REP_low" then do;
ROLE="INPUT";
LEVEL="INTERVAL";
end;
else
if NAME="open" then do;
ROLE="REJECTED";
COMMENT= "Replaced by Repl";
end;
else
if NAME="REP_open" then do;
ROLE="INPUT";
LEVEL="INTERVAL";
end;
