begin
    zp_pkg_test.remove_Member;
end;

declare
    vCampaign  VARCHAR2(6);
    vMailgroup VARCHAR2(2);
    dStartDate DATE;
    dEndDate   DATE;
BEGIN
    vCampaign  := '172013';
    vMailgroup := '08';
    dStartDate := to_date('14/08/2013','dd/mm/rrrr');
    dEndDate   := to_date('26/08/2013','dd/mm/rrrr');
    --dEndDate   := trunc(sysdate);

    Begin    
        insert into bwprod.db_member_dtl_ex 
        select mmdou_code, mmdclub_code, mmdrep_seq, mmdrep_code,
               mmdmember_cardid, mmdmember_date, mmdmember_campaign,
               mmdexpired_campaign, mmdmember_class, mmdinactive_status,
               mmdinactive_date, mmdupd_rep_seq, mmdupd_rep_date, mmdprog_id,
               mmdupd_by, mmdupd_date, 'AC' mmdex_code, sysdate mmdex_date
             --, pkgms_master.getrepname_byseq('000', mmdrep_seq) name
        from db_member_dtl d 
        where mmdou_code = '000' 
          and mmdclub_code = 'FA018' ;
          /*and exists (select * from bev$_mailplan where mplou_code = '000' and mplyear = 2013 and mplcampaign = vCampaign and mailgroup = vMailgroup
                         and loc_code = substr(d.mmdrep_code,1,4))  
          and not exists (select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and ohdtrans_date between dStartDate and dEndDate
                             and ohdrep_seq = d.mmdrep_seq and ohdord_flag_status in ('F','N','T'));*/
    End;
    
    Begin
        Delete
        --select *
        from db_member_dtl d 
        where mmdou_code = '000' 
          and mmdclub_code = 'FA018' ;
          /*and exists (select * from bev$_mailplan where mplou_code = '000' and mplyear = 2013 and mplcampaign = vCampaign and mailgroup = vMailgroup
                         and loc_code = substr(d.mmdrep_code,1,4))  
          and not exists (select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and ohdtrans_date between dStartDate and dEndDate
                             and ohdrep_seq = d.mmdrep_seq and ohdord_flag_status in ('F','N','T'));*/
    End;
End;    
       


--select * from bwprod.db_member_dtl_ex where trunc(mmdex_date) = trunc(sysdate)
--and mmdclub_code = 'FA017' and mmdrep_seq = 6557890

select mmdou_code, mmdclub_code, mmdrep_seq, mmdrep_code,
               mmdmember_cardid, mmdmember_date, mmdmember_campaign,
               mmdexpired_campaign, mmdmember_class, mmdinactive_status,
               mmdinactive_date, mmdupd_rep_seq, mmdupd_rep_date, mmdprog_id,
               mmdupd_by, mmdupd_date, 'AC' mmdex_code, sysdate mmdex_date
             --, pkgms_master.getrepname_byseq('000', mmdrep_seq) name
        from db_member_dtl d 
        where mmdou_code = '000' 
          and mmdclub_code = 'FA017' 
          and exists (select * from bev$_mailplan where mplou_code = '000' and mplyear = 2013 and mplcampaign = '172013' and mailgroup = '04'
                         and loc_code = substr(d.mmdrep_code,1,4))  
          and not exists (select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and ohdtrans_date between to_date('14/08/2013','dd/mm/rrrr') and to_date('20/08/2013','dd/mm/rrrr')
                             and ohdrep_seq = d.mmdrep_seq and ohdord_flag_status in ('F','N','T'));





select * from db_member_q


select * from bev$_mailplan where mplou_code = '000' and mplyear = 2013 and mplcampaign = '172013' and mailgroup = '01' and loc_code = '8100' -- substr(mmdrep_code,1,4)


select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and ohdtrans_date = trunc(sysdate) and ohdrep_seq = d.mmdrep_seq
and ohdord_flag_status in ('F','N','T')



