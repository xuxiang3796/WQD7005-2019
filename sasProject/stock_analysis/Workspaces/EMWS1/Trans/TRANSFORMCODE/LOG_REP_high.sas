label LOG_REP_high = 'Transformed: Replacement: high';
if REP_high eq . then LOG_REP_high = .;
else do;
if REP_high + 1 > 0 then LOG_REP_high = log(REP_high + 1);
else LOG_REP_high = .;
end;
