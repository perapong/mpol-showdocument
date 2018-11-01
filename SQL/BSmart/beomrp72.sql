select t.*,case when u.brdredeem_point is null or (t.l_from=u.brdredeem_point and t.l_money=u.redeem_money) then 1 else 0 end show_flag
from
(
  SELECT scl.sclou_code ou_code,
  --       nvl(brd.brdreward_level,0) seq_level,
         rownum-1 seq_level,
         lpad(to_char(rownum-1),2,'0') level_disp,
         nvl(scd.scdcriteria_snumber,0) l_from,
         floor(nvl(scd.scdcriteria_enumber,999999999)) l_to,
         nvl(brd.brdredeem_money,0) l_money
  from sa_criteria_lvl_hdr scl, sa_criteria_lvl_dtl scd, db_bpr_reward_dtl brd
  WHERE scl.sclou_code = '000'
     AND scl.sclprogref_id = 'BWOMRP73'
     AND scl.sclcode = '73/103/13' --:p_template
     AND scl.sclou_code = scd.scdou_code
     AND scl.sclprogref_id = scd.scdprogref_id
     AND NVL (scl.sclinactive_status, '0') = '0'
     and scl.sclcode = scd.scdcode
     and scl.sclattribute1 = '103/13' --:p_volumn_no
     and :p_volumn_no= brd.brdvolumn_no(+)
     and scd.scdou_code = brd.brdou_code(+)
     and scd.scdcriteria_snumber = brd.brdredeem_point(+)
     and nvl (scd.scdseq, 1) between 1 and 999 /* for use index */
  order by scl.sclou_code, level_disp
) t
left outer join 
(
  select x.brdou_code,x.brdvolumn_no,x.brdredeem_point,min(x.brdredeem_money) redeem_money
  from db_bpr_reward_dtl x
  inner join 
  (
    select a.brdou_code,a.brdvolumn_no,a.brdredeem_point,count(*) number_lvl
    from db_bpr_reward_dtl a
    where a.brdvolumn_no='103/13' --:p_volumn_no
    group by a.brdou_code,a.brdvolumn_no,a.brdredeem_point
    having count(*)>1
    order by a.brdou_code,a.brdvolumn_no,a.brdredeem_point
  ) y on
    x.brdvolumn_no=y.brdvolumn_no
    and x.brdredeem_point=y.brdredeem_point  
  group by x.brdou_code,x.brdvolumn_no,x.brdredeem_point
  having min(x.brdredeem_money)=0
) u on
   t.ou_code=u.brdou_code
   and t.l_from=u.brdredeem_point
--   and t.l_money=u.redeem_money
order by t.ou_code,t.seq_level

/****************************************************************************************************************************************************/

--:show_flag = 1
--:p_month = 122013
SELECT sps.spsou_code ou_code,
            nvl(sps.spsseqlevel,0) scdseq,
            nvl(sps.spsredeem_money,0) redeem_money_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsaddact_pntmis) end) mistine_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsaddact_pntfri) end) friday_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(REPLACE (:p_month, '/', ''), sps.spsofmonth, sps.spsaddact_pntfar) end) faris_row1,
            sum(decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsusage_pnt))       usage_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsremove_pnt) end) remove_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsadjust_pnt) end) adjust_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsexpired_pnt) end) expire_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsaddact_pntttl) end) total_add_row1,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, sps.spsbalance_pnt) end) balance_row1,          
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.mistineYTD_row1 end mistineYTD_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.fridayYTD_row1 end fridayYTD_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.farisYTD_row1 end farisYTD_row1,
            spy.usageytd_row1 usageytd_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.removeytd_row1 end removeytd_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.adjustytd_row1 end adjustytd_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.expireytd_row1 end expireytd_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.totalytd_add_row1 end totalytd_add_row1,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.balanceytd_row1 end balanceytd_row1
