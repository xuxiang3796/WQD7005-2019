label LOG_REP_low = 'Transformed: Replacement: low';
if REP_low eq . then LOG_REP_low = .;
else do;
if REP_low + 1 > 0 then LOG_REP_low = log(REP_low + 1);
else LOG_REP_low = .;
end;
