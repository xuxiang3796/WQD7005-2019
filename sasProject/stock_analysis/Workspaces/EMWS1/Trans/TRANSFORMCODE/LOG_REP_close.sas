label LOG_REP_close = 'Transformed: Replacement: close';
if REP_close eq . then LOG_REP_close = .;
else do;
if REP_close + 1 > 0 then LOG_REP_close = log(REP_close + 1);
else LOG_REP_close = .;
end;