FROM sa_point_mntly_ys sps,
                ( SELECT spsofmonth, MAX (spslastdate) spslastdate
                     FROM sa_point_mntly_ys
                   WHERE spsou_code = '000'
                     AND spsprogref = 'BWOMRP73'
                     AND spscode = '73/103/13' --:p_template
                     AND substr(spsofmonth, 3,4)||substr(spsofmonth, 1, 2) <= SUBSTR(REPLACE ('262013', '/', ''),3,4)||SUBSTR(REPLACE ('262013', '/', ''),1,2)
                     AND substr(spsofmonth, 3,4) = SUBSTR(REPLACE ('262013', '/', ''),3,4)
                     GROUP BY spsofmonth) pacc,
                  (
                     SELECT spy.spsou_code, 
                              nvl(spy.spsseqlevel,0) spsseqlevel,
                              nvl(spy.spsredeem_money,0) spsredeem_money, 
                              sum(spy.spsaddact_pntmis) mistineYTD_row1,
                              sum(spy.spsaddact_pntfri)   fridayYTD_row1,
                              sum(spy.spsaddact_pntfar)  farisYTD_row1,
                              sum(spy.spsusage_pnt)       usageYTD_row1,
                              sum(spy.spsremove_pnt)     removeYTD_row1,
                              sum(spy.spsadjust_pnt)       adjustYTD_row1,
                              sum(spy.spsexpired_pnt)     expireYTD_row1,
                              sum(spy.spsaddact_pntttl)   totalYTD_add_row1,
                              sum(spy.spsbalance_pnt)    balanceYTD_row1
                      FROM sa_point_yearly_ys spy,  ( 
                                                                select spsofyear, max (spslastdate) spslastdate
                                                                from sa_point_yearly_ys
                                                               where spsou_code = '000'
                                                                 and spsprogref     = 'BWOMRP73'
                                                                 and spscode        = '73/103/13' --:p_template
                                                                 and spsofyear      = substr(replace (:p_month, '/', ''),3,4)                                     
                                                                 group by spsofyear
                                                                ) pytd
                     WHERE spy.spsou_code = '000'
                       AND spy.spsprogref = 'BWOMRP73'
                       AND spy.spscode = '73/103/13' --:p_template
                       AND spy.spsofyear  = pytd.spsofyear
                       and spy.spslastdate =  pytd.spslastdate
                       AND spy.spsseqlevel = :seq_level    
                    GROUP BY spy.spsou_code, 
                                 spy.spsseqlevel,
                                 spy.spsredeem_money                 
                  ) spy
WHERE sps.spsou_code = '000'
   AND sps.spsprogref = 'BWOMRP73'
   AND sps.spscode = '73/103/13' --:p_template
   AND substr(sps.spsofmonth, 3,4) = SUBSTR(REPLACE (:p_month, '/', ''),3,4)
   and substr(sps.spsofmonth, 3,4)||substr(sps.spsofmonth, 1, 2) = substr(replace (:p_month, '/', ''),3,4)||substr(replace (:p_month, '/', ''),1,2)
 --AND sps.spsseqlevel = :seq_level
 --AND INSTR (NVL (:p_select_dist, '@' || sps.spsdstgroup || '@'), '@' || sps.spsdstgroup || '@') > 0
   AND sps.spsofmonth = pacc.spsofmonth
   AND sps.spslastdate =  pacc.spslastdate
   AND spy.spsou_code = sps.spsou_code
   AND spy.spsseqlevel = sps.spsseqlevel
GROUP BY sps.spsou_code, sps.spsseqlevel, sps.spsredeem_money,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.mistineytd_row1 end,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.fridayytd_row1 end,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.farisYTD_row1 end,
                spy.usageytd_row1,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.removeytd_row1 end,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.adjustytd_row1 end,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.expireytd_row1 end,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.totalytd_add_row1 end,
                case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.balanceytd_row1 end
ORDER BY ou_code, scdseq, redeem_money_row1     

/****************************************************************************************************************************************************/

