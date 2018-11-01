--balance
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                       
                       
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

          
    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(total_bal) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where total_bal between decode(Trec.scdcriteria_snumber,1,-99999999,Trec.scdcriteria_snumber) and Trec.scdcriteria_enumber
               and total_bal <> 0
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;

        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsbalance_msl = v_cnt_msl, spsbalance_pnt = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--adjust
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                       
                       
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

          
    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(total_adjust) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where total_bal between Trec.scdcriteria_snumber and Trec.scdcriteria_enumber
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;


        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsadjust_msl = v_cnt_msl, spsadjust_pnt = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--remove
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                                            
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(total_remove) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where total_remove between Trec.scdcriteria_snumber and Trec.scdcriteria_enumber
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;

        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsremove_msl = v_cnt_msl, spsremove_pnt = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--use ¼Ô´
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                                            
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(total_use) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where total_use between Trec.scdcriteria_snumber and Trec.scdcriteria_enumber
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;

        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsusage_msl = v_cnt_msl, spsusage_pnt = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--add1
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                                            
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(bn1_add) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where bn1_add between decode(Trec.scdcriteria_snumber,1,-99999999,Trec.scdcriteria_snumber) and Trec.scdcriteria_enumber
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;

        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsaddact_mslmis = v_cnt_msl, spsaddact_pntmis = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--add2
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                                            
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(bn2_add) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where bn2_add between decode(Trec.scdcriteria_snumber,1,-99999999,Trec.scdcriteria_snumber) and Trec.scdcriteria_enumber
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;

        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsaddact_mslfri = v_cnt_msl, spsaddact_pntfri = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--add3
declare 
    cursor rec is
        select * 
          from sa_criteria_lvl_dtl scd
         where scd.scdou_code           =  '000'
           and scd.scdprogref_id        =  'BWOMRP73'
           and scd.scdcode              =  '73/101/15';
                                            
    cursor rec2(snumber number, enumber number) is
        select spsseqlevel 
          from sa_point_mntly_ys a, zp_tmp_lvl b
         where spsou_code = '000' 
           and spsprogref = 'BWOMRP73' 
           and spscode = '73/101/15' 
           and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
           and a.spsseqlevel = b.brdreward_level
           and b.snum = snumber
           and b.enum = enumber;

    v_at_month  varchar2(20);
    v_cnt_msl   number;
    v_total     number;
begin
    for Trec in rec loop
        begin
            select At_Month, count(distinct rep_seq) cnt_msl, sum(bn3_add) total_bal
              into v_at_month, v_cnt_msl, v_total
              from ZP_SUM_POINT_MONTH01 a
             where bn3_add between decode(Trec.scdcriteria_snumber,1,-99999999,Trec.scdcriteria_snumber) and Trec.scdcriteria_enumber
             group by At_Month
            ;
            exception when no_data_found then begin v_at_month := 0; v_cnt_msl := 0; v_total := 0; end;
        end;

        for Trec2 in rec2(Trec.scdcriteria_snumber,Trec.scdcriteria_enumber) loop
            begin
                update sa_point_mntly_ys set spsaddact_mslfar = v_cnt_msl, spsaddact_pntfar = v_total
                 where spsou_code = '000' 
                   and spsprogref = 'BWOMRP73' 
                   and spscode = '73/101/15' 
                   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
                   and spsseqlevel = Trec2.spsseqlevel;
            end;
        end loop;
    end loop;    
end;

--totaladd , other , expire
update sa_point_mntly_ys 
   set spsaddact_pntoth = 0, spsexpired_pnt = 0
     , spsaddact_pntttl = spsaddact_pntmis + spsaddact_pntfri + spsaddact_pntfar
     , spsaddact_mslttl = spsaddact_mslmis + spsaddact_mslfri + spsaddact_mslfar
 where spsou_code = '000' 
   and spsprogref = 'BWOMRP73' 
   and spscode = '73/101/15' 
   and spslastdate = to_date('31/01/2015','dd/mm/rrrr')


declare
    cursor rec is
        select lvl, count(distinct rwdtrans_no) cnt, sum(rwdttl_unit), sum(rwdredeem_point) pnt 
        from (
            select a.rwdtrans_no
                 , a.rwdbill_code
                 , a.rwdredeem_point
                 , a.rwdttl_unit
                 , (a.rwdredeem_point/a.rwdttl_unit) pnt_bill
                 , a.rwdredeem_money
                 , nvl((select rwd_level from zp_tmp_lvl t where (a.rwdredeem_point/a.rwdttl_unit) between snum and enum and redeem_money = (a.rwdredeem_money/a.rwdttl_unit)),90) lvl
                 , stf_get_pnt_level('000', '101/15', (a.rwdredeem_point/a.rwdttl_unit), (a.rwdredeem_money/a.rwdttl_unit)) lvl2
            from ZOM_TRANSACTION_RWD a  
        --where nvl((select rwd_level from zp_tmp_lvl t where (a.rwdredeem_point/a.rwdttl_unit) between snum and enum and redeem_money = (a.rwdredeem_money/a.rwdttl_unit)),90) = 90
        )
        group by lvl
        order by lvl;
