declare
  Parm_OuCode  VARCHAR2(3);
  Parm_ShipDate  DATE;
  Parm_UserID  VARCHAR2(10);
  Pram_PROG_ID  VARCHAR2(10);
  vTmp VARCHAR2(10);
    cursor Rec_r is
        select OU_CODE
             , aa.main_dc DC_CODE
             , pkgbw_dms.get_current_working_date(OU_CODE) WORKING_DATE
             , '00' TRACKING_STATUS
             , TRUCK_NO
             , pallet_no CONTAINER_NO
             , FRAGILE_NO
             , 'PERAPONG' USER_ID
             , SYSDATE CRE_DATE
             , 'BEDMOP01' PROG_ID
             , (select ohdord_type from om_transaction_hdr where ohdou_code = '000' and ohdtrans_no = '1103279464') SCANTYPE
             , 0 OUTSRC_FLAG
             , 1 ERRM
             , INVOICE_NO
             , null PACKAGE_TYPE
             , intransit
             , basket_no
             , shipdate
        from (SELECT SSSOU_CODE OU_CODE
                     , pkgbw_dms.get_current_working_date(SSSOU_CODE) WORKING_DATE
                     , sssfragile_no FRAGILE_NO
                     , ssstrans_no INVOICE_NO
                     , substr(sssrep_code,1,4) loc_code
                     , (select t.dstmain_dc from db_sales_location t where t.dstou_code = a.sssou_code and t.dstloc_code = substr(sssrep_code,1,4)) MAIN_DC
                     , a.sssship_date shipdate
             FROM sh_ship_scan a
                WHERE a.sssou_code = '000'
                  and a.sssship_date between trunc(to_date('28/12/2012','dd/mm/rrrr')) and trunc(to_date('28/12/2012','dd/mm/rrrr'))+0.99999
                  and a.ssstrans_no = '1103223562'
                  --and not exists (select * from dm_fragile_tracking t where a.sssou_code = t.ftrou_code and a.sssfragile_no = t.ftrfragile_no)
                  ) aa,
             (SELECT parm_key, seq_no, prog_id,  vartxt1 MAIN_DC , vartxt2  PALLET_NO , vartxt3 TRUCK_NO,
                       vartxt4 INTRANSIT , vartxt5 BASKET_NO
                FROM bw_def$sys
                WHERE  parm_key  ='DM_REGAUTO'
                --and  vartxt1 = Parm_DcCode
             ) bb
        where aa.MAIN_DC = bb.MAIN_DC
          and rownum < 11
          and aa.MAIN_DC not in ('BK','CN')
          and aa.shipdate = trunc(sysdate)
        ;

     cursor Rec_i is
        select ftrou_code OU_CODE
             , ftrdc_code DC_CODE
             , ftrtracking_date WORKING_DATE
             , '01' TRACKING_STATUS
             , ftrasn_truck_no TRUCK_NO
             , ftrcontainer_no CONTAINER_NO
             , ftrfragile_no FRAGILE_NO
            -- , Parm_UserID USER_ID
             , SYSDATE CRE_DATE
            -- , Pram_PROG_ID PROG_ID
             , 0 SCANTYPE
             , 0 OUTSRC_FLAG
             , 1 ERRM
             , ftrinv_trans_no INVOICE_NO
             , null PACKAGE_TYPE
        from dm_fragile_tracking a, sh_ship_scan b
        where a.ftrou_code = '000'
          and a.ftrtracking_status = '00'
          and a.ftrdc_code not in ('BK','CN')
          and not exists (select 1 from dm_fragile_tracking t
                          where t.ftrou_code = a.ftrou_code
                            and t.ftrfragile_no =  a.ftrfragile_no
                            and t.ftrtracking_status = '01')
          and a.ftrou_code = b.sssou_code
          and a.ftrfragile_no =  b.sssfragile_no
          and b.ssstrans_no = '1103223562'
          and b.sssship_date between trunc(to_date('28/12/2012','dd/mm/rrrr')) and trunc(to_date('28/12/2012','dd/mm/rrrr'))+0.99999
          and rownum < 11
        ;
 Begin
  Parm_OuCode   := '000';
  Parm_ShipDate := to_date('28/12/2012','dd/mm/rrrr');
  Parm_UserID   := 'PERAPONG';
  Pram_PROG_ID  := 'BEDMPC01';
    For Trec In Rec_r Loop
        Begin
            insert into zp_tmp_dmfragile (ou_code, dc_code
            , working_date, tracking_status
            , truck_no,container_no
            , fragile_no, user_id
            , cre_date, prog_id
            , scantype,outsrc_flag
       , errm, invoice_no
       , package_type, intransit
       ,basket_no, shipdate
       ) values (Trec.OU_CODE,Trec.DC_CODE
                                                ,Trec.WORKING_DATE,Trec.TRACKING_STATUS
                                                ,Trec.TRUCK_NO,Trec.CONTAINER_NO
                                                ,Trec.FRAGILE_NO,Trec.USER_ID
                                                ,Trec.CRE_DATE,Trec.PROG_ID
                                                ,Trec.SCANTYPE,Trec.OUTSRC_FLAG
                                                ,Trec.ERRM,Trec.INVOICE_NO
                                                ,Trec.PACKAGE_TYPE,Trec.INTRANSIT
                                                ,Trec.BASKET_NO,Trec.SHIPDATE
                                                );

            if Trec.INTRANSIT = 'TRUE' and Trec.SHIPDATE = trunc(sysdate) then
                Trec.TRACKING_STATUS := '01';
                Trec.SCANTYPE := 1;