SELECT sps.spsou_code ou_code,
            nvl(sps.spsseqlevel,0) scdseq,
            nvl(sps.spsredeem_money,0) redeem_money_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsaddact_mslmis) end) mistine_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsaddact_mslfri) end) friday_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(REPLACE (:p_month, '/', ''), sps.spsofmonth, spsaddact_mslfar) end) faris_row2,
            sum(decode(replace (:p_month, '/', ''), sps.spsofmonth, spsusage_msl))      usage_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsremove_msl) end) remove_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsadjust_msl) end) adjust_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsexpired_msl) end) expire_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsaddact_mslttl) end) total_add_row2,
            sum(case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then decode(replace (:p_month, '/', ''), sps.spsofmonth, spsbalance_msl) end) balance_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.mistineytd_row2 end mistineytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.fridayytd_row2 end fridayytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.farisytd_row2 end farisytd_row2,
            spy.usageytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.removeytd_row2 end removeytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.adjustytd_row2 end adjustytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.expireytd_row2 end expireytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.totalytd_add_row2 end totalytd_add_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.balanceytd_row2 end balanceytd_row2
  FROM sa_point_mntly_ys sps,
             ( SELECT spsofmonth, MAX (spslastdate) spslastdate
                     FROM sa_point_mntly_ys
                   WHERE spsou_code = '000'
                     AND spsprogref = 'BWOMRP73'
                     AND spscode = :p_template
                     AND substr(spsofmonth, 3,4)||substr(spsofmonth, 1, 2) <= SUBSTR(REPLACE (:p_month, '/', ''),3,4)||SUBSTR(REPLACE (:p_month, '/', ''),1,2)
                     AND substr(spsofmonth, 3,4) = SUBSTR(REPLACE (:p_month, '/', ''),3,4)
                     GROUP BY spsofmonth) pacc,
                  (
                    SELECT spy.spsou_code, 
                              spy.spsseqlevel, 
                              sum(spy.spsaddact_mslmis) mistineYTD_row2,
                              sum(spy.spsaddact_mslfri)   fridayYTD_row2,
                              sum(spy.spsaddact_mslfar)  farisYTD_row2,
                              sum(spy.spsusage_msl)       usageYTD_row2,
                              sum(spy.spsremove_msl)     removeYTD_row2,
                              sum(spy.spsadjust_msl)       adjustYTD_row2,
                              sum(spy.spsexpired_msl)     expireYTD_row2,
                              sum(spy.spsaddact_mslttl)   totalYTD_add_row2,
                              sum(spy.spsbalance_msl)    balanceYTD_row2
                      FROM sa_point_yearly_ys spy,  ( 
                                  select spsofyear, max (spslastdate) spslastdate
                                    from sa_point_yearly_ys
                                   where spsou_code = '000'
                                     and spsprogref     = 'BWOMRP73'
                                     and spscode         = :p_template
                                     and spsofyear      = substr(replace (:p_month, '/', ''),3,4)
                                     group by spsofyear                                     
                                     ) pytd
                     WHERE spy.spsou_code = '000'
                       AND spy.spsprogref        = 'BWOMRP73'
                       AND spy.spscode           = :p_template
                       AND spy.spsofyear         = pytd.spsofyear
                       AND spy.spslastdate      =  pytd.spslastdate
                       AND spy.spsseqlevel     = :seq_level                     
                 GROUP BY spy.spsou_code, 
                                spy.spsseqlevel
                  ) spy
WHERE sps.spsou_code = '000'
   AND sps.spsprogref = 'BWOMRP73'
   AND sps.spscode    = :p_template
   AND substr(sps.spsofmonth, 3,4) = SUBSTR(REPLACE (:p_month, '/', ''),3,4)
   AND substr(sps.spsofmonth, 3,4)||substr(sps.spsofmonth, 1, 2) <= SUBSTR(REPLACE (:p_month, '/', ''),3,4)||SUBSTR(REPLACE (:p_month, '/', ''),1,2)
   AND sps.spsseqlevel = :seq_level
   AND INSTR (NVL (:p_select_dist, '@' || spsdstgroup || '@'), '@' || spsdstgroup || '@') > 0
   AND sps.spsofmonth = pacc.spsofmonth
   AND sps.spslastdate =  pacc.spslastdate
GROUP BY sps.spsou_code, sps.spsseqlevel, sps.spsredeem_money,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.mistineytd_row2 end,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.fridayytd_row2 end,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.farisytd_row2 end,
            spy.usageytd_row2,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.removeytd_row2 end,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.adjustytd_row2 end,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.expireytd_row2 end,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.totalytd_add_row2 end,
            case when nvl(sps.spsredeem_money,0)<=1 and :show_flag=1 then spy.balanceytd_row2 end
            
/****************************************************************************************************************************************************/

/****************************************************************************************************************************************************/