begin
    for Trec in rec loop
        begin
            update sa_point_mntly_ys set spsusage_msl = Trec.cnt, spsusage_pnt = Trec.pnt
          --select * from sa_point_mntly_ys 
             where spsou_code   = '000' 
               and spsprogref   = 'BWOMRP73' 
               and spscode      = '73/101/15' 
               and spslastdate  = to_date('31/01/2015','dd/mm/rrrr')
               and spsvolumn_no = '101/15'
               and spsseqlevel  = Trec.lvl
               ;
        end;
    end loop;
end;

declare
    cursor rec is
        select lvl2, count(distinct rwdtrans_no) cnt, sum(rwdttl_unit), sum(rwdredeem_point) pnt 
        from (
            select a.rwdtrans_no
                 , a.rwdbill_code
                 , a.rwdredeem_point
                 , a.rwdttl_unit
                 , (a.rwdredeem_point/a.rwdttl_unit) pnt_bill
                 , a.rwdredeem_money
                 , nvl((select rwd_level from zp_tmp_lvl t where (a.rwdredeem_point/a.rwdttl_unit) between snum and enum and redeem_money = (a.rwdredeem_money/a.rwdttl_unit)),90) lvl
                 , TO_NUMBER(stf_get_pnt_level('000', '101/15', (a.rwdredeem_point/a.rwdttl_unit), (a.rwdredeem_money/a.rwdttl_unit))) lvl2
            from ZOM_TRANSACTION_RWD a  
           where nvl((select rwd_level from zp_tmp_lvl t where (a.rwdredeem_point/a.rwdttl_unit) between snum and enum and redeem_money = (a.rwdredeem_money/a.rwdttl_unit)),90) = 90
        )
        group by lvl2
        order by lvl2;
begin
    for Trec in rec loop
        begin
            update sa_point_mntly_ys set spsusage_msl = Trec.cnt, spsusage_pnt = Trec.pnt
          --select * from sa_point_mntly_ys 
             where spsou_code   = '000' 
               and spsprogref   = 'BWOMRP73' 
               and spscode      = '73/101/15' 
               and spslastdate  = to_date('31/01/2015','dd/mm/rrrr')
               and spsvolumn_no = '103/14'
               and spsseqlevel  = Trec.lvl2
               ;
        end;
    end loop;
end;



insert into zom_transaction_pnt 
select * 
from om_transaction_pnt pnt
where optou_code = '000'
and optpoint_prog_type = 'B'
and optpnt_type = 'R'
AND TRUNC("OPTTRANS_DATE") > TO_DATE('31/12/2014','DD/MM/RRRR')
AND TRUNC("OPTTRANS_DATE") < TO_DATE('01/02/2015','DD/MM/RRRR')

create table ZOM_TRANSACTION_RWD as
SELECT * --sum(rwdredeem_point)
from OM_TRANSACTION_RWD RWD
WHERE  rwd.rwdcre_date > to_date('31/12/2014','dd/mm/rrrr') 
  and  rwd.rwdcre_date < to_date('01/02/2015','dd/mm/rrrr')
  and  exists (select 1 from zom_transaction_pnt pnt where RWD.RWDOU_CODE       = PNT.OPTOU_CODE
            AND    RWD.RWDYEAR          = PNT.OPTREFER_TRANS_YEAR
            AND    RWD.RWDTRANS_GROUP   = PNT.OPTREFER_TRANS_GROUP
            AND    RWD.RWDTRANS_NO      = PNT.OPTREFER_TRANS_NO
            AND    RWD.RWDBILL_CAMPAIGN = PNT.OPTREFER_BILL_CAMPAIGN
            AND    RWD.RWDBILL_CODE     = PNT.OPTREFER_BILL_CODE and exists (select dstloc_code from db_sales_location d 
                            where dstou_code = '000' and nvl(dstspecial_status,'0') = '0' and dstloc_code = pnt.optloc_code) )

AND    RWD.RWDOU_CODE       = PNT.OPTOU_CODE
AND    RWD.RWDYEAR          = PNT.OPTREFER_TRANS_YEAR
AND    RWD.RWDTRANS_GROUP   = PNT.OPTREFER_TRANS_GROUP
AND    RWD.RWDTRANS_NO      = PNT.OPTREFER_TRANS_NO


select * from ZP_SUM_POINT_MONTH01

select sum(bf), sum(total_add), sum(total_use), sum(total_remove), sum(total_adjust), sum(total_expire), sum(total_bal) from ZP_SUM_POINT_MONTH01

select spsvolumn_no, spsseqlevel, spsusage_pnt, spsusage_msl from sa_point_mntly_ys               where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/101/15' and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
order by spsvolumn_no desc, spsseqlevel

