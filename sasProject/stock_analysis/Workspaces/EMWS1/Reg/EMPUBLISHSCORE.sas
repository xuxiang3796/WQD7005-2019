*************************************;
*** begin scoring code for regression;
*************************************;

length _WARN_ $4;
label _WARN_ = 'Warnings' ;

length I_REP_trade_flag $ 4;
label I_REP_trade_flag = 'Into: REP_trade_flag' ;
*** Target Values;
array REGDRF [3] $4 _temporary_ ('S' 'H' 'B' );
label U_REP_trade_flag = 'Unnormalized Into: REP_trade_flag' ;
format U_REP_trade_flag $4.;
length U_REP_trade_flag $ 4;
*** Unnormalized target values;
array REGDRU[3] $ 4 _temporary_ ('S   '  'H   '  'B   ' );

drop _DM_BAD;
_DM_BAD=0;

*** Check IMP_LOG_REP_high for missing values ;
if missing( IMP_LOG_REP_high ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check IMP_LOG_REP_low for missing values ;
if missing( IMP_LOG_REP_low ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check IMP_LOG_REP_open for missing values ;
if missing( IMP_LOG_REP_open ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check LOG_REP_close for missing values ;
if missing( LOG_REP_close ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check vol for missing values ;
if missing( vol ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Generate dummy variables for M_LOG_REP_high ;
drop _1_0 ;
if missing( M_LOG_REP_high ) then do;
   _1_0 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( M_LOG_REP_high , BEST12. );
   %DMNORMIP( _dm12 )
   if _dm12 = '0'  then do;
      _1_0 = 1;
   end;
   else if _dm12 = '1'  then do;
      _1_0 = -1;
   end;
   else do;
      _1_0 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for REP_change_flag ;
drop _4_0 _4_1 ;
if missing( REP_change_flag ) then do;
   _4_0 = .;
   _4_1 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( REP_change_flag , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'P'  then do;
      _4_0 = -1;
      _4_1 = -1;
   end;
   else if _dm3 = 'O'  then do;
      _4_0 = 0;
      _4_1 = 1;
   end;
   else if _dm3 = 'N'  then do;
      _4_0 = 1;
      _4_1 = 0;
   end;
   else do;
      _4_0 = .;
      _4_1 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for stock_code ;
drop _5_0 _5_1 _5_2 _5_3 _5_4 _5_5 ;
*** encoding is sparse, initialize to zero;
_5_0 = 0;
_5_1 = 0;
_5_2 = 0;
_5_3 = 0;
_5_4 = 0;
_5_5 = 0;
if missing( stock_code ) then do;
   _5_0 = .;
   _5_1 = .;
   _5_2 = .;
   _5_3 = .;
   _5_4 = .;
   _5_5 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( stock_code , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '7154'  then do;
      if _dm12 <= '5165'  then do;
         if _dm12 = '2984'  then do;
            _5_0 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '5165'  then do;
               _5_1 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '5285'  then do;
            _5_2 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '7154'  then do;
               _5_3 = 1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   else do;
      if _dm12 <= '8125'  then do;
         if _dm12 = '7216'  then do;
            _5_4 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '8125'  then do;
               _5_5 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '9091'  then do;
            _5_0 = -1;
            _5_1 = -1;
            _5_2 = -1;
            _5_3 = -1;
            _5_4 = -1;
            _5_5 = -1;
            _dm_find = 1;
         end;
      end;
   end;
   if not _dm_find then do;
      _5_0 = .;
      _5_1 = .;
      _5_2 = .;
      _5_3 = .;
      _5_4 = .;
      _5_5 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** If missing inputs, use averages;
if _DM_BAD > 0 then do;
   _P0 = 0.5037037037;
   _P1 = 0.3185185185;
   _P2 = 0.1777777778;
   goto REGDR1;
end;

*** Compute Linear Predictor;
drop _TEMP;
drop _LP0  _LP1;
_LP0 = 0;
_LP1 = 0;

***  Effect: IMP_LOG_REP_high ;
_TEMP = IMP_LOG_REP_high ;
_LP0 = _LP0 + (   -1154.78593902717 * _TEMP);
_LP1 = _LP1 + (   -1425.48834615539 * _TEMP);

***  Effect: IMP_LOG_REP_low ;
_TEMP = IMP_LOG_REP_low ;
_LP0 = _LP0 + (   -504.165846625947 * _TEMP);
_LP1 = _LP1 + (   -209.892616589461 * _TEMP);

***  Effect: IMP_LOG_REP_open ;
_TEMP = IMP_LOG_REP_open ;
_LP0 = _LP0 + (    3983.07614416348 * _TEMP);
_LP1 = _LP1 + (    1752.03777595384 * _TEMP);

***  Effect: LOG_REP_close ;
_TEMP = LOG_REP_close ;
_LP0 = _LP0 + (    5146.60354943205 * _TEMP);
_LP1 = _LP1 + (    4035.49931208248 * _TEMP);

***  Effect: M_LOG_REP_high ;
_TEMP = 1;
_LP0 = _LP0 + (    889.352298987242) * _TEMP * _1_0;
_LP1 = _LP1 + (    77.9053701790307) * _TEMP * _1_0;

***  Effect: REP_change_flag ;
_TEMP = 1;
_LP0 = _LP0 + (    26.5637368996399) * _TEMP * _4_0;
_LP1 = _LP1 + (    23.0783225811862) * _TEMP * _4_0;
_LP0 = _LP0 + (    18.7851205175503) * _TEMP * _4_1;
_LP1 = _LP1 + (    16.2145735021435) * _TEMP * _4_1;

***  Effect: stock_code ;
_TEMP = 1;
_LP0 = _LP0 + (     228.40258715934) * _TEMP * _5_0;
_LP1 = _LP1 + (     101.41561001948) * _TEMP * _5_0;
_LP0 = _LP0 + (    2790.81685492602) * _TEMP * _5_1;
_LP1 = _LP1 + (    1602.42909283539) * _TEMP * _5_1;
_LP0 = _LP0 + (   -7270.44513961466) * _TEMP * _5_2;
_LP1 = _LP1 + (   -4033.48187574489) * _TEMP * _5_2;
_LP0 = _LP0 + (    1203.67437768668) * _TEMP * _5_3;
_LP1 = _LP1 + (     714.53283247805) * _TEMP * _5_3;
_LP0 = _LP0 + (   -1122.39850205709) * _TEMP * _5_4;
_LP1 = _LP1 + (   -661.991788511577) * _TEMP * _5_4;
_LP0 = _LP0 + (   -876.025382940433) * _TEMP * _5_5;
_LP1 = _LP1 + (   -518.268620458807) * _TEMP * _5_5;

***  Effect: vol ;
_TEMP = vol ;
_LP0 = _LP0 + (   -0.00049986128644 * _TEMP);
_LP1 = _LP1 + (    -0.0005939274058 * _TEMP);

*** Naive Posterior Probabilities;
drop _MAXP _IY _P0 _P1 _P2;
drop _LPMAX;
_LPMAX= 0;
_LP0 =    -7049.37270572863 + _LP0;
if _LPMAX < _LP0 then _LPMAX = _LP0;
_LP1 =    -3469.39286900465 + _LP1;
if _LPMAX < _LP1 then _LPMAX = _LP1;
_LP0 = exp(_LP0 - _LPMAX);
_LP1 = exp(_LP1 - _LPMAX);
_LPMAX = exp(-_LPMAX);
_P2 = 1 / (_LPMAX + _LP0 + _LP1);
_P0 = _LP0 * _P2;
_P1 = _LP1 * _P2;
_P2 = _LPMAX * _P2;

REGDR1:


*** Posterior Probabilities and Predicted Level;
label P_REP_trade_flagS = 'Predicted: REP_trade_flag=S' ;
label P_REP_trade_flagH = 'Predicted: REP_trade_flag=H' ;
label P_REP_trade_flagB = 'Predicted: REP_trade_flag=B' ;
P_REP_trade_flagS = _P0;
_MAXP = _P0;
_IY = 1;
P_REP_trade_flagH = _P1;
if (_P1 >  _MAXP + 1E-8) then do;
   _MAXP = _P1;
   _IY = 2;
end;
P_REP_trade_flagB = _P2;
if (_P2 >  _MAXP + 1E-8) then do;
   _MAXP = _P2;
   _IY = 3;
end;
I_REP_trade_flag = REGDRF[_IY];
U_REP_trade_flag = REGDRU[_IY];

*************************************;
***** end scoring code for regression;
*************************************;
