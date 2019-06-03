****************************************************************;
******             DECISION TREE SCORING CODE             ******;
****************************************************************;
 
******         LENGTHS OF NEW CHARACTER VARIABLES         ******;
LENGTH F_trade_flag  $    4;
LENGTH I_trade_flag  $    4;
LENGTH U_trade_flag  $    4;
LENGTH _WARN_  $    4;
 
******              LABELS FOR NEW VARIABLES              ******;
label _NODE_ = 'Node' ;
label _LEAF_ = 'Leaf' ;
label P_trade_flagsell = 'Predicted: trade_flag=sell' ;
label P_trade_flaghold = 'Predicted: trade_flag=hold' ;
label P_trade_flagbuy = 'Predicted: trade_flag=buy' ;
label Q_trade_flagsell = 'Unadjusted P: trade_flag=sell' ;
label Q_trade_flaghold = 'Unadjusted P: trade_flag=hold' ;
label Q_trade_flagbuy = 'Unadjusted P: trade_flag=buy' ;
label V_trade_flagsell = 'Validated: trade_flag=sell' ;
label V_trade_flaghold = 'Validated: trade_flag=hold' ;
label V_trade_flagbuy = 'Validated: trade_flag=buy' ;
label R_trade_flagsell = 'Residual: trade_flag=sell' ;
label R_trade_flaghold = 'Residual: trade_flag=hold' ;
label R_trade_flagbuy = 'Residual: trade_flag=buy' ;
label F_trade_flag = 'From: trade_flag' ;
label I_trade_flag = 'Into: trade_flag' ;
label U_trade_flag = 'Unnormalized Into: trade_flag' ;
label _WARN_ = 'Warnings' ;
 
 
******      TEMPORARY VARIABLES FOR FORMATTED VALUES      ******;
LENGTH _ARBFMT_4 $      4; DROP _ARBFMT_4;
_ARBFMT_4 = ' '; /* Initialize to avoid warning. */
LENGTH _ARBFMT_12 $     12; DROP _ARBFMT_12;
_ARBFMT_12 = ' '; /* Initialize to avoid warning. */
 
 
_ARBFMT_4 = PUT( trade_flag , $4.);
 %DMNORMCP( _ARBFMT_4, F_trade_flag );
 
******             ASSIGN OBSERVATION TO NODE             ******;
IF  NOT MISSING(vol ) AND
  vol  <                  0.5 THEN DO;
  _NODE_  =                    2;
  _LEAF_  =                    1;
  P_trade_flagsell  =                    0;
  P_trade_flaghold  =                    0;
  P_trade_flagbuy  =                    1;
  Q_trade_flagsell  =                    0;
  Q_trade_flaghold  =                    0;
  Q_trade_flagbuy  =                    1;
  V_trade_flagsell  =                    0;
  V_trade_flaghold  =                    0;
  V_trade_flagbuy  =                    1;
  I_trade_flag  = 'BUY' ;
  U_trade_flag  = 'buy' ;
  END;
ELSE DO;
  _ARBFMT_12 = PUT( stock_code , BEST12.);
   %DMNORMIP( _ARBFMT_12);
  IF _ARBFMT_12 IN ('7216' ,'8125' ,'2984' ) THEN DO;
    _NODE_  =                    5;
    _LEAF_  =                    5;
    P_trade_flagsell  =                    1;
    P_trade_flaghold  =                    0;
    P_trade_flagbuy  =                    0;
    Q_trade_flagsell  =                    1;
    Q_trade_flaghold  =                    0;
    Q_trade_flagbuy  =                    0;
    V_trade_flagsell  =                    1;
    V_trade_flaghold  =                    0;
    V_trade_flagbuy  =                    0;
    I_trade_flag  = 'SELL' ;
    U_trade_flag  = 'sell' ;
    END;
  ELSE DO;
    IF  NOT MISSING(REP_open ) AND
                     5.095 <= REP_open  THEN DO;
      _NODE_  =                    7;
      _LEAF_  =                    4;
      P_trade_flagsell  =                    1;
      P_trade_flaghold  =                    0;
      P_trade_flagbuy  =                    0;
      Q_trade_flagsell  =                    1;
      Q_trade_flaghold  =                    0;
      Q_trade_flagbuy  =                    0;
      V_trade_flagsell  =                    1;
      V_trade_flaghold  =                    0;
      V_trade_flagbuy  =                    0;
      I_trade_flag  = 'SELL' ;
      U_trade_flag  = 'sell' ;
      END;
    ELSE DO;
      IF  NOT MISSING(vol ) AND
        vol  <                 50.5 THEN DO;
        _NODE_  =                    8;
        _LEAF_  =                    2;
        P_trade_flagsell  =                    1;
        P_trade_flaghold  =                    0;
        P_trade_flagbuy  =                    0;
        Q_trade_flagsell  =                    1;
        Q_trade_flaghold  =                    0;
        Q_trade_flagbuy  =                    0;
        V_trade_flagsell  =                    0;
        V_trade_flaghold  =                    1;
        V_trade_flagbuy  =                    0;
        I_trade_flag  = 'SELL' ;
        U_trade_flag  = 'sell' ;
        END;
      ELSE DO;
        _NODE_  =                    9;
        _LEAF_  =                    3;
        P_trade_flagsell  =     0.16666666666666;
        P_trade_flaghold  =     0.79629629629629;
        P_trade_flagbuy  =     0.03703703703703;
        Q_trade_flagsell  =     0.16666666666666;
        Q_trade_flaghold  =     0.79629629629629;
        Q_trade_flagbuy  =     0.03703703703703;
        V_trade_flagsell  =     0.30434782608695;
        V_trade_flaghold  =     0.69565217391304;
        V_trade_flagbuy  =                    0;
        I_trade_flag  = 'HOLD' ;
        U_trade_flag  = 'hold' ;
        END;
      END;
    END;
  END;
 
*****  RESIDUALS R_ *************;
IF  F_trade_flag  NE 'SELL'
AND F_trade_flag  NE 'HOLD'
AND F_trade_flag  NE 'BUY'  THEN DO;
        R_trade_flagsell  = .;
        R_trade_flaghold  = .;
        R_trade_flagbuy  = .;
 END;
 ELSE DO;
       R_trade_flagsell  =  -P_trade_flagsell ;
       R_trade_flaghold  =  -P_trade_flaghold ;
       R_trade_flagbuy  =  -P_trade_flagbuy ;
       SELECT( F_trade_flag  );
          WHEN( 'SELL'  ) R_trade_flagsell  = R_trade_flagsell  +1;
          WHEN( 'HOLD'  ) R_trade_flaghold  = R_trade_flaghold  +1;
          WHEN( 'BUY'  ) R_trade_flagbuy  = R_trade_flagbuy  +1;
       END;
 END;
 
****************************************************************;
******          END OF DECISION TREE SCORING CODE         ******;
****************************************************************;
 
drop _LEAF_;
