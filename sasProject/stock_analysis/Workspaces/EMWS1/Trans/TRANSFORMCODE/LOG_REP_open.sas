label LOG_REP_open = 'Transformed: Replacement: open';
if REP_open eq . then LOG_REP_open = .;
else do;
if REP_open + 1 > 0 then LOG_REP_open = log(REP_open + 1);
else LOG_REP_open = .;
end;
