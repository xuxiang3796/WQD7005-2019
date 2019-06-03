*------------------------------------------------------------*;
* Reg: Create decision matrix;
*------------------------------------------------------------*;
data WORK.REP_trade_flag;
  length   REP_trade_flag                   $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           DECISION3                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="S"
           DECISION2="H"
           DECISION3="B"
           ;
  format   COUNT 10.
           ;
REP_trade_flag="S"; COUNT=68; DATAPRIOR=0.5037037037037; TRAINPRIOR=0.5037037037037; DECPRIOR=.; DECISION1=1; DECISION2=0; DECISION3=0;
output;
REP_trade_flag="H"; COUNT=43; DATAPRIOR=0.31851851851851; TRAINPRIOR=0.31851851851851; DECPRIOR=.; DECISION1=0; DECISION2=1; DECISION3=0;
output;
REP_trade_flag="B"; COUNT=24; DATAPRIOR=0.17777777777777; TRAINPRIOR=0.17777777777777; DECPRIOR=.; DECISION1=0; DECISION2=0; DECISION3=1;
output;
;
run;
proc datasets lib=work nolist;
modify REP_trade_flag(type=PROFIT label=REP_trade_flag);
label DECISION1= 'S';
label DECISION2= 'H';
label DECISION3= 'B';
run;
quit;
data EM_DMREG / view=EM_DMREG;
set EMWS1.Impt_TRAIN(keep=
IMP_LOG_REP_high IMP_LOG_REP_low IMP_LOG_REP_open LOG_REP_close M_LOG_REP_high
M_LOG_REP_low M_LOG_REP_open REP_change_flag REP_trade_flag stock_code vol );
run;
*------------------------------------------------------------* ;
* Reg: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    M_LOG_REP_high(ASC) M_LOG_REP_low(ASC) M_LOG_REP_open(ASC)
   REP_change_flag(ASC) REP_trade_flag(DESC) stock_code(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Reg: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    IMP_LOG_REP_high IMP_LOG_REP_low IMP_LOG_REP_open LOG_REP_close vol
%mend DMDBVar;
*------------------------------------------------------------*;
* Reg: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_DMREG
dmdbcat=WORK.Reg_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
REP_trade_flag
;
run;
quit;
*------------------------------------------------------------*;
* Reg: Run DMREG procedure;
*------------------------------------------------------------*;
proc dmreg data=EM_DMREG dmdbcat=WORK.Reg_DMDB
validata = EMWS1.Impt_VALIDATE
outest = EMWS1.Reg_EMESTIMATE
outterms = EMWS1.Reg_OUTTERMS
outmap= EMWS1.Reg_MAPDS namelen=200
;
class
REP_trade_flag
M_LOG_REP_high
M_LOG_REP_low
M_LOG_REP_open
REP_change_flag
stock_code
;
model REP_trade_flag =
IMP_LOG_REP_high
IMP_LOG_REP_low
IMP_LOG_REP_open
LOG_REP_close
M_LOG_REP_high
M_LOG_REP_low
M_LOG_REP_open
REP_change_flag
stock_code
vol
/level=nominal
coding=DEVIATION
nodesignprint
;
;
code file="C:\Users\dante\Documents\My SAS Files\9.4\stock3\Workspaces\EMWS1\Reg\EMPUBLISHSCORE.sas"
group=Reg
;
code file="C:\Users\dante\Documents\My SAS Files\9.4\stock3\Workspaces\EMWS1\Reg\EMFLOWSCORE.sas"
group=Reg
residual
;
run;
quit;