/*                begin
                    insert into zp_tmp_dmfragile values (Trec.OU_CODE,Trec.DC_CODE
                                                        ,Trec.WORKING_DATE,Trec.TRACKING_STATUS
                                                        ,Trec.TRUCK_NO,Trec.CONTAINER_NO
                                                        ,Trec.FRAGILE_NO,Trec.USER_ID
                                                        ,Trec.CRE_DATE,Trec.PROG_ID
                                                        ,Trec.SCANTYPE,Trec.OUTSRC_FLAG
                                                        ,Trec.ERRM,Trec.INVOICE_NO
                                                        ,Trec.PACKAGE_TYPE,Trec.SHIPDATE
                                                        ,Trec.INTRANSIT,Trec.BASKET_NO);
                end;*/
            end if;
/*
        vTmp := ins_fragile_tracking(Trec.OU_CODE
                                               , Trec.DC_CODE
                                               , Trec.WORKING_DATE
                                               , Trec.TRACKING_STATUS
                                               , Trec.TRUCK_NO
                                               , Trec.CONTAINER_NO
                                               , Trec.FRAGILE_NO
                                               , Trec.USER_ID
                                               , Trec.CRE_DATE
                                               , Trec.PROG_ID
                                               , Trec.SCANTYPE
                                               , Trec.OUTSRC_FLAG

                                               , Trec.ERRM
                                               , Trec.INVOICE_NO
                                               , Trec.PACKAGE_TYPE);


--            vTmp := pkgbw_iaverify.gen_errdupname( Trec.reg_no , Trec.err_code);
--            Exception  when Others Then Begin   dbms_output.put_line('error '||Trec.reg_no||' '||Trec.first_name||' '||Trec.last_name);  End;
*/
        End;
    End Loop;
/*
    For Trec In Rec_i Loop
        Begin
            insert into zp_tmp_dmfragile values (Trec.OU_CODE,Trec.DC_CODE
                                                 ,Trec.WORKING_DATE,Trec.TRACKING_STATUS
                                                 ,Trec.TRUCK_NO,Trec.CONTAINER_NO
                                                 ,Trec.FRAGILE_NO,Trec.USER_ID
                                                 ,Trec.CRE_DATE,Trec.PROG_ID
                                                 ,Trec.SCANTYPE,Trec.OUTSRC_FLAG
                                                 ,Trec.ERRM,Trec.INVOICE_NO
                                                 ,Trec.PACKAGE_TYPE,null,null,null);

        vTmp := ins_fragile_tracking(Trec.OU_CODE
                                               , Trec.DC_CODE
                                               , Trec.WORKING_DATE
                                               , Trec.TRACKING_STATUS
                                               , Trec.TRUCK_NO
                                               , Trec.CONTAINER_NO
                                               , Trec.FRAGILE_NO
                                               , Trec.USER_ID
                                               , Trec.CRE_DATE
                                               , Trec.PROG_ID
                                               , Trec.SCANTYPE
                                               , Trec.OUTSRC_FLAG
                                               , Trec.ERRM
                                               , Trec.INVOICE_NO
                                               , Trec.PACKAGE_TYPE);

        End;
    End Loop;*/
END;
/*
create table zp_tmp_dmfragile as
select sysdate atdate, 'asfsdasdfg' log_step, 'als;kdjfa;lsfjlasfdjlaskfdja;slfkjlasfdj;asdf' log_desc from dual
drop table zp_tmp_dmfragile
select * from ms_representative rr where rr.reprep_code = '8367002598' --in ('0247106585','0245098027','0272026867')
*/

/*
select *
from sh_ship_scan a where a.sssou_code = '000' and a.sssship_date = to_date('25/12/2012','dd/mm/rrrr')
and not exists (select * from dm_fragile_tracking t where ftrfragile_no = 11025127622 a.sssou_code = t.ftrou_code and a.ssstrans_no = t.ftrfragile_no)



select * from om_transaction_hdr where ohdtrans_no = '1103210577'

select * from db_sales_location where dstloc_code = '0433'

*/

DECLARE
  vTmp VARCHAR2(10);
begin
    delete from zp_tmp_dmfragile; 
    vTmp := pkgbw_dms.DM_FragileTracking_Reg('000', to_date('27/12/2012','dd/mm/rrrr'), 'PERAPONG', 'BEDMPC01', null, 'KK');
    vTmp := pkgbw_dms.DM_FragileTracking_Int('000', to_date('28/12/2012','dd/mm/rrrr'), 'PERAPONG', 'BEDMPC01', null, 'KK');
end;
