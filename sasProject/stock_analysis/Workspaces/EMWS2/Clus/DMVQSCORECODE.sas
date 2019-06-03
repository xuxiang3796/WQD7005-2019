*****************************************;
*** Begin Scoring Code from PROC DMVQ ***;
*****************************************;


*** Begin Class Look-up, Standardization, Replacement ;
drop _dm_bad; _dm_bad = 0;

*** Standardize close ;
drop T_close ;
if missing( close ) then T_close = .;
else T_close = (close - 1.18614430543572) * 0.45477458898789;

*** Standardize high ;
drop T_high ;
if missing( high ) then T_high = .;
else T_high = (high - 1.01485529910842) * 0.4713074253985;

*** Standardize low ;
drop T_low ;
if missing( low ) then T_low = .;
else T_low = (low - 0.99566454558526) * 0.47721190177033;

*** Standardize open ;
drop T_open ;
if missing( open ) then T_open = .;
else T_open = (open - 1.00462341817658) * 0.47426384617554;

*** Standardize vol ;
drop T_vol ;
if missing( vol ) then T_vol = .;
else T_vol = (vol - 11296.0844477998) * 0.00002968878964;

*** End Class Look-up, Standardization, Replacement ;


*** Omitted Cases;
if _dm_bad then do;
   _SEGMENT_ = .; Distance = .;
   goto CLUSvlex ;
end; *** omitted;

*** Compute Distances and Cluster Membership;
label _SEGMENT_ = 'Segment Id' ;
label Distance = 'Distance' ;
array CLUSvads [3] _temporary_;
drop _vqclus _vqmvar _vqnvar;
_vqmvar = 0;
do _vqclus = 1 to 3; CLUSvads [_vqclus] = 0; end;
if not missing( T_close ) then do;
   CLUSvads [1] + ( T_close - -0.15401139576988 )**2;
   CLUSvads [2] + ( T_close - 3.65509605093182 )**2;
   CLUSvads [3] + ( T_close - -0.23110013424763 )**2;
end;
else _vqmvar + 1;
if not missing( T_high ) then do;
   CLUSvads [1] + ( T_high - -0.16729175997923 )**2;
   CLUSvads [2] + ( T_high - 3.89955059115321 )**2;
   CLUSvads [3] + ( T_high - -0.15103342919735 )**2;
end;
else _vqmvar + 1;
if not missing( T_low ) then do;
   CLUSvads [1] + ( T_low - -0.16701116838784 )**2;
   CLUSvads [2] + ( T_low - 3.89883660924411 )**2;
   CLUSvads [3] + ( T_low - -0.1590181750819 )**2;
end;
else _vqmvar + 1;
if not missing( T_open ) then do;
   CLUSvads [1] + ( T_open - -0.16707631775225 )**2;
   CLUSvads [2] + ( T_open - 3.89814317510937 )**2;
   CLUSvads [3] + ( T_open - -0.15594941162953 )**2;
end;
else _vqmvar + 1;
if not missing( T_vol ) then do;
   CLUSvads [1] + ( T_vol - -0.15168276182761 )**2;
   CLUSvads [2] + ( T_vol - 0.01319328817385 )**2;
   CLUSvads [3] + ( T_vol - 4.84346485892184 )**2;
end;
else _vqmvar + 1;
_vqnvar = 5 - _vqmvar;
if _vqnvar <= 2.8421709430404E-12 then do;
   _SEGMENT_ = .; Distance = .;
end;
else do;
   _SEGMENT_ = 1; Distance = CLUSvads [1];
   _vqfzdst = Distance * 0.99999999999988; drop _vqfzdst;
   do _vqclus = 2 to 3;
      if CLUSvads [_vqclus] < _vqfzdst then do;
         _SEGMENT_ = _vqclus; Distance = CLUSvads [_vqclus];
         _vqfzdst = Distance * 0.99999999999988;
      end;
   end;
   Distance = sqrt(Distance * (5 / _vqnvar));
end;
CLUSvlex :;

***************************************;
*** End Scoring Code from PROC DMVQ ***;
***************************************;
