else 
if NAME  = "M_LOG_REP_close " then do;
   ROLE  ="INPUT";
   LEVEL ="UNARY";
 end;
if NAME = "LOG_REP_high" then delete;
else 
if NAME    = "IMP_LOG_REP_high"  then do;
   ROLE    = "INPUT" ;
   FAMILY  = "" ;
   REPORT  = "N" ;
   LEVEL   = "INTERVAL" ;
   ORDER   = "" ;
end;
else 
if NAME  = "M_LOG_REP_high " then do;
   ROLE  ="INPUT";
   LEVEL ="BINARY";
 end;
if NAME = "LOG_REP_low" then delete;
else 
if NAME    = "IMP_LOG_REP_low"  then do;
   ROLE    = "INPUT" ;
   FAMILY  = "" ;
   REPORT  = "N" ;
   LEVEL   = "INTERVAL" ;
   ORDER   = "" ;
end;
else 
if NAME  = "M_LOG_REP_low " then do;
   ROLE  ="INPUT";
   LEVEL ="BINARY";
 end;
if NAME = "LOG_REP_open" then delete;
else 
if NAME    = "IMP_LOG_REP_open"  then do;
   ROLE    = "INPUT" ;
   FAMILY  = "" ;
   REPORT  = "N" ;
   LEVEL   = "INTERVAL" ;
   ORDER   = "" ;
end;
else 
if NAME  = "M_LOG_REP_open " then do;
   ROLE  ="INPUT";
   LEVEL ="BINARY";
 end;
else 
if NAME  = "M_REP_change_flag " then do;
   ROLE  ="INPUT";
   LEVEL ="UNARY";
 end;
else 
if NAME  = "M_REP_trade_flag " then do;
   ROLE  ="INPUT";
   LEVEL ="UNARY";
 end;
else 
if NAME  = "M_stock_code " then do;
   ROLE  ="INPUT";
   LEVEL ="UNARY";
 end;
else 
if NAME  = "M_vol " then do;
   ROLE  ="INPUT";
   LEVEL ="UNARY";
 end;