DECLARE
  Cursor mainrec IS
    select sddou_code, sddcampaign, sddloc_code 
      from sa_daily_byloc_hdr
     where sddou_code = '000'
       and sddcampaign = '172013'
       and sddprocess_date = to_date('15/08/2013','dd/mm/rrrr')
       and sddno_of_order > 1;
BEGIN
    For MTrec In Mainrec Loop
        update sa_daily_byloc_hdr
                       set sddperc_activity = TRUNC((sddno_of_order / SDDNO_OF_ACTIVE) * 100,1)
                     where sddou_code = '000'
                       and sddcampaign = '172013'
                       and sddloc_code = MTrec.sddloc_code;
    End Loop;  --Mainrec
END;                       
                       
                       
                       
pkgbw_shpackage.cre_knappshiped


        select mmdou_code, mmdclub_code, mmdrep_seq, mmdrep_code,
               mmdmember_cardid, mmdmember_date, mmdmember_campaign,
               mmdexpired_campaign, mmdmember_class, mmdinactive_status,
               mmdinactive_date, mmdupd_rep_seq, mmdupd_rep_date, mmdprog_id,
               mmdupd_by, mmdupd_date, 'AC' mmdex_code, sysdate mmdex_date
             --, pkgms_master.getrepname_byseq('000', mmdrep_seq) name
        from db_member_dtl_ex d 
        where mmdou_code = '000' 
          and mmdclub_code = 'FA017' 
          and mmdrep_seq = 6557890
          and exists (select * from bev$_mailplan where mplou_code = '000' and mplyear = 2013 and mplcampaign = '172013' and mailgroup = '01'
                         and loc_code = substr(d.mmdrep_code,1,4))  
          and not exists (select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and ohdtrans_date between to_date('15/08/2013','dd/mm/rrrr') and to_date('15/08/2013','dd/mm/rrrr')
                             and ohdrep_seq = d.mmdrep_seq and ohdord_flag_status in ('F','N','T'));
                             
                             
create table perapong.zp_tmp_member as                             
select * from ms_representative r where repou_code = '000'
and repappt_campaign = '172013'
and reploc_code like '8%'
--and reprep_seq = 6557890
and exists (select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and trunc(ohdtrans_date) between to_date('14/08/2013','dd/mm/rrrr') and to_date('14/08/2013','dd/mm/rrrr')
                             and ohdrep_seq = r.reprep_seq and ohdord_flag_status in ('F','N','T'))
and not exists (select * from db_member_dtl where mmdou_code = '000' 
          and mmdclub_code = 'FA017' 
          and mmdrep_seq = r.reprep_seq)
and exists (select * from om_transaction_hdr where ohdou_code = '000' and ohdyear = 13 and ohdtrans_group = 11 and ohdord_campaign = '182013'
                             and ohdrep_seq = r.reprep_seq and ohdord_flag_status in ('F','N','T'))



------------------------------------------------------------------------------------------------------------------------------------------------------
------------              RECOVER MEMBER        ------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

insert into bwprod.db_member_dtl
select mmdou_code, mmdclub_code, mmdrep_seq, mmdrep_code,
       mmdmember_cardid, mmdmember_date, mmdmember_campaign,
       mmdexpired_campaign, mmdmember_class, mmdinactive_status,
       mmdinactive_date, mmdupd_rep_seq, mmdupd_rep_date, mmdprog_id,
       mmdupd_by, mmdupd_date
from bwprod.db_member_dtl_ex
where mmdou_code = '000' 
  and mmdclub_code = 'FA017' 
  and exists (select * from perapong.zp_tmp_member t where t.reprep_seq = mmdrep_seq);


delete from bwprod.db_member_dtl_ex
where mmdou_code = '000' 
  and mmdclub_code = 'FA017' 
  and exists (select * from perapong.zp_tmp_member t where t.reprep_seq = mmdrep_seq);


