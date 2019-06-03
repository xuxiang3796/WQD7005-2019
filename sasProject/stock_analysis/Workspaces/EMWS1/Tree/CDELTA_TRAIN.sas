if upcase(NAME) = "CHANGE_FLAG" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "Q_TRADE_FLAGBUY" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "Q_TRADE_FLAGHOLD" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "Q_TRADE_FLAGSELL" then do;
ROLE = "ASSESS";
end;
else 
if upcase(NAME) = "REP_CLOSE" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "REP_HIGH" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "REP_LOW" then do;
ROLE = "REJECTED";
end;
else 
if upcase(NAME) = "_NODE_" then do;
ROLE = "SEGMENT";
LEVEL = "NOMINAL";
end;
