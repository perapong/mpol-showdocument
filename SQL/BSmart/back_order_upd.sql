declare
    cursor rec is
        select bckou_code, bckback_ord_campaign, bckrep_seq, bckback_seq, bckbill_code
             --sum( b.bckback_unit)
        from om_backorder b
        where b.bckou_code = '000'
          --and trunc(b.bckorder_date) between to_date('02/10/2012','dd/mm/rrrr') and to_date('03/10/2012','dd/mm/rrrr')
          --and b.bckbill_code = '03157'
          and b.bckback_ord_campaign = '052013'
          and b.bckbackorder_status = 0
        order by bckrep_seq
        ;
        
BEGIN

    For Trec In Rec Loop
        Begin 
            update om_backorder
               set bckbill_code = '03156'
                 , bckprog_id = 'SCRIPT'
                 , bckupd_by = 'PERAPONG'
                 , bckupd_date = sysdate
             where bckou_code = Trec.bckou_code
               and bckback_ord_campaign = Trec.bckback_ord_campaign
               and bckrep_seq = Trec.bckrep_seq
               and bckback_seq = Trec.bckback_seq
               and bckbill_code = Trec.bckbill_code
               and bckbackorder_status = 0
            ; 
          
            Exception when no_data_found Then Begin null; End;
        End;
    End Loop;
  
END;


/*= 234
update om_backorder b
   set bckbill_code = '19250'
     , bckprog_id = 'SCRIPT'
     , bckupd_by = 'PERAPONG'
     , bckupd_date = sysdate
--select * from om_backorder b
where b.bckou_code = '000'
--and trunc(b.bckorder_date) between to_date('05/10/2012','dd/mm/rrrr') and to_date('12/10/2012','dd/mm/rrrr')
  and b.bckbill_code = '19253'
  and b.bckbackorder_status = 0
--and b.bckrep_code = '0961000086'
*/


        select trunc(b.bckorder_date) doc_date, bckrep_code rep_code, (select reprep_name  from ms_representative t where t.reprep_seq = b.bckrep_seq) rep_name
             , bckbill_code bill_code, bckback_unit back_unit
        from om_backorder b
        where b.bckou_code = '000'
        --and trunc(b.bckorder_date) between to_date('05/10/2012','dd/mm/rrrr') and to_date('12/10/2012','dd/mm/rrrr')
          and b.bckbill_code = '03156'
          and b.bckupd_by = 'PERAPONG'
          and b.bckbackorder_status = 0
          
          
update om_backorder b
   set bckback_ord_campaign = '022013'
     , bckbill_campaign = '022013'
     , bckprog_id = 'SCRIPT'
     , bckupd_by = 'PERAPONG'
     , bckupd_date = sysdate
--select * from om_backorder b
where b.bckou_code = '000'
--and trunc(b.bckorder_date) between to_date('05/10/2012','dd/mm/rrrr') and to_date('12/10/2012','dd/mm/rrrr')
  and b.bckbill_code in ('03197   03199','03201','03203','03261','03263','03257','03259','03265','03267'
                        ,'03301','03303','03337','03339','03341','03343','03345','03347','03349','03351'
                        ,'03353','03355','03365','03367','03393','03395','03229','03231','03301','03303'
                        ,'03377','03399','03373','03375','03405','03407','03409','03411','03413','03415'
                        ,'03417','03419','03421','03423','19250','00032','00034','00035','00653','00654')

  and b.bckbackorder_status = 0
  and b.bckback_ord_campaign = '012013'
--and b.bckrep_code = '0961000086'

select * from om_backorder 
where bckou_code = '000'
--and bckbill_code = '19250'
  and bckbackorder_status = 0
  and bckback_ord_campaign = '152013'
  and bckupd_by = 'PERAPONG'
  and trunc(bckupd_date) = trunc(sysdate)
--and bckrep_seq < 100
order by bckrep_seq
  
  
  
/***************************************************************************************************************************************************************
***************************************************************************************************************************************************************/
begin zp_stp_upd_backorder('142013', '162013', 'PERAPONG'); end; 
--create procedure zp_stp_upd_backorder (Parm_Oldcampign varchar2, Parm_Newcampign varchar2, Parm_UserID varchar2) IS
--สถานะรายการ (กำหนดให้ 0=Backorder, 1=Complete, 8=Delete, 9=Canceled)
declare
    cursor rec is
        select b.*
        from om_backorder b
        where b.bckou_code = '000'
          and b.bckback_ord_campaign = '152013'
          and b.bckbackorder_status = 0
          and b.bckrep_code not like '0999%'   
          and b.bckbill_code <> '00018'
          --and b.bckrep_seq = 6513556
          and not exists (select 1 from om_billing_hdr where bilou_code = b.bckou_code and bilcampaign = b.bckback_ord_campaign and bilbill_code = b.bckbill_code)
          order by bckrep_seq, bckbill_code
        ;
    vCamp VARCHAR2(10); 
    vMaxseq NUMBER;
    vRepseq NUMBER;
    
BEGIN
    vCamp := '162013';    
    vMaxseq := 0;
    vRepseq := 0;
    
    For Trec In Rec Loop
        if vRepseq <> Trec.bckrep_seq then
            Begin
               select  nvl(Max(bckback_seq),0) Seq 
                  Into vMaxseq
                 from om_backorder
                  where bckou_code           = Trec.bckou_code
                   and  bckback_ord_campaign = vCamp
                   and  bckrep_seq           = Trec.bckrep_seq;
               exception when no_data_found then begin vMaxseq := 0; end;
            End ;
        end if;
        
        vRepseq := Trec.bckrep_seq;
        vMaxseq := vMaxseq + 1;
        
        Begin 
            update om_backorder
               set bckback_ord_campaign = vCamp
                 , bckbill_campaign = vCamp
                 , bckorder_campaign = vCamp
                 , bckback_seq = vMaxseq
                 --, bckback_seq = Trec.newseq
                 , bckprog_id = 'SCRIPT'
                 , bckupd_by = 'PERAPONG'
                 , bckupd_date = sysdate
             where bckou_code = Trec.bckou_code
               and bckback_ord_campaign = Trec.bckback_ord_campaign
               and bckrep_seq = Trec.bckrep_seq
               and bckback_seq = Trec.bckback_seq
               and bckbill_code = Trec.bckbill_code
               and bckbackorder_status = 0
            ; 
          
            Exception when DUP_VAL_ON_INDEX Then Begin null; End;
            commit;
        End;
        
    End Loop;
  
END;

--select * from om_backorder where bckupd_by = 'PERAPONG' and bckback_ord_campaign = '062013'


