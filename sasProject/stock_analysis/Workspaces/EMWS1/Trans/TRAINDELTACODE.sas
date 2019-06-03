
if NAME="LOG_REP_close" then do;
   COMMENT = "log(REP_close  + 1) ";
ROLE ="INPUT";
REPORT ="N";
LEVEL  ="INTERVAL";
end;
if NAME="REP_close" then delete;

if NAME="LOG_REP_high" then do;
   COMMENT = "log(REP_high  + 1) ";
ROLE ="INPUT";
REPORT ="N";
LEVEL  ="INTERVAL";
end;
if NAME="REP_high" then delete;

if NAME="LOG_REP_low" then do;
   COMMENT = "log(REP_low  + 1) ";
ROLE ="INPUT";
REPORT ="N";
LEVEL  ="INTERVAL";
end;
if NAME="REP_low" then delete;

if NAME="LOG_REP_open" then do;
   COMMENT = "log(REP_open  + 1) ";
ROLE ="INPUT";
REPORT ="N";
LEVEL  ="INTERVAL";
end;
if NAME="REP_open" then delete;
